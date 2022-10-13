
function initializeSampling!(sampling::AbstractDynamicSampling, mo::AbstractNLPModel; verbose::Bool = false)
    sampling.shu = Array{Int, 1}(undef, sampling.N)
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

# Independent Random Numbers
function initializeSampling!(sampling::DynamicSampling{I,T}, mo::AbstractNLPModel;
                                    verbose::Bool = false) where {I <: IndRN, T}

    verbose && println("initializeSampling Dynamic! Ind RN")
    sampling.shu = Array{Int, 1}(undef, sampling.N)
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]
end

function initializeSampling!(sampling::DynamicSampling{I,T}, mo::AbstractNLPModel;
                                verbose::Bool = false) where {I <: IndComRN, T}

    verbose && println("initializeSampling Dynamic! Ind / Com RN")
    sampling.shu = Array{Int, 1}(undef, sampling.N)
    sampling.shu = collect(1:sampling.N)
end

function initializeSampling!(sampling::DynamicSampling{I,T}, mo::AbstractNLPModel;
                                        verbose::Bool = false) where {I <: CommonRN, T}

    verbose && println("initializeSampling Dynamic! Common RN")
    sampling.shu = 1:sampling.N
end


## #################################  Update  ####################################3


######################### Independent Variables #############################
function updateSampleSize!(sampling::DynamicSampling{I,T}, state::AbstractBTRState, iter::Int;
                                verbose::Bool = false) where {I <: IndRN, T}

    # independent variables
    verbose && println("--- updateSampleSize! --- Indpendent Variables")
    verbose && println("Current sample size = ", sampling.N)

    newcurrent = potentialSampleSize(sampling, state, sampling.varStrategy.smoothing, verbose = verbose)

    sampling.N = newcurrent
    sampling.shu = randperm(sampling.NMax)[1:sampling.N]

    verbose && println("New sample size = ", sampling.N)

end

######################### Independent / Common Variables #############################
function updateSampleSize!(sampling::DynamicSampling{I,T}, state::AbstractBTRState, iter::Int;
                                verbose::Bool = false) where {I <: IndComRN, T}

    verbose && println(" --- updateSampleSize! --- Ind / Common Variables")
    verbose && println("Current sample size = ", sampling.N)

    newcurrent = potentialSampleSize(sampling, state, sampling.varStrategy.smoothing, verbose = verbose)

    if (sampling.N < newcurrent)
        # sample size increases
        diffSize = newcurrent - sampling.N
        verbose && println("- Increase !! with ", diffSize)
        diffSet = setdiff(1:sampling.NMax, sampling.shu)
        addSet = shuffle(diffSet)[1:diffSize]
        sampling.shu = union(sampling.shu, addSet)
    elseif (sampling.N > newcurrent)
        # sample size decreases
        verbose && println("- Decrease !! with ", sampling.N - newcurrent)
        sampling.shu = shuffle(sampling.shu)[1:newcurrent]
    end

    sampling.N = newcurrent

    verbose && println("New sample size = ", sampling.N)
end


######################### Common Variables #############################
function updateSampleSize!(sampling::DynamicSampling{I,T}, state::AbstractBTRState, iter::Int;
                                verbose::Bool = false) where {I <: CommonRN, T}

    # independent variables
    verbose && println("--- updateSampleSize! --- Common Variables")
    verbose && println("Current sample size = ", sampling.N)

    newcurrent = potentialSampleSize(sampling, state, sampling.varStrategy.smoothing, verbose = verbose)

    sampling.N = newcurrent
    sampling.shu = 1:sampling.N

    verbose && println("New sample size = ", sampling.N)

end


