abstract type AbstractDynamicSampling <: AbstractSampling end

mutable struct DynamicSampling{I <: AbstractRandomNumbers, T} <: AbstractDynamicSampling
    NMin::Int
    N0::Int
    NMinCurrent::Int
    N::Int
    NMax::Int
    increment::Int # increment for the NMin Current

    shu::AbstractArray{T, 1}
    subSampling::AbstractSubSampling

    varStrategy::AbstractVar

    function DynamicSampling{I}(NMax::Int, varStrategy::AbstractVar ; N0::Int=100, NMin::Int = 100, increment::Int=1,
                            subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
                            ) where {I <: AbstractRandomNumbers}
            T = Int64
            n = new{I, T}()
            # sample size constraints
            n.N0 = N0
            n.NMin = NMin
            n.NMax = NMax
            n.NMinCurrent = NMin
            n.increment = increment

            # sample size init
            n.N = N0

            # variance strategy
            n.varStrategy = varStrategy

            # for sub-sampling
            n.subSampling = subSampling

        return n
    end
end

######################## sample ###########################3

# function sample(sampling::AbstractDynamicSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false) where {I <: IndRN, T}
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


################## For sHS ######################

# mutable struct DynamicSAA{T} <: AbstractSAASampling
#     NMin::Int
#     N0::Int
#     NMinCurrent::Int
#     N::Int
#     NMax::Int
#     shu::T
#
#     smoothing::AbstractSmoothing
#     subSampling::AbstractSubSampling
#
#     increment::Int # increment for the NMin Current
#     α_error::Float64
#     z_α::Float64
#     function DynamicSAA(;N0::Int=100, NMin::Int = 100, NMax::Int = 12, increment::Int=1,
#                             smoothing::AbstractSmoothing = NoSmoothing(),
#                             subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                             α_error::Float64 = 0.05)
#             T = UnitRange{Int64}
#             n = new{T}()
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
#             # for smoothing sample size
#             n.smoothing = smoothing
#         return n
#     end
#     function DynamicSAA{T}(;NMin::Int = 100, NMax::Int = 12, increment::Int=1,
#                             smoothing::AbstractSmoothing = NoSmoothing(),
#                             subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                             α_error::Float64 = 0.05) where T
#             n = new{T}()
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
#             # for smoothing sample size
#             n.smoothing = smoothing
#         return n
#     end
# end

##################### For TRUE Variance #############################

# mutable struct TrueVarDynamicSAA{T} <: AbstractTrueVarSAA
#     NMin::Int
#     N0::Int
#     NMinCurrent::Int
#     N::Int
#     NMax::Int
#     shu::T
#
#     smoothing::AbstractSmoothing
#     subSampling::AbstractSubSampling
#
#     increment::Int
#
#     α_error::Float64
#     z_α::Float64
#     function TrueVarDynamicSAA(;N0::Int=100, NMin::Int = 100, NMax::Int = 12,
#                                     increment::Int=1,
#                                     smoothing::AbstractSmoothing = NoSmoothing(),
#                                     subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                                     α_error::Float64 = 0.05)
#             # println("Creation dynamic sampling UnitRange{Int64}")
#             T = UnitRange{Int64}
#             n = new{T}()
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
#             # for smoothing sample size
#             n.smoothing = smoothing
#         return n
#     end
#     function TrueVarDynamicSAA{T}(;N0::Int=100, NMin::Int = 100, NMax::Int = 12,
#                                     increment::Int=1,
#                                     smoothing::AbstractSmoothing = NoSmoothing(),
#                                     subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1),
#                                     α_error::Float64 = 0.05) where T
#             # println("Creation dynamic sampling T")
#             n = new{T}()
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
#             # for smoothing sample size
#             n.smoothing = smoothing
#         return n
#     end
# end

######################## Quadratic growth ################################
# mutable struct TVDynamicSamplingQuad{T} <: AbstractTrueVarSAA
#     NMin::Int # size min
#     N0::Int # initial size
#     NMinCurrent::Int
#     N::Int # current sample size
#     NMax::Int # N population
#     coeff_q::Float64 # coefficient for the quadratic growth
#     shu::T
#
#     subSampling::AbstractSubSampling
#
#     increment::Int
#     function TVDynamicSamplingQuad(;N0::Int=100, NMin::Int = 100, coeff_q::Float64=1.0, increment::Int=1,
#                                         subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1))
#             # println("Creation dynamic sampling UnitRange{Int64}")
#             T = UnitRange{Int64}
#             n = new{T}()
#             n.NMin = NMin
#             n.N0 = N0
#             n.N = N0
#             n.NMinCurrent = NMin
#             n.coeff_q = coeff_q
#             n.subSampling = subSampling
#             n.increment = increment
#         return n
#     end
#     function TVDynamicSamplingQuad{T}(;N0::Int=100, NMin::Int = 100, coeff_q::Float64=1.0, increment::Int=1,
#                                         subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1)) where T
#             # println("Creation dynamic sampling T")
#             n = new{T}()
#             n.NMin = NMin
#             n.N0 = N0
#             n.N = N0
#             n.NMinCurrent = NMin
#             n.coeff_q = coeff_q
#             n.subSampling = subSampling
#             n.increment = increment
#         return n
#     end
# end

