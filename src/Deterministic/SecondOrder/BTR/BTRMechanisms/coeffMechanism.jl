##### With coeffs 

struct BasicTrustRegionWithCoeff{T<:Real} <: AbstractBasicTrustRegion
    eta1::T  # Limite pour refus du pas
    eta2::T # Acceptation du pas
    gamma1::T # contraction rayon MAUVAISE iteration
    gamma2::T # contraction rayon pour BONNE iteration
    gamma3::T # Extension du rayon pour SUPER iteration
end

# constructeur Basic Trust Region
function BTRCoeffs()
    return BasicTrustRegionWithCoeff(0.01, 0.8, 0.5, 0.9, 1.5)
end

@inline function acceptCandidate!(state::BTRState, b::BasicTrustRegionWithCoeff)::Bool
    return state.rho >= b.eta1
end

function updateRadius!(state::BTRState, b::BasicTrustRegionWithCoeff)
    if state.rho >= b.η2
        verbose && println("step accepted, region expanded (VERY good accuracy)")
        state.Delta = min(state.DeltaMax, state.Delta*b.gamma3)
    elseif state.rho >= b.eta1
        verbose && println("step accepted, region reduced (good accuracy)")
        state.Delta *= b.gamma2
    else
        verbose && println("step refused region reduced (BAD accuracy)")
        state.Delta *= b.gamma1
    end
end


##################### Simplified version ###############

mutable struct BasicTrustRegionWithCoeffSimplified{T<:Real} <: AbstractBasicTrustRegion
    eta::T # Acceptation du pas
    gamma1::T # contraction rayon MAUVAISE iteration
    gamma2::T # contraction rayon pour BONNE iteration
end

# constructeur Basic Trust Region
function BTRCoeffSimplified()
    return BasicTrustRegionWithCoeffSimplified(0.1, 0.5, 1.2)
end


@inline function acceptCandidate!(state::BTRState, b::BasicTrustRegionWithCoeffSimplified)::Bool
    return state.rho >= b.eta
end

function updateRadius!(state::BTRState, b::BasicTrustRegionWithCoeffSimplified)
    if state.rho >= b.eta
        verbose && println("step accepted, region reduced")
        state.Delta = min(state.DeltaMax, state.Delta*b.gamma2)
    else
        verbose && println("step refused region reduced")
        state.Delta *= b.gamma1
    end
end


############### println #####################

import Base.println

function println(btr::BasicTrustRegionWithCoeff)
    println("Classic basic trust-region update (Conn - Toint - Gould) :")
    println(" - Limite pour refus du pas, eta1 = $(btr.eta1)")
    println(" - Acceptation du pas, η2 = $(btr.η2)")
    println(" - contraction rayon MAUVAISE iteration, gamma1 = $(btr.gamma1)")
    println(" - contraction rayon pour BONNE iteration, gamma2 = $(btr.gamma2)")
    println(" - Extension du rayon pour SUPER iteration, gamma3 = $(btr.gamma3)")
end

import Base.write

function write(io::IOStream, btr::BasicTrustRegionWithCoeff)
    write(io, "Classic basic trust-region update (Conn - Toint - Gould) :\n")
    write(io, " - Limite pour refus du pas, eta_1 = $(btr.eta1) \n")
    write(io, " - Acceptation du pas, eta_2 = $(btr.η2) \n")
    write(io, " - contraction rayon MAUVAISE iteration, gamma_1 = $(btr.gamma1) \n")
    write(io, " - contraction rayon pour BONNE iteration, gamma_2 = $(btr.gamma2) \n")
    write(io, " - Extension du rayon pour SUPER iteration, gamma_3 = $(btr.gamma3)\n")
end