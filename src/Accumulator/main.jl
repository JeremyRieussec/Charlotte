abstract type AbstractAccumulator end

struct ParamAccumulator{T} <: AbstractAccumulator
    params::Array{Array{T, 1}, 1}
    function ParamAccumulator(::Type{T} = Float64) where T
        return new{T}(Array{Array{T, 1}, 1}())
    end
end

function accumulate!(state::AbstractState, accumulator::ParamAccumulator)
    push!(accumulator.params, state.x)
end