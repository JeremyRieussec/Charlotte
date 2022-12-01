function (sgd::AbstractSGD)(mo::AbstractStochasticNLPModels, sampling::AbstractSampling,  state::AbstractState = genstate(sgd, mo); 
                tc::AbstractTerminationCriteria = genericterminationcriteria,
                verbose::Bool = true,
                accumulator::AbstractAccumulator = Accumulator())

    println("Algorithm of type : $(typeof(sgd)) with sampling")
    state.time0 = time_ns()

    initializeSampling!(sampling, mo, verbose = verbose)
    initialize!(sgd, state, mo)

    # accumulate
    state.time = time_ns()
    for singleacc in accumulator.accs
        if typeof(singleacc) <: SamplingSizeAccumulator
            accumulate!(state, sampling, singleacc)
        else
            accumulate!(state, singleacc)
        end
    end
    
    while !stop(tc, state)

        verbose && println(state)

        state.iter += 1

        updateSampleSize!(sampling, state, verbose = verbose)
        computeiteration!(sgd, state, sampling, mo, verbose = verbose)

        # accumulate
        state.time = time_ns()
        for singleacc in accumulator.accs
            if typeof(singleacc) <: SamplingSizeAccumulator
                accumulate!(state, sampling, singleacc)
            else
                accumulate!(state, singleacc)
            end
        end
    end

    println(" --- STOP after $(state.iter) iterations ---")
    println(" stop status: ", genericterminationcriteria.status)
    println(" fx = ", state.fx)
    println(" norm grad = " , norm(state.g))

    return state, accumulator
end


function initialize!(sgd::AbstractSGD, state::AbstractState, sampling::AbstractSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    verbose && println("initialize, generic sgd method with sampling")
    ENLPModels.grad!(mo, state.x, state.g; sample = sample(sampling, isGrad=true))
    state.fx = ENLPModels.obj(mo, state.x; sample = sample(sampling, isFunc=true))
end

function computeiteration!(sgd::AbstractSGD, state::AbstractState, sampling::AbstractSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    println("computing iteration, generic sgd method with sampling")
    ENLPModels.grad!(mo, state.x, state.g; sample = sample(sampling, isGrad=true))
    state.fx = ENLPModels.obj(mo, state.x; sample = sample(sampling, isFunc=true))
    state.x[:] -= 0.001*state.g
end
