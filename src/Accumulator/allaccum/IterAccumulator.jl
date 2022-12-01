struct IterAccumulator <: AbstractAccumulator{Int}
    iters::Array{Int64, 1}
    function IterAccumulator(;atinterval::Int = 1)
        return new([])
    end
end
function accumulate!(state::AbstractState, accumulator::IterAccumulator, mo::AbstractNLPModel)
    push!(accumulator.iters, copy(state.iter))
end

function Iter()
    return IterAccumulator()
end

function getData(accumulator::IterAccumulator)
    return accumulator.iters
end
