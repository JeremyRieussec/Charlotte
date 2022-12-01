## ##############   For Random variables gestion #####################

# for type of random numbers used
abstract type AbstractRandomNumbers end
# Independent Random Numbers -> Each sample set is independent
struct IndRN <: AbstractRandomNumbers end
# Idependent and Common Random Numbers
struct IndComRN <: AbstractRandomNumbers end
# common Random Numbers
struct CommonRN <: AbstractRandomNumbers end


############################ Sampling ##########################3
abstract type AbstractSampling end

function initializeSampling!(sampling::AbstractSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    @warn "initializeSampling! not extended for sampling of type $(typeof(sampling))"
end

function updateSampleSize!(sampling::AbstractSampling, state::AbstractState; verbose::Bool=false)
    @warn "updateSampleSize! not extended for sampling of type $(typeof(sampling))"
end

function sample(sampling::AbstractSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    @warn "sample not extended for sampling of type $(typeof(sampling))"
    return sampling.shu
end



