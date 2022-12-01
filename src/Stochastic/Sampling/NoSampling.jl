#####################  No sampling #################
mutable struct NoSampling <: AbstractSampling
    N::Int
    NMax::Int
    shu::Array{Int, 1}

    subsampling::ConstantCoeffSubSampling

    NoSampling(NMax::Int, coeff::Float64) = new(NMax, NMax, 1:NMax, ConstantCoeffSubSampling(NMax, coeff))
    NoSampling(NMax::Int) = new(NMax, NMax, 1:NMax, ConstantCoeffSubSampling(NMax, 0.1))
    NoSampling() = new(-1, -1, [-1], ConstantCoeffSubSampling(-1, 0.1))
end

function initializeSampling!(sampling::NoSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    # Nothing to do 
end

function updateSampleSize!(sampling::NoSampling, state::AbstractState; verbose::Bool=false)
    # nothing to do 
end

function sample(sampling::NoSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    if (isHes)
        subSampleSize = computeSubSampleSize(sampling.subSampling, sampling.N, 1, sampling.N)
        return shuffle(sampling.shu)[1:subSampleSize]
    elseif (isFunc || isGrad)
        return sampling.shu # renvoie le unit range des premiers indices
    else
        error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
    end
end