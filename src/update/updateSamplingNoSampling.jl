
function initializeSampling!(sampling::NoSampling, mo::AbstractNLPModel; verbose::Bool = false)
    sampling.NMax = mo.nobs
end

function updateSampleSize!(sampling::NoSampling, state::AbstractSGDState; verbose::Bool=true)
end