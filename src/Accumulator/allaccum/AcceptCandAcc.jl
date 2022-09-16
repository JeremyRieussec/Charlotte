struct IsAcceptedAccumulator <: AbstractAccumulator{Bool}
    acc::Array{Bool, 1}
    function IsAcceptedAccumulator(acc::Array{Bool, 1} = Bool[])
        return new(acc)
    end
end
function accumulate!(state::AbstractState, accumulator::IsAcceptedAccumulator, mo::AbstractNLPModel)
    push!(accumulator.acc, state.accept)
end


function getData(accumulator::IsAcceptedAccumulator)
    return accumulator.acc
end
