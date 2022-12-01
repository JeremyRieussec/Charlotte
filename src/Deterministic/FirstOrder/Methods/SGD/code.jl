
function computeiteration!(sgd::SGDConstStep, state::SGDState, mo::AbstractNLPModel; verbose::Bool = false)
    state.x -= sgd.alpha*state.g

    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end



function computeiteration!(sgd::SGDLR{f}, state::SGDState, mo::AbstractNLPModel; verbose::Bool = false) where f
    verbose && println("computing iteration of $(SGDLR{f}) method")
    alpha = f(state.iter, sgd.a, sgd.b, sgd.c)
    state.x -= alpha*state.g

    NLPModels.grad!(state.x, mo, state.g)
    state.fx = NLPModels.obj(state.x, mo)
end
