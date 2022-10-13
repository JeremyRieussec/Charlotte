
function computeiteration!(sgd::SGDConstStep, state::SGDState, sampling::AbstractSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false)
    state.x -= sgd.alpha*state.g

    ENLPModels.grad!(mo, state.x, state.g, sample = sample(sampling, isGrad = true))
    state.fx = ENLPModels.obj(mo, state.x, sample = sample(sampling, isFunc = true))
end



function computeiteration!(sgd::SGDLR{f}, state::SGDState, sampling::AbstractSampling, mo::AbstractStochasticNLPModels; verbose::Bool = false) where f
    verbose && println("computing iteration of $(SGDLR{f}) method")
    alpha = f(state.iter, sgd.a, sgd.b, sgd.c)
    state.x -= alpha*state.g

    ENLPModels.grad!(mo, state.x, state.g, sample = sample(sampling, isGrad = true))
    state.fx = ENLPModels.obj(mo, state.x, sample = sample(sampling, isFunc = true))
end
