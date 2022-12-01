struct BasicTrustRegion{HAPPROX} end
function BasicTrustRegion()
    return BasicTrustRegion{HessianMatrix}()
end
function (btr::BasicTrustRegion{HAPPROX})(mo::AbstractNLPModel; state::BTRState{T, HType} = BTRState(HAPPROX, mo),
        verbose::Bool = false, nmax::Int64 = 100, tc::AbstractTerminationCriteria = genericterminationcriteria, 
        b::BasicTrustRegionConstant{T} = BTRDefaults(),
        accumulator::AbstractAccumulator = ParamAccumulator()) where {T, HType, HAPPROX}
    x0 = mo.meta.x0
    initializeState!(mo, x0, state, HAPPROX)
    while !stop(tc, state)
        accumulate!(state, accumulator)
        verbose && println(state)
        updateState!(mo, state)
        if acceptCandidate!(state, b)
            state.x = copy(state.xcand)
            state.fx = state.fcand
            state.grad = grad(mo, state.x)
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
    state.fx = obj(mo, x)
    state.grad = grad(mo, x)
    state.Delta = 0.1*norm(state.grad)
    updatehessian!(mo, state, ha)
end


function updateState!(mo::AbstractNLPModel, state::BTRState)
    #state.step = solvequadmodel(mo, state)
    state.step = state.H \ (-0.5*state.grad)
    if norm(state.step) > state.Delta
        state.step = state.Delta * normalize(state.step)
    end
    state.xcand = state.x+state.step
    state.fcand = obj(mo, state.xcand)
    state.gs = dot(state.step, state.grad)
    state.sHs = dot(state.step, state.H*state.step)
    state.rho = (state.fcand-state.fx)/(state.gs + 0.5*state.sHs)
end