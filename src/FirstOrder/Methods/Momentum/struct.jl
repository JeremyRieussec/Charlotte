
mutable struct MomentumState{T, SAM <: AbstractSampling} <: AbstractState{T}
    iter::Int
    fx::T
    x::Vector{T}
    v::Vector{T}
    g::Vector{T}
    sampling::SAM
    time0::Float64
    time::Float64
    function MomentumState(x0::Vector{T}, s::SAM) where {T, SAM <: AbstractSampling}
        return new{T, SAM}(0, Inf, copy(x0), zeros(T, length(x0)), Array{T, 1}(undef, length(x0)), s, 0.0, 0.0)
    end
end

struct MomentumConstStep{T} <: AbstractSGD
    α::T
    ϵ::T
    function MomentumConstStep(α::T, ϵ::T) where T
        return new{T}(α, ϵ)
    end
end


struct MomentumLR{f, g} <: AbstractSGD
    a::Int64
    b::Float64
    c::Float64
end
