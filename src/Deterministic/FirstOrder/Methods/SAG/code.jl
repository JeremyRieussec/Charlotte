function computeiteration!(state::SAGState{T, S, Dict{Int,Array{T, 1}}}, mo::AbstractStochasticModel, sgd::SAG) where {T,S}
    index = state.sampling.k
    if index in keys(state.grads)
        state.g_accumulate[:] -= state.grads[index]
        newGrad = zeros(T, length(state.x))
        grad!(state.x, mo, newGrad, sample = sample(state.sampling; isGrad = true))
        state.grads[index][:] = newGrad
    else
        push!(state.grads, index => zeros(T, length(state.x)))
        newGrad = zeros(length(state.x))
        grad!(state.x, mo, newGrad, sample = sample(state.sampling; isGrad = true))
        state.grads[index][:] = newGrad
        state.n += 1
    end
    state.g_accumulate[:] += state.grads[index]
    state.g = state.g_accumulate[:]/state.n
    state.x[:] -= sgd.alpha * state.g
    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end



function computeiteration!(state::SAGState{T, S, Tuple{BitArray{1},Array{T,2}}},
        mo::AbstractStochasticModel, sgd::SAG) where {T, S}

    index = state.sampling.k
    keys = state.grads[1]
    vals = state.grads[2]
    if keys[index]
        viewvals = @view vals[:, index]
        state.g_accumulate[:] -= viewvals
        newGrad = zeros(T, length(state.x))
        grad!(state.x, mo, newGrad, sample = sample(state.sampling; isGrad = true))
        vals[:, index] = newGrad
    else
        keys[index] = 1
        grad!(state.x, mo, newGrad, sample = sample(state.sampling; isGrad = true))
        vals[:, index] = newGrad
        state.n += 1
    end
    state.g_accumulate[:] += state.grads[index]
    state.g = state.g_accumulate[:]/state.n
    state.x[:] -= sgd.alpha * state.g

    state.fx = F(state.x, mo, sample = sample(state.sampling, isFunc = true))
end
