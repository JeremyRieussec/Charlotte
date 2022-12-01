struct BasicTrustRegion{HAPPROX} end

function (btr::BasicTrustRegion{HAPPROX})(mo::AbstractNLPModel;
                                                state::BTRState{T, HType} = BTRState(HAPPROX, mo),
                                                tc::AbstractTerminationCriteria = genericterminationcriteria, 
                                                solveQP::AbstractQuadSolve = TCG!,
                                                b::AbstractBasicTrustRegion = BTRCoeffs(),
                                                accumulator::AbstractAccumulator = Accumulator(), 
                                                verbose::Bool = false) where {T, HType, HAPPROX}

    # starting point
    x0 = mo.meta.x0

    initializeState!(mo, x0, state, HAPPROX)

    while !stop(tc, state)
        accumulate!(state, accumulator)
        verbose && println(state)
        updateState!(mo, state, solveQP)
        if acceptCandidate!(state, b)
            state.x = copy(state.xcand)
            state.fx = state.fcand
            state.grad = ENLModels.grad(mo, state.x)
            updatehessian!(mo, state, HAPPROX)
        end
        updateRadius!(state, b)
        state.it += 1
        if state.it > nmax
            verbose && @warn "iteration max reached"
            break
        end
    end
    return state, accumulator
end

function BTRState(ha::HessianApproximation, mo::AbstractNLPModel)
    T = eltype(mo.meta.x0)
    HType = gethesstype(ha, T)
    state = BTRState(T, HType)
    return state
end

function initializeState!(mo::AbstractNLPModel, x::Vector, state::BTRState, ha::AP) where {AP <: HessianApproximation}
    state.x = x
    state.fx = ENLPModels.obj(mo, x)
    state.grad = ENLPModels.grad(mo, x)
    state.Delta = 0.1*norm(state.grad)
    updatehessian!(mo, state, ha)
end


function updateState!(mo::AbstractNLPModel, state::BTRState, solveQuadModel!::AbstractQuadSolve)

    # step to get to minimizer of the quadartic model
    state.step = solveQuadModel!(state)

    # candidate vector
    state.xcand = state.x+state.step
    # function value at candidate
    state.fcand = ENLModels.obj(mo, state.xcand)
    # first order decrease of the model with step -> dotProduct(gradient, step)
    state.gs = dot(state.step, state.grad)
    # second order decrease of the model with step -> step^T.H.step
    state.sHs = dot(state.step, state.H*state.step)

    # decrease accuracy 
    state.rho = (state.fcand-state.fx)/(state.gs + 0.5*state.sHs)
end

