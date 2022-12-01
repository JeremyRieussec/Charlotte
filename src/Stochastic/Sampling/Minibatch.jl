abstract type AbstractBatchSampling <: AbstractSampling end

mutable struct BatchSampling{SHU} <: AbstractBatchSampling
    N::Int
    start::Int #curent batch
    NMax::Int
    shu::SHU

    function BatchSampling{SHU}(;N::Int = 100, NMax::Int = 10) where SHU
        n = new{SHU}()
        n.start = 1
        n.NMax = NMax
        n.N = N
        return n
    end
    function BatchSampling(;N::Int = 100, NMax::Int = 10)
        n = new{UnitRange{Int64}}()
        n.start = 1
        n.NMax = NMax
        n.N = N
        return n
    end
end

############## initializeSampling! #####################
function initializeSampling!(sampling::BatchSampling{SHU}, mo::AbstractStochasticNLPModels; verbose::Bool = false) where SHU
    sampling.shu = SHU(1:sampling.NMax)
    sampling.start = 1
end

################   updateSampleSize!   ######################
function updateSampleSize!(sampling::BatchSampling{SHU}, state::AbstractState; verbose::Bool = false) where SHU
    if sampling.start + sampling.N > sampling.NMax
        N1 = sampling.NMax - sampling.start
        N2 = sampling.N - N1
        sampling.start = N2
    else
        sampling.start += sampling.N
    end
end

############## sample #####################
function sample(sampling::BatchSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    if (isHes)
        @warn "$(typeof(sampling)) not defined for Hessian yet"
    elseif (isFunc || isGrad)
        if sampling.start + sampling.N <= sampling.NMax
            return sampling.shu[sampling.start:sampling.start+sampling.N-1]
        else
            N1 = sampling.NMax - sampling.start
            N2 = sampling.N - N1
            return union(sampling.shu[sampling.start:sampling.NMax], sampling.shu[1:N2-1])
        end
    else
        error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
    end
end


########################## Dynamic ##################################
abstract type AbstractDynamicBatchSampling <: AbstractBatchSampling end

# Pour creer un minibatch qui peut changer de taille


