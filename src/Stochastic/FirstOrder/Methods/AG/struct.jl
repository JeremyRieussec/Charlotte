
mutable struct AGState{T, SAM <: AbstractSampling} <: AbstractState{T}
    iter::Int
    fx::T
    x::Vector # vecteur de paramaetres
    x_ag::Vector # point
    x_md::Vector # point intermediaire
    g::Vector{T}
    sampling::SAM
    time0::Float64
    time::Float64
    function AGState(x0::Vector{T}, s::SAM) where {T, SAM <: AbstractSampling}
        return new{T, SAM}(0, Inf, copy(x0), copy(x0), copy(x0), Array{T, 1}(undef, length(x0)), s, 0.0, 0.0)
    end
end

struct AG{T} <: AbstractSGD
    L::T
    alpha::Function
    beta::Function
    gamma::Function
    function AG(L::T, alpha::Function, beta::Function, gamma::Function) where {T}
        return new{T}(L, alpha, beta, gamma)
    end
end


alpha = (k::Int, L) -> 2/(k + 1)
beta = (k::Int, L) -> 1/(2*L)
gamma = (k::Int, L) -> k/(4*L)

AGAggressive(L) = AG(L, alpha, beta, gamma)
