function (sgd::AbstractSGD)(mo::AbstractNLPModel, state::AbstractState = genstate(sgd, mo); verbose::Bool = true,
        accumulator::Accumulator = Accumulator(), sp::StopParam = StopParam())

    println("Algorithm of type : $(typeof(sgd))")
    state.time0 = time_ns()
    initializeSampling!(state.sampling, mo, verbose = verbose)
    initialize!(sgd, state, mo)

    status = Unknown()

    # accumulate
    state.time = time_ns()
    accumulate!(state, accumulator, mo)
    while true
        isOptimal(state, sp) && (status = Optimal(); break)
        asDiverged(state, sp) && (status = Diverged(); break)
        nmaxReached(state, sp) && (status = NMaxReached(); break)
        tmaxReached(state, sp) && (status = TimeMaxReached(); break)
        verbose && println(state)

        state.iter += 1

        updateSampleSize!(state.sampling, state, verbose = verbose)
        computeiteration!(sgd, state, mo, verbose = verbose)

        # accumulate
        state.time = time_ns()
        accumulate!(state, accumulator, mo)
    end
    accumulator.status = status
    return state, accumulator
end


function initialize!(sgd::AbstractSGD, state::AbstractState, mo::AbstractNLPModel; verbose::Bool = false)
    verbose && println("initialize, generic sgd methode")
    grad!(mo, state.x, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = obj(mo, state.x, sample = sample(state.sampling, isFunc = true))
end

function computeiteration!(sgd::AbstractSGD, state::AbstractState, mo::AbstractNLPModel; verbose::Bool = false)
    verbose && println("computing iteration, generic sgd methode")
    grad!(mo, state.x, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = obj(mo, state.x, sample = sample(state.sampling, isFunc = true))
    state.x[:] -= 0.001*state.g
end
