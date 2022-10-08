function computeiteration!(nesterov::NesterovConstStep, state::NesterovState, mo::AbstractNLPModel; verbose::Bool = false)

    # ----- Calcul de la vitesse / Momentum
    # - Gradient du point apres momentum (pre-science...)
    NLPModels.grad!(mo, state.x + nesterov.μ_momentum*state.v, state.g)

    # - vecteur vitesse
    state.v[:] = nesterov.μ_momentum*state.v - nesterov.ϵ_rate*state.g
    # - vecteur parametres
    state.x += state.v

    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end


function computeiteration!( nesterov::NesterovLR{f, g}, state::NesterovState, mo::AbstractNLPModel; verbose::Bool = false) where {f, g}
    μ_momentum = f(state.iter, nesterov.a, nesterov.b, nesterov.c)
    ϵ_rate = g(state.iter, nesterov.a, nesterov.b, nesterov.c)

    # ----- Calcul de la vitesse / Momentum
    # - Gradient du point apres momentum (pre-science...)
    grad!(state.x + μ_momentum*state.v,  mo, state.g, sample = sample(state.sampling, isGrad = true))
    updateSampleSize!(state.sampling, state, state.iter)
    # - vecteur vitesse
    state.v[:] = μ_momentum*state.v - ϵ_rate*state.g
    # - vecteur parametres
    state.x += state.v

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end
