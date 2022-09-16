
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

###################### Dynamic Sampling with sHs ###################
# mutable struct RandomSamplingDynamic <: AbstractDynamicRandomSampling
#     N0::Int
#     NMin::Int
#     NMinCurrent::Int
#     N::Int
#     NMax::Int
#     shu::Array{Int, 1}
#
#     commonVar::Bool
#     smoothing::AbstractSmoothing
#     subSampling::AbstractSubSampling
#
#     increment::Int
#
#     α_error::Float64
#     z_α::Float64
#     function RandomSamplingDynamic(;N0::Int=100, NMin::Int = 100,  NMax::Int = 12,
#                                         increment::Int=1,
#                                         commonVar::Bool = false,
#                                         smoothing::AbstractSmoothing = NoSmoothing(),
#                                         subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                                         α_error::Float64 = 0.05)
#         n = new()
#         # sample size constraints
#         n.N0 = N0
#         n.NMin = NMin
#         n.NMax = NMax
#         n.NMinCurrent = NMin
#         n.increment = increment
#         # sample size init
#         n.N = N0
#         # for sub-sampling
#         n.subSampling = subSampling
#         # For sample size calculation
#         n.α_error = α_error
#         n.z_α = quantile(Normal(), 1 - α_error)
#
#         # common var. or ind. var.
#         n.commonVar = commonVar
#         # for smoothing sample size
#         n.smoothing = smoothing
#         return n
#     end
# end
#
#
# ########################### Dynamic sampling with true Variance ########################3
# mutable struct RandomSamplingDynamicTrueVariance <: AbstractRandomDynamicTrueVar
#     N0::Int
#     NMin::Int
#     NMinCurrent::Int
#     N::Int
#     NMax::Int
#     shu::Array{Int, 1}
#
#     commonVar::Bool
#     smoothing::AbstractSmoothing
#     subSampling::AbstractSubSampling
#
#     increment::Int
#
#     α_error::Float64
#     z_α::Float64
#     function RandomSamplingDynamicTrueVariance(;N0::Int=100, NMin::Int = 100,  NMax::Int = 12,
#                                                 increment::Int=1,
#                                                 smoothing::AbstractSmoothing = NoSmoothing(),
#                                                 commonVar::Bool = false,
#                                                 subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                                                 α_error::Float64 = 0.05)
#             n = new()
#             # sample size constraints
#             n.N0 = N0
#             n.NMin = NMin
#             n.NMax = NMax
#             n.NMinCurrent = NMin
#             n.increment = increment
#             # sample size init
#             n.N = N0
#             # for sub-sampling
#             n.subSampling = subSampling
#             # For sample size calculation
#             n.α_error = α_error
#             n.z_α = quantile(Normal(), 1 - α_error)
#
#             # common variables or ind. var.
#             n.commonVar = commonVar
#             # for smoothing sample size
#             n.smoothing = smoothing
#         return n
#     end
# end

######################## sample ###########################3

# function sample(sampling::RandomSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
#     if (isHes)
#         # println("sampling isHes")
#         subSampleSize = computeSubSampleSize(sampling.subSampling, sampling.N, 1, sampling.N)
#         # println("Subsample size = ", subSampleSize)
#         return shuffle(sampling.shu)[1:subSampleSize]
#     elseif (isFunc || isGrad)
#         # println("sampling isFunc // isGrad")
#         return sampling.shu # renvoie le unit range des premiers indices
#     else
#         error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
#     end
# end
