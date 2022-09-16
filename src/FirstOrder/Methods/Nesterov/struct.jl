
mutable struct NesterovState{T, SAM <: AbstractSampling} <: AbstractState{T}
    iter::Int
    fx::T
    x::Vector{T}
    v::Vector{T}
    g::Vector{T}
    sampling::SAM
    time0::Float64
    time::Float64
    function NesterovState(x0::Vector{T}, s::SAM) where {T, SAM <: AbstractSampling}
        return new{T, SAM}(0, Inf, copy(x0), zeros(T,length(x0)), Array{T, 1}(undef, length(x0)), s, 0.0, 0.0)
    end
end

struct NesterovConstStep{T} <: AbstractSGD
    μ_momentum::T
    ϵ_rate::T

    function NesterovConstStep(μ_momentum::T, ϵ_rate::T) where T
        return new{T}(μ_momentum, ϵ_rate)
    end
end


struct NesterovLR{T, f, g} <: AbstractSGD
    a::Int64
    b::T
    c::T
    function NesterovLR{f, g}(a::Int64, b::T, c::T) where {T, f, g}
        return new{T, f, g}(a, b, c)
    end
end
