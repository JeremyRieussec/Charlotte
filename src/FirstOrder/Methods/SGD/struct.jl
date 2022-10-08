mutable struct SGDState{T} <: AbstractSGDState
    iter::Int
    fx::T
    x::Vector{T}
    g::Vector{T}
    time0::Float64
    time::Float64
    function SGDState(x0::Vector{T}) where {T}
        return new{T}(0, Inf, copy(x0), Array{T, 1}(undef, length(x0)), 0.0, 0.0)
    end
end

struct SGDConstStep{T} <: AbstractSGD
    alpha::T
    function SGDConstStep(alpha::T) where T
        return new{T}(alpha)
    end
end

struct SGDLR{f} <: AbstractSGD
    a::Int64
    b::Float64
    c::Float64
end

function genstate(sgd::AbstractSGD, mo::AbstractNLPModel)
    return SGDState(mo.meta.x0)
end