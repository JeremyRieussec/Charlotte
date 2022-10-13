mutable struct AdamState{T} <: AbstractSGDState
    iter::Int
    fx::T
    x::Vector{T}
    g::Vector{T}
    time0::Float64
    time::Float64

    m::Vector  #first moment vector
    v::Vector # second moment vector

    function AdamState(x0::Vector{T}) where {T}
        return new{T}(0, Inf, copy(x0), Array{T, 1}(undef, length(x0)), 0.0, 0.0, zeros(T, length(x0)), zeros(T ,length(x0)))
    end
end

struct AdamConstStep{T} <: AdamOptimizer
    alpha::T
    β_1::T
    β_2::T
    ϵ_precision::T

    function AdamConstStep(alpha::T, β_1::T, β_2::T ; ϵ_precision::T = T(1e-8)) where T
        return new{T}(alpha, β_1, β_2, ϵ_precision)
    end
end

#### A travailler
struct AdamLR{f} <: AdamOptimizer
    a::Int64
    b::Float64
    c::Float64
end


function genstate(sgd::AdamOptimizer, mo::AbstractNLPModel)
    return AdamState(mo.meta.x0)
end