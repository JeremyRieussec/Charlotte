mutable struct SAGState{T, SAM <: AbstractSampling, BANK} <: AbstractState{T}
    iter::Int
    fx::T
    x::Vector # vecteur de paramaetres
    g::Vector
    g_accumulate::Vector

    n::Int
    grads::BANK
    sampling::SAM
    time0::Float64
    time::Float64
    function SAGState(x0::Vector{T}, s::Choose1 = Choose1(),
            grads::BANK = Dict{Int,Array{T, 1}}()) where {T, BANK}
        iter = 0
        fx = Inf
        x = copy(x0)
        g = zeros(T, length(x0))
        g_accumulate = zeros(T, length(x0))
        n = 0
        return new{T, Choose1, BANK}(iter, fx, x, g, g_accumulate, n, grads, s, 0.0, 0.0)
    end
end

struct SAG{T} <: AbstractSGD
    alpha::T
    function SAG(alpha::T) where {T, RNG}
        return new{T}(alpha)
    end
end
