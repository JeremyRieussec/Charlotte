function computeiteration!(state::MomentumState, mo::AbstractStochasticModel, momentum::MomentumConstStep)

    state.v = momentum.α*state.v - momentum.ϵ*state.g
    state.x += state.v

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end

function computeiteration(state::MomentumState, mo::AbstractStochasticModel, momentum::MomentumLR{f, g}) where {f, g}

    α = f(state.iter, momentum.a, momentum.b, momentum.c)
    ϵ = g(state.iter, momentum.a, momentum.b, momentum.c)
    state.v[:] = α*state.v - ϵ*state.g
    state.x += v

    grad!(state.x, mo, state.g, sample = sample(state.sampling, isGrad = true))
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end
