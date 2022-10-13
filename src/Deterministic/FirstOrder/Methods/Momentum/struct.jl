
mutable struct MomentumState{T} <: AbstractSGDState
    iter::Int
    fx::T
    x::Vector{T}
    v::Vector{T}
    g::Vector{T}
    time0::Float64
    time::Float64
    function MomentumState(x0::Vector{T}) where {T}
        return new{T}(0, Inf, copy(x0), zeros(T, length(x0)), Array{T, 1}(undef, length(x0)), 0.0, 0.0)
    end
end

struct MomentumConstStep{T} <: MomentumOptimizer
    alpha::T
    epsilon::T
    function MomentumConstStep(alpha::T, epsilon::T) where T
        return new{T}(alpha, epsilon)
    end
end


struct MomentumLR{f, g} <: MomentumOptimizer
    a::Int64
    b::Float64
    c::Float64
end

function genstate(sgd::MomentumOptimizer, mo::AbstractNLPModel)
    return MomentumState(mo.meta.x0)
end