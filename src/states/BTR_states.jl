mutable struct BTRState{T, HType} <: AbstractState where {T, HType}
    it::Int64
    x::Vector{T}
    xcand::Vector{T}
    grad::Vector{T}
    H::HType
    step::Vector{T}
    gs::T
    sHs::T
    Delta::T
    rho::T
    fx::T
    fcand::T
    function BTRState(::Type{T} = Float64, ::Type{HType} = Matrix{T}) where {T, HType}
        state = new{T, HType}()
        state.it = 0
        return state
    end
end

function Base.println(io::IO, state::BTRState)
    println(io, "---------------------------------------------------------------------------------------")
    println(io, "iteration $(state.it), x = $(state.x), Delta = $(state.Delta), ||g|| = $(norm(state.grad))")
end