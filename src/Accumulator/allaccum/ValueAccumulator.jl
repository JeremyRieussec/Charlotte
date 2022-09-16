struct ValueAccumulator{T} <: AbstractAccumulator{T}
    vals::Array{T, 1}
    function ValueAccumulator(T = Float64)
        return new{T}([])
    end
    function ValueAccumulator{T}(vals::Array{T, 1} = T[]) where T
        return new{T}([])
    end
end
function accumulate!(state::AbstractState, accumulator::ValueAccumulator, mo::AbstractNLPModel)
    push!(accumulator.vals, copy(state.fx))
end

function Value()
    return ValueAccumulator()
end

function getData(accumulator::ValueAccumulator)
    return accumulator.vals
end
