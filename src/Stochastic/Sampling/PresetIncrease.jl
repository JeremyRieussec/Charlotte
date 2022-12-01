
function geometricIncrease(N0::Int, N::Int, NMax::Int, iter::Int)
    return min(round(Int, N*1.2), NMax)
end

mutable struct PresetIncrease{RN <: AbstractRandomNumbers} <: AbstractSampling
    N::Int
    N0::Int
    NMax::Int

    sizeSample::Function
    rng::AbstractRNG

    shu::Array{Int, 1}

    function PresetIncrease{RN}(N0::Int, NMax::Int, sizeSample::Function; 
                                rng::AbstractRNG = MersenneTwister(1234)) where RN <: AbstractRandomNumbers
        return new{RN}(N0, N0, NMax, sizeSample, rng, [-1])
    end

    function PresetIncrease(N0::Int, NMax::Int; 
                                sizeSample::Function = geometricIncrease, 
                                rng::AbstractRNG = MersenneTwister(1234))
        return new{IndRN}(N0, N0, NMax, sizeSample, rng, [-1])
    end
end

##############################  initializeSampling!   ###########################################
function initializeSampling!(sampling::PresetIncrease{RN}, mo::AbstractStochasticNLPModels; verbose::Bool = false) where RN <: IndRN 
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

function initializeSampling!(sampling::PresetIncrease{RN}, mo::AbstractStochasticNLPModels; verbose::Bool = false) where RN <: IndComRN
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

function initializeSampling!(sampling::PresetIncrease{RN}, mo::AbstractStochasticNLPModels; verbose::Bool = false) where RN <: CommonRN
    sampling.shu = 1:sampling.N
end

##############################  updateSampleSize!  ###########################################3
function updateSampleSize!(sampling::PresetIncrease{RN}, state::AbstractState; verbose::Bool = false) where RN <: IndRN 
    sampling.N = sampling.sizeSample(sampling.N0, sampling.N, sampling.NMax, state.iter)

    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

function updateSampleSize!(sampling::PresetIncrease{RN}, state::AbstractState; verbose::Bool = false) where RN <: IndComRN
    newcurrent = sampling.sizeSample(sampling.N0, sampling.N, sampling.NMax, state.iter)

    # sample size increases
    diffSize = newcurrent - sampling.N
    verbose && println("- Increase !! with ", diffSize)
    diffSet = setdiff(1:sampling.NMax, sampling.shu)
    addSet = shuffle(diffSet)[1:diffSize]
    sampling.shu = union(sampling.shu, addSet)

    sampling.N = newcurrent
end

function updateSampleSize!(sampling::PresetIncrease{RN}, state::AbstractState; verbose::Bool = false) where RN <: CommonRN
    sampling.N = sampling.sizeSample(sampling.N0, sampling.N, sampling.NMax, state.iter)

    sampling.shu = 1:sampling.N
end

##############################  sample  ###########################################
function sample(sampling::PresetIncrease; isFunc::Bool = true, isGrad::Bool = false, isHes::Bool = false)
    if (isHes)
        @warn "$(typeof(sampling)) not defined for Hessian yet"
    elseif (isFunc || isGrad)
        return sampling.shu # renvoie le unit range des premiers indices
    else
        error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
    end
end