abstract type AbstractConstantSampling <: AbstractSampling end

mutable struct RandomSampling <: AbstractConstantSampling
    N::Int
    NMax::Int
    shu::Array{Int, 1}

    function RandomSampling(;N::Int = 100, NMax::Int = 10)
        n = new()
        n.NMax = NMax
        n.N = N
        return n
    end
end

############################# initialize! ###############################
function initializeSampling!(sampling::RandomSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    sampling.shu = Array{Int, 1}(undef, sampling.N)
    sampling.shu[:] = randperm(sampling.NMax)[1:sampling.N]
end

#################################  Update  ####################################3
function updateSampleSize!(sampling::RandomSampling, state::AbstractState; verbose::Bool = false)
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

#################################  sample  ####################################3
function sample(sampling::RandomSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    if (isHes)
        @warn "$(typeof(sampling)) not defined for Hessian yet"
    elseif (isFunc || isGrad)
        return sampling.shu # renvoie le unit range des premiers indices
    else
        error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
    end
end
