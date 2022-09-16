
function computeiteration!(sgd::SGDConstStep, state::SGDState, mo::AbstractNLPModel; verbose::Bool = false)
    verbose && println("computing iteration of $SGDConstStep method")
    state.x -= sgd.alpha*state.g

    grad!(mo, state.x, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = obj(mo, state.x, sample = sample(state.sampling, isFunc = true))
end



function computeiteration!(sgd::SGDLR{f}, state::SGDState, mo::AbstractNLPModel; verbose::Bool = false) where f
    verbose && println("computing iteration of $(SGDLR{f}) method")
    alpha = f(state.iter, sgd.a, sgd.b, sgd.c)
    state.x -= alpha*state.g

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = obj(state.x, mo, sample = sample(state.sampling, isFunc = true))
end
