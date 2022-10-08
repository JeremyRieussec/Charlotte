function (sgd::AbstractSGD)(mo::AbstractNLPModel, state::AbstractState = genstate(sgd, mo); 
                verbose::Bool = true,
                accumulator::AbstractAccumulator = ParamAccumulator())

    println("Algorithm of type : $(typeof(sgd))")
    state.time0 = time_ns()
    initialize!(sgd, state, mo)

    # accumulate
    state.time = time_ns()
    accumulate!(state, accumulator)

    while !stop(genericterminationcriteria, state)

        verbose && println(state)

        state.iter += 1

        computeiteration!(sgd, state, mo, verbose = verbose)

        # accumulate
        state.time = time_ns()
        accumulate!(state, accumulator)
    end

    println(" --- STOP after $(state.iter) iterations ---")
    println(" stop status: ", genericterminationcriteria.status)
    println(" fx = ", state.fx)
    println(" norm grad = " , norm(state.g))

    return state, accumulator
end


function initialize!(sgd::AbstractSGD, state::AbstractState, mo::AbstractNLPModel; verbose::Bool = false)
    verbose && println("initialize, generic sgd method")
    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end

function computeiteration!(sgd::AbstractSGD, state::AbstractState, mo::AbstractNLPModel; verbose::Bool = false)
    println("computing iteration, generic sgd methode")
    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
    state.x[:] -= 0.001*state.g
end
