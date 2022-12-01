abstract type AbstractState end

include("BTR_states.jl")
include("firstOrder_states.jl")

function Base.println(state::AbstractState)
    println()
    println(prod("-" for _ in 1:80))
    #println(round.(state.x, digits = 2))
    println("Iteration " , state.iter)
    println(state.fx)
    println(prod("-" for _ in 1:80))
end
