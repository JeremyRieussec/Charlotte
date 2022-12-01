abstract type AbstractConstraint end
struct Unconstraint <: AbstractConstraint end

function inside(s::Vector, uc::Unconstraint)
    return true
end
include("norm.jl")
include("bounds.jl")

function outside(s::Vector, b::AbstractConstraint)
    return !inside(s, b)
end

struct CombinedConstraint <: AbstractConstraint
    constraint::Array{AbstractConstraint}
    function CombinedConstraint(constraints::AbstractConstraint...)
        return new([constraints...])
    end
    function CombinedConstraint(constraints::Array{AbstractConstraint, 1})
        return new(constraints)
    end
end
function combine(constraints::AbstractConstraint...)
    return CombinedConstraint(constraints...)
end
function combine(c::AbstractConstraint, u::Unconstraint)
    return deepcopy(c)
end
function combine(u::Unconstraint, c::AbstractConstraint)
    return deepcopy(c)
end
function inside(s::Vector, cc::CombinedConstraint)
    return all(inside(s, c) for c in cc.constraint)
end

function reach(s::Vector, d::Vector, cc::CombinedConstraint)
    dists = [reach(s, d, c) for c in cc.constraint]
    return minimum(dists)
end

function proj(c::CombinedConstraint, projstate, ::Type{T}) where {T <: AbstractConstraint}
    return CombinedConstraint([proj(ci, projstate, T) for ci in c.constraint])
end


