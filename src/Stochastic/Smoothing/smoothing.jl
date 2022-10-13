## ############## For smoothing #####################

abstract type AbstractSmoothing end

mutable struct NoSmoothing <: AbstractSmoothing
    NoSmoothing() = new()
end

mutable struct NaiveSmoothing <: AbstractSmoothing
    coeffInf::Float64
    coeffSup::Float64
    NaiveSmoothing(;coeffInf::Float64 = 0.75, coeffSup::Float64 = 2.0) = new(coeffInf, coeffSup)
end

mutable struct CumulativeDecreaseSmoothing{T} <: AbstractSmoothing
    mu::T
    ϵ_CI::T
    numberIter::Int
    maxIter::Int
    function CumulativeDecreaseSmoothing{T}(;maxIter::Int=5) where T
        return new{T}(T(0.0), T(0.0), 1, maxIter)
    end
end

mutable struct SameOverIter <: AbstractSmoothing
    iterToDo::Int
    numberIter::Int
    maxIter::Int
    SameOverIter(;maxIter::Int=5) = new(1, 1, maxIter)
end

mutable struct NaiveSmoothingOverIter <: AbstractSmoothing
    iterToDo::Int
    numberIter::Int
    maxIter::Int
    coeffInf::Float64
    coeffSup::Float64

    NaiveSmoothingOverIter(;maxIter::Int=5, coeffInf::Float64 = 0.75, coeffSup::Float64 = 2.0) = new(1, 1, maxIter, coeffInf, coeffSup)
end
