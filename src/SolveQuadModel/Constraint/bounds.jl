
abstract type AbstractBoundsConstraint <: AbstractConstraint end

struct Bounds{T} <: AbstractBoundsConstraint
    lower::Array{T, 1}
    upper::Array{T, 1}
    function Bounds(lower::Array{T, 1}, upper::Array{T, 1}) where T
        @assert length(lower) == length(upper) "lower bounds and upper bounds have different length"
        return new{T}(lower, upper)
    end
end
copy(b::Bounds) = Bounds(copy(b.lower), copy(b.upper))

    

function reach(s::Vector, d::Vector, b::Bounds)
    if outside(s, b)
        println("s outside of bounds")
        return s
    end
    alpha = Inf
    n = length(s)
    for k in 1:n
        if d[k] < 0
            alpha = min((b.lower[k] - s[k])/ d[k], alpha)
        elseif d[k] > 0
            alpha = min((b.upper[k] - s[k])/ d[k], alpha)
        end
    end
    return alpha
end

function inside(s::Vector, b::Bounds)
    return all(s .>= b.lower) && all(s .<= b.upper)
end

or(x, y) = x || y
loweractive(xi, gi, li, eps::Float64 = 1e-8) = abs(xi - li) < eps && gi <= 0
upperactive(xi, gi, ui, eps::Float64 = 1e-8) = abs(xi - ui) < eps && gi >= 0

function genproj(x::Vector, H::Matrix, g::Vector, constraint::Bounds, eps::Float64 = 1e-9)
    activeSet = or.(loweractive.(x, g, constraint.lower), upperactive.(x, g, constraint.upper))
    return .!activeSet
end

function proj(x::Vector, bits::BitArray{1}, ::Type{Bounds{T}}) where T
    return x[bits]
end
function proj(m::Matrix, bits::BitArray{1}, ::Type{Bounds{T}}) where T
    return m[bits, bits]
end
function proj(bound::Bounds, bits::BitArray{1}, x::Vector, ::Type{Bounds{T}}) where T
    return Bounds(bound.lower[bits] - x[bits], bound.upper[bits] - x[bits])
end


function proj(bound::Norm2Constraint, bits::BitArray{1}, ::Type{Bounds{T}}) where T
    return bound
end

function deproj(x::Vector{S}, bits::BitArray{1}, ::Type{Bounds{T}}) where {T, S}
    xdeproj = zeros(S, length(bits))
    xdeproj[bits] = x
end


######################################################################

struct Norm1Bound{T} <: AbstractBoundsConstraint
    bound::T
    function Norm1Bound(bound::T) where T
        @assert bound > 0 "empty set"
        return new{T}(bound)
    end
end

function inside(s::Vector, b::Norm1Bound)
    return all(s .>= -b.bound) && all(s .<= b.bound)
end

function reach(s::Vector, d::Vector, b::Norm1Bound)
    if outside(s, b)
        println("s outside of bounds")
        return s
    end
    
    tmp1 = [k for k in ((s - b.bound)./d) if k > 0]
    tmp2 = [k for k in ((s - b.bound)./d) if k > 0]
    alpha1 = length(tmp1) == 0 ? Inf : minimum(tmp1)
    alpha2 = length(tmp2) == 0 ? Inf : minimum(tmp2)
    alpha = min(alpha1, alpha2)
    return alpha
end


######################################################################
struct SomeBounds <: AbstractBoundsConstraint
    indexsLow::AbstractVector
    indexsUpper::AbstractVector
    lower::AbstractVector
    upper::AbstractVector
    function SomeBounds(;indexsLow = [], indexsUpper = [], lower = [], upper = [])
        @assert length(indexsLow) == length(lower) "length of indexsLow != length(lower)"
        @assert length(indexsUpper) == length(upper) "length of indexsUpper != length(upper)"
        for (idx, lo) in zip(indexsLow, lower)
            if idx in ndexsUpper
                @assert lo <= upper[findfirst(t->t==idx, indexsUpper)]
            end
        end
        return new(indexsLow, indexsUpper, lower, upper)
    end
end

function inside(s::Vector, b::SomeBounds)
    return all(s[b.indexsLow] .>= b.lower) && all(s[b.indexsUpper] .>= b.upper)
end

function reach(s::Vector, d::Vector, b::SomeBounds)
    if outside(s, b)
        println("s outside of bounds")
        return s
    end
    tmp1 = [k for k in ((s - b.lower)./d) if k > 0]
    tmp2 = [k for k in ((s - b.upper)./d) if k > 0]
    alpha1 = length(tmp1) == 0 ? Inf : minimum(tmp1)
    alpha2 = length(tmp2) == 0 ? Inf : minimum(tmp2)
    alpha = min(alpha1, alpha2)
    @assert alpha != Inf "problem unbounded at s in the direction d, \n s = $s \n d = $d"
    return alpha
end

######################################################################

function combine(b1::Bounds{T}, b2::Norm1Bound) where T
    b = copy(b1)
    b.lower[:] = max.(b.lower, -b2.bound)
    b.upper[:] = min.(b.upper, b2.bound)
end
    