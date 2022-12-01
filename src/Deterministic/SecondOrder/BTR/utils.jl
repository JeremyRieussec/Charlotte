struct BasicTrustRegionConstant{T<:Real}
    eta1::T
    eta2::T
    gamma1::T
    gamma2::T
end

function BTRDefaults()::BasicTrustRegionConstant
    return BasicTrustRegionConstant(0.01, 0.9, 0.5, 0.5)
end

@inline function acceptCandidate!(state::BTRState, b::BasicTrustRegionConstant)::Bool
    return state.rho >= b.eta1
end

function updateRadius!(state::BTRState, b::BasicTrustRegionConstant)
    if state.rho >= b.eta2
        stepnorm = norm(state.step)
        state.Delta = min(10e12, max(4*stepnorm, state.Delta))
    elseif state.rho >= b.eta1
        state.Delta *= b.gamma2
    else
        state.Delta *= b.gamma1
    end
end