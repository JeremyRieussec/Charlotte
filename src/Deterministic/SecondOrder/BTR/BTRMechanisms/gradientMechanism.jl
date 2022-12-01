#### With gradient

abstract type AbstractBasicTrustRegionWithGradient <: AbstractBasicTrustRegion end

mutable struct BasicTrustRegionCoeffWithGradient{T<:Real} <: AbstractBasicTrustRegionWithGradient
    eta1::T # Acceptation du pas
    eta2::T # Order of comparison with gradient
    gamma::T # expansion of radius
end

function BTRCoeffsGradient()
    return BasicTrustRegionCoeffWithGradient(0.1, 0.001, 2.0)
end

@inline function acceptCandidate!(state::BTRState, b::BasicTrustRegionCoeffWithGradient)::Bool
    return (state.rho >= b.eta1 && norm(state.grad) >= state.eta2*state.Delta)
end

function updateRadius!(state::BTRState, b::BasicTrustRegionCoeffWithGradient)
    if (state.rho >= b.eta1 && norm(state.grad) >= state.eta2*state.Delta)
        verbose && println("step accepted, region reduced")
        state.Delta = min(state.DeltaMax, state.Delta*b.gamma)
    else
        verbose && println("step refused region reduced")
        state.Delta /= b.gamma
    end
end