
## ############################# initialize! ###############################

function initializeSampling!(sampling::RandomSampling, mo::AbstractNLPModel; verbose::Bool = false)
    sampling.shu = Array{Int, 1}(undef, sampling.N)
    sampling.shu[:] = randperm(sampling.NMax)[1:sampling.N]
end

## #################################  Update  ####################################3

########################## For First-order ###############################
function updateSampleSize!(sampling::RandomSampling, state::AbstractState, iter::Int; verbose::Bool = false)
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end
