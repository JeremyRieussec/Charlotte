function computeiteration!(state::AGState, mo::AbstractStochasticModel, ag::AG{T}) where T

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))

    al = ag.alpha(state.iter, ag.L)
    be = ag.beta(state.iter, ag.L)
    ga = ag.gamma(state.iter, ag.L)
    state.x_md[:] = (1-al)*state.x_ag + al*state.x
    state.x[:] -= ga*state.g
    state.x_ag[:] = state.x_md - be*state.g
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end
