abstract type AbstractBTRState{S} <: AbstractState{S} end

mutable struct BTRState{S, T <: AbstractMatrix{S}, SAM <: AbstractSampling} <:  AbstractState{S}
    iter::Int64 # numero iteration
    x::Vector{S} # vecteur parametres
    xcand::Vector{S} # x Candidate
    g::Vector{S} # Gradient
    H::T # Hesienne
    step::Vector{S} # pas pour mise a jour dans TR
    Δ::S # Rayon region de confiance
    ρ::S # facteur precision modele
    fx::S # f(x)
    mu::S # function decrease
    fcand::S
    iterCG::Int64

    sHs::S
    sHs_centered::S

    sampling::SAM

    accept::Bool

    time0::Float64
    time::Float64

    function BTRState{S}(H::T, sam::SAM = NoSampling()) where {S, T <: AbstractMatrix{S}, SAM <: AbstractSampling}
        state = new{S, T, SAM}()
        state.H = H
        state.iter = 0
        state.iterCG = 0
        state.sampling = sam
        state.accept = false
        return state
    end
end