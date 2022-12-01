##### with step 

struct BasicTrustRegionWithStep{T<:Real} <: AbstractBasicTrustRegion
    eta1::T  # Limite pour refus du pas
    eta2::T # Acceptation du pas
    gamma1::T # contraction rayon MAUVAISE iteration
    gamma2::T # contraction rayon pour BONNE iteration
end

# constructeur Basic Trust Region
function BTRCoeffWithStep()
    return BasicTrustRegionWithStep(0.01, 0.9, 0.5, 0.5)
end

@inline function acceptCandidate!(state::BTRState, b::BasicTrustRegionWithStep)::Bool
    return state.rho >= b.eta1
end

function updateRadius!(state::BTRState, b::BasicTrustRegionWithStep)
    if state.rho >= b.eta2
        stepnorm = norm(state.step)
        state.Delta = min(10e12, max(4*stepnorm, state.Delta))
    elseif state.rho >= b.eta1
        state.Delta *= b.gamma2
    else
        state.Delta *= b.gamma1
    end
end


############### println #####################

import Base.println

function println(btr::BasicTrustRegionWithStep)
    println("Basic trust-region update with step norm :\n")
    println(" - Limite pour refus du pas, eta1 = $(btr.eta1)")
    println(" - Acceptation du pas, eta2 = $(btr.eta2)")
    println(" - contraction rayon MAUVAISE iteration, gamma1 = $(btr.gamma1)")
    println(" - contraction rayon pour BONNE iteration, gamma2 = $(btr.gamma2)")
end

import Base.write

function write(io::IOStream, btr::BasicTrustRegionWithStep)
    write(io, "Basic trust-region update with step norm :\n")
    write(io, " - Limite pour refus du pas, eta_1 = $(btr.eta1) \n")
    write(io, " - Acceptation du pas, eta_2 = $(btr.eta2) \n")
    write(io, " - contraction rayon MAUVAISE iteration, gamma_1 = $(btr.gamma1) \n")
    write(io, " - contraction rayon pour BONNE iteration, gamma_2 = $(btr.gamma2) \n")
end