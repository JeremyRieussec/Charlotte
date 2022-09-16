
mutable struct SGDState{T, SAM <: AbstractSampling} <: AbstractSGDState{T, SAM}
    iter::Int
    fx::T
    x::Vector{T}
    g::Vector{T}
    sampling::SAM
    time0::Float64
    time::Float64
    function SGDState(x0::Vector{T}, s::SAM) where {T, SAM <: AbstractSampling}
        return new{T , SAM}(0, Inf, copy(x0), Array{T, 1}(undef, length(x0)), s, 0.0, 0.0)
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

function genstate(sgd::AbstractSGD, mo::AbstractNLPModel, ::Type{SAM} = NoSampling) where {SAM <: AbstractSampling}
    return SGDState(mo.meta.x0, SAM())
end