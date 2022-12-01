

############################## Potential Sample Size ############################3

function potentialSampleSize(sampling::AbstractDynamicSampling, state::AbstractBTRState,
                                smoothing::AbstractSmoothing ; verbose::Bool = false)

    verbose && println("potentialSampleSize for Dynamic sampling")

    sigma2 = computeVariance(state, sampling.varStrategy)
    quantile = sampling.varStrategy.z_α

    potentialSize = ceil(Int, min((sigma2*quantile^2)/(state.mu^2), sampling.NMax))

    newcurrent = smoothingSize(sampling, smoothing, potentialSize, verbose = verbose)

    # newcurrent = ceil(Int, min((sigma2*quantile^2)/(state.mu^2), sampling.NMax))
    verbose && println("New size = ", newcurrent)

    # mise a jour de Current Size and NMinCurrent
    sampling.NMinCurrent += sampling.increment

    return newcurrent
end

function computeVariance(state::AbstractBTRState, varStrategy::TrueVar)
    return std(varStrategy.f_values_old .- varStrategy.f_values_cand; corrected=false)
end

function computeVariance(state::AbstractBTRState, varStrategy::FirstOrderVar)
    return state.sHs
end

function computeVariance(state::AbstractBTRState, varStrategy::FirstOrderVarApprox)
    throw("Implement computeVariance for $(typeof(varStrategy))")
end



function smoothingSize(sampling::AbstractSampling, smoothing::NoSmoothing, potentialSize::Int; verbose::Bool = false)
    verbose && println("Default smoothing --> Nothing done")
    return max(sampling.NMinCurrent, min(potentialSize, sampling.NMax))
end

function smoothingSize(sampling::AbstractSampling, smoothing::NaiveSmoothing, potentialSize::Int; verbose::Bool = false)
    verbose && println("Naive smoothing -- int = $(smoothing.coeffInf) / sup = $(smoothing.coeffSup)")
    Ninf = floor(Int, smoothing.coeffInf*sampling.N)
    Nsup = ceil(Int, smoothing.coeffSup*sampling.N)
    return max(Ninf, sampling.NMinCurrent, min(potentialSize, Nsup, sampling.NMax))
end

# Cumulative Decrease Smoothing
function smoothingSize(sampling::AbstractSampling, smoothing::CumulativeDecreaseSmoothing, potentialSize::Int; verbose::Bool = false)
    verbose && println("smoothingSize (True Var) : Cumulative")

    if (smoothing.mu >= smoothing.ϵ_CI) || (smoothing.numberIter == smoothing.maxIter)
        newcurrent = ceil(Int, max(sampling.NMinCurrent, min(potentialSize , sampling.NMax)))
        verbose && println("Modification size = ", newcurrent)
    else
        verbose && println("Sample Size stays the same")
        newcurrent = sampling.N
    end
    return newcurrent
end


include("updateSamplingDynamic.jl")
include("updateSamplingNoSampling.jl")
include("updateSamplingRandom.jl")
include("updateSamplingBatch.jl")
include("updateSamplingChoose1.jl")