################################### Cesaro #################################
# mutable struct TVDynamicSamplingPartialCesaro{T} <: AbstractTrueVarSAA
#     NMin::Int # size min
#     N0::Int # initial size
#     NMinCurrent::Int
#     N::Int # current sample size
#     NMax::Int # N population
#     shu::T
#
#     subSampling::AbstractSubSampling
#
#     Nprev::Int
#     sizePrev::Array{Int, 1}
#
#     increment::Int
#     function TVDynamicSamplingPartialCesaro(;N0::Int=100, NMin::Int = 100, Nprev::Int=2,
#                                                 sizePrev::Array{Int, 1}=Int[] , increment::Int=1,
#                                                 subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1))
#             # println("Creation dynamic sampling UnitRange{Int64}")
#             T = UnitRange{Int64}
#             n = new{T}()
#             n.NMin = NMin
#             n.N0 = N0
#             n.N = N0
#             n.NMinCurrent = NMin
#             n.Nprev = Nprev
#             n.sizePrev = sizePrev
#             n.subSampling = subSampling
#             n.increment = increment
#         return n
#     end
#     function TVDynamicSamplingPartialCesaro{T}(;N0::Int=100, NMin::Int = 100, Nprev::Int=2,
#                                                     sizePrev::Array{Int, 1}=Int[] , increment::Int=1,
#                                                     subSampling::AbstractSubSampling=ConstantCoeffSubSampling(100, 0.1)) where T
#             # println("Creation dynamic sampling T")
#             n = new{T}()
#             n.NMin = NMin
#             n.N0 = N0
#             n.N = N0
#             n.NMinCurrent = NMin
#             n.Nprev = Nprev
#             n.sizePrev = sizePrev
#             n.subSampling = subSampling
#             n.increment = increment
#         return n
#     end
# end

# ########################### sample ##############################
# function sample(sampling::AbstractSAASampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
#     # println("Sample SAA")
#     if (isHes)
#         # println("sampling isHes")
#         subSampleSize = computeSubSampleSize(sampling.subSampling, sampling.N, 1, sampling.N)
#         # println("Subsample size = ", subSampleSize)
#         return shuffle(sampling.shu[1:sampling.N])[1:subSampleSize]
#     elseif (isFunc || isGrad)
#         # println("sampling isFunc // isGrad")
#         return sampling.shu[1:sampling.N] # renvoie le unit range des premiers indices
#     else
#         error("Configuration sampling defaulting, check isFunc, isGrad or isHes to be true")
#     end
# end


######################## println ################################
# import Base.println
#
# function println(samplingStrategy::TrueVarDynamicSAA{T}) where T
#     println("---- True Var Dynamic SAA  ----")
#     println("NMin = ", samplingStrategy.NMin)
#     println("NMax = ", samplingStrategy.NMax)
#     println("increment = " ,samplingStrategy.increment)
#     println("N  = ", samplingStrategy.N)
#     println("shu = ", samplingStrategy.shu)
#     println("α error = ", samplingStrategy.α_error)
#     println("quantile = ", samplingStrategy.z_α)
# end
#
# function println(samplingStrategy::TVDynamicSamplingQuad{T}) where T
#     println("---- TrueVarDynamicSampling Quadratic Growth with type $(typeof(samplingStrategy.shu)) ----")
#     println("coeff growth = ", samplingStrategy.coeff_q)
#     println("NMin = ", samplingStrategy.NMin)
#     println("NMax = ", samplingStrategy.NMax)
#     println("shu = ", samplingStrategy.shu)
#     println("Current size  = ", samplingStrategy.N)
# end
#
# function println(samplingStrategy::TVDynamicSamplingPartialCesaro{T}) where T
#     println("---- TrueVarDynamicSampling Partial Cesaro Growth with type $(typeof(samplingStrategy.shu)) ----")
#     println("N prvious = ", samplingStrategy.Nprev)
#     println("NMin = ", samplingStrategy.NMin)
#     println("NMax = ", samplingStrategy.NMax)
#     println("shu = ", samplingStrategy.shu)
#     println("Current size  = ", samplingStrategy.N)
# end
