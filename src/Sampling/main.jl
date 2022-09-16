abstract type AbstractSampling end

function initializeSampling!(sampling::AbstractSampling, mo::AbstractNLPModel; verbose::Bool = verbose)
    verbose && println("sampling $(typeof(sampling)) initialized")
end
abstract type AbstractDynamicSampling <: AbstractSampling end

abstract type AbstractConstantSampling <: AbstractSampling end


# # For doing variable SAA with common variables
# abstract type AbstractSAASampling <: AbstractSampling end
#
# abstract type AbstractTrueVarSAA <: AbstractSAASampling end


# For doing SA with independant variables
# abstract type  AbstractRandomSampling <: AbstractSampling end
#
# abstract type AbstractDynamicRandomSampling <: AbstractRandomSampling end
#
# abstract type AbstractRandomDynamicTrueVar <: AbstractRandomSampling end

mutable struct NoSampling <: AbstractSampling
    NMax::Int
    NoSampling(NMax::Int) = new(NMax)
    NoSampling() = new(-1)
end
function sample(ns::NoSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    return 1:ns.NMax
end

function sample(sampling::AbstractSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    if (isHes)
        # println("sampling isHes")
        subSampleSize = computeSubSampleSize(sampling.subSampling, sampling.N, 1, sampling.N)
        # println("Subsample size = ", subSampleSize)
        return shuffle(sampling.shu)[1:subSampleSize]
    elseif (isFunc || isGrad)
        # println("sampling isFunc // isGrad")
        return sampling.shu # renvoie le unit range des premiers indices
    else
        error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
    end
end



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


## ##############   For Random variables gestion #####################

# for type of random numbers used
abstract type AbstractRandomNumbers end

# Independent Random Numbers -> Each sample set is independent
struct IndRN <: AbstractRandomNumbers end

# Idependent and Common Random Numbers
struct IndComRN <: AbstractRandomNumbers end

# common Random Numbers
struct CommonRN <: AbstractRandomNumbers end

## ##############     For Variance calculation     #####################

abstract type AbstractVar end

mutable struct TrueVar{T} <: AbstractVar
    f_old::T
    f_cand::T
    f_cur::T

    f_values_old::Array{T, 1}
    f_values_cand::Array{T, 1}
    f_values_cur::Array{T, 1}

    smoothing::AbstractSmoothing

    α_error::T
    z_α::T
    function TrueVar{T}(smoothing::AbstractSmoothing ;
                            α_error::T = T(0.05)) where T
        z_α = quantile(Normal(), 1 - α_error)

        return new{T}(zero(T), zero(T), zero(T), T[], T[], T[], smoothing, T(α_error), T(z_α))
    end
end

mutable struct FirstOrderVar{S<:AbstractSampling} <: AbstractVar
    smoothing::AbstractSmoothing

    α_error::Float64
    z_α::Float64

    function FirstOrderVar( sam::Type{S}, smoothing::AbstractSmoothing;
                            α_error::Float64 = 0.05) where {S<:AbstractSampling}

        z_α = quantile(Normal(), 1 - α_error)

        return new{S}(smoothing, α_error, z_α)
    end
end

mutable struct FirstOrderVarApprox{S<:AbstractSampling} <: AbstractVar
    smoothing::AbstractSmoothing

    α_error::Float64
    z_α::Float64

    function FirstOrderVarApprox(sam::Type{S}, smoothing::AbstractSmoothing ;
                            α_error::Float64 = 0.05) where {S<:AbstractSampling}

        z_α = quantile(Normal(), 1 - α_error)

        return new{S}(smoothing, α_error, z_α)
    end
end



## ############### For Hessian gestion -- SubSampling #################

### Not done yet
#       - variable subsample size --> see Krejic

abstract type AbstractSubSampling end

struct ConstantSizeSubSampling <: AbstractSubSampling
    N::Int
    ConstantSizeSubSampling(N::Int) = new(N)
end

struct ConstantCoeffSubSampling <: AbstractSubSampling
    Nmax::Int
    coeff::Float64
    ConstantCoeffSubSampling(maxSize::Int, coeff::Float64) = new(maxSize, coeff)
end


################# function computation sub-sample size ###################
function computeSubSampleSize(subSampling::ConstantSizeSubSampling, N::Int, minSize::Int, maxSize::Int)
    return max(minSize , min(subSampling.N, maxSize))
end

function computeSubSampleSize(subSampling::ConstantCoeffSubSampling, N::Int, minSize::Int, maxSize::Int)
    return max(minSize , min(ceil(Int, subSampling.coeff*N), maxSize, subSampling.Nmax))
end


##### println
import Base.println

function println(subSampling::ConstantCoeffSubSampling)
    println("Constant coefficient subSampling : \n" )
    println(" - max size = $(subSampling.Nmax)\n")
    println(" - coeff = $(subSampling.coeff)\n")
end

import Base.write

function write(io::IOStream, subSampling::ConstantCoeffSubSampling)
    write(io,"Constant coefficient subSampling : \n" )
    write(io," - max size = $(subSampling.Nmax)\n")
    write(io, " - coeff = $(subSampling.coeff)\n")
end

function write(io::IOStream, subSampling::ConstantSizeSubSampling)
    write(io, "Constant coefficient subSampling \n" )
    write(io, " - max size = $(subSampling.Nmax) \n")
end

include("Dynamic.jl")
include("PresetIncrease.jl")
include("Random.jl")
include("Minibatch.jl")
include("Choose1.jl")
