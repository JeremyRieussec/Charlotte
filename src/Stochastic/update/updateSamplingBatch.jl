# function updateSampleSize!(sampling::BatchSampling{SHU}, state::AbstractState, iter::Int; verbose::Bool = false) where SHU
#     if sampling.start + sampling.N > sampling.NMax
#         N1 = sampling.NMax - sampling.start
#         N2 = sampling.N - N1
#         sampling.start = N2
#     else
#         sampling.start += sampling.N
#     end
# end

# function initializeSampling!(sampling::BatchSampling{SHU}, mo::AbstractNLPModel; verbose::Bool = false) where SHU
#     # sampling.NMax = Nobs(mo)
#     sampling.shu = SHU(1:sampling.NMax)
#     sampling.start = 1
# end
