mutable struct AdamState{T, SAM <: AbstractSampling} <: AbstractState{T}
    iter::Int
    fx::T
    x::Vector{T}
    g::Vector{T}
    sampling::SAM
    time0::Float64
    time::Float64

    m::Vector  #first moment vector
    v::Vector # second moment vector

    function AdamState(x0::Vector{T}, s::SAM) where {T, SAM <: AbstractSampling}
        return new{T, SAM}(0, Inf, copy(x0), Array{T, 1}(undef, length(x0)), s, 0.0, 0.0, zeros(T, length(x0)), zeros(T ,length(x0)))
    end
end

struct AdamConstStep{T} <: AbstractSGD
    α::T
    β_1::T
    β_2::T
    ϵ_precision::T

    function AdamConstStep(α::T, β_1::T, β_2::T ; ϵ_precision::T = T(1e-8)) where T
        return new{T}(α, β_1, β_2, ϵ_precision)
    end
end

#### A travailler
struct AdamLR{f} <: AbstractSGD
    a::Int64
    b::Float64
    c::Float64
end
