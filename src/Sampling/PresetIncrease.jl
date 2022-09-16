function sizeSampleStandard(it::Int, N::Int)
    it = max(1, it)
    min(it * round(Int, N/100), N)
end
function geometricIncrease(it::Int, N::Int)
    it = max(1, it)
    round(Int, min(100*1.2^it, N))
end
mutable struct PresetIncrease <: AbstractSampling
    perm::Array{Int, 1}
    sizeSample::Function
    iter::Int
    function PresetIncrease(N::Int; sizeSample::Function = it -> sizeSampleStandard(it, N), 
            rng::AbstractRNG = MersenneTwister(1234))
        perm = randperm(rng, N)
        return new(perm, sizeSample, 0)
    end
end

function updateSampleSize!(sampling::PresetIncrease, x::Vector, iter::Int)
    sampling.iter = iter
end

function sample(sampling::PresetIncrease; isFunc::Bool = true, isGrad::Bool = false, isHes::Bool = false)
    to = sampling.sizeSample(sampling.iter)
    return sampling.perm[1:to]
end

function initializeSampling!(sampling::PresetIncrease)
    sampling.iter = 0
end