using NLPModels
using LinearAlgebra
const NLPM = NLPModels
struct TMPModel{T} <: AbstractNLPModel{T, Vector{T}}
    A::Matrix{T}
    b::Vector{T}
    c::T
    meta::NLPModelMeta{T, Vector{T}}
    counters::Counters
    function TMPModel(n::Int, ::Type{T} = Float64) where T
        A = rand(T, n, n)
        A += A'
        for i in 1:n
            A[i, i] += n
        end
        b = rand(T, n)
        c = zero(T)
        meta = NLPModelMeta{T, Vector{T}}(n)
        counters = Counters()
        return new{T}(A, b, c, meta, counters)
    end
end
function NLPM.obj(mo::TMPModel{T}, x::Vector{T}) where T
    return dot(x, mo.A*x) + dot(x, mo.b) + mo.c
end
function NLPM.grad(mo::TMPModel{T}, x::Vector{T}) where T
    return 2*mo.A*x + mo.b
end
function NLPM.hess(mo::TMPModel{T}, x::Vector{T}) where T
    return 2*mo.A
end
function NLPM.prod(mo::TMPModel{T}, x::Vector{T}, v::Vector{T}) where T
    return 2*mo.A*v
end