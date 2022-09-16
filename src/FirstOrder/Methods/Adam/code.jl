
function computeiteration!(state::AdamState, mo::AbstractStochasticModel, adam::AdamConstStep)
    # -- first order moment : m
    state.m[:] = adam.β_1*state.m + (1 - adam.β_1)*state.g
    # -- second order moment : v
    state.v[:] = adam.β_2*state.v + (1 - adam.β_2)*(state.g.*state.g)
    # --- corrected m
    m_cor = (1/(1 - adam.β_1^(state.iter)))*state.m
    # ---- corrected v
    v_cor = (1/(1-adam.β_2^(state.iter)))*state.v
    # -- vecteur parametres
    vecteur_temp = (v_cor.^(1/2)).+ adam.ϵ_precision
    state.x -= adam.α*(m_cor./vecteur_temp)

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end


#### A travailler
function computeiteration!(state::AdamState, mo::AbstractStochasticModel, sgd::AdamLR{f}) where f
    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    #state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
    α = f(state.iter, sgd.a, sgd.b, sgd.c)
    state.x -= α*state.g
end
