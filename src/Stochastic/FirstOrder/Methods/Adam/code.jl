function computeiteration!(adam::AdamConstStep, state::AdamState, mo::AbstractNLPModel; verbose::Bool = false)
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
    state.x -= adam.alpha*(m_cor./vecteur_temp)

    NLPModels.grad!(mo, state.x, state.g)
    state.fx = NLPModels.obj(mo, state.x)
end


#### A travailler
function computeiteration!(sgd::AdamLR{f}, state::AdamState, mo::AbstractNLPModel; verbose::Bool = false) where f
    grad!( mo, state.x,state.g)
    state.fx =  NLPModels.obj(mo, state.x)
    alpha = f(state.iter, sgd.a, sgd.b, sgd.c)
    state.x -= alpha*state.g
end
