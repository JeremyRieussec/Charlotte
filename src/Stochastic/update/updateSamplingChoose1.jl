function updateSampleSize!(sampling::Choose1, state::AbstractState, iter::Int; verbose::Bool = false)
    sampling.k = rand(sampling.rng, 1:sampling.NMax)
end

function initializeSampling!(sampling::Choose1, mo::AbstractNLPModel; verbose::Bool = false)
    # sampling.NMax = Nobs(mo)
    sampling.k = rand(sampling.rng, 1:sampling.NMax)
end
