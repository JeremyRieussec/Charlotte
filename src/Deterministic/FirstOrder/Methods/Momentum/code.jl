
function computeiteration!(momentum::MomentumConstStep, state::MomentumState, mo::AbstractNLPModel; verbose::Bool = false)
    state.v = momentum.alpha*state.v - momentum.epsilon*state.g
    state.x += state.v

    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end

function computeiteration!(momentum::MomentumLR{f, g}, state::MomentumState, mo::AbstractNLPModel; verbose::Bool = false) where {f, g}
    alpha = f(state.iter, momentum.a, momentum.b, momentum.c)
    epsilon = g(state.iter, momentum.a, momentum.b, momentum.c)
    state.v[:] = alpha*state.v - epsilon*state.g
    state.x += v

    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end
