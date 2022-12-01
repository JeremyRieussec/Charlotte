struct DeltaAccumulator <: AbstractAccumulator{Float64}
    deltas::Array{Float64, 1}
    function DeltaAccumulator()
        return new(Float64[])
    end
    function DeltaAccumulator(a::Array{Float64, 1})
        return new(a)
    end
end
function accumulate!(state::AbstractState, accumulator::DeltaAccumulator, mo::AbstractNLPModel)
    push!(accumulator.deltas, copy(state.Δ))
end

function Delta()
    return DeltaAccumulator()
end

function getData(accumulator::DeltaAccumulator)
    return accumulator.deltas
end
