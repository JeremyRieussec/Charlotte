struct MuAccumulator <: AbstractAccumulator{Float64}
    vals::Array{Float64, 1}
    function MuAccumulator()
        return new([])
    end
    function MuAccumulator(vals::Array{Float64, 1})
        return new(vals)
    end
end
function accumulate!(state::AbstractState, accumulator::MuAccumulator, mo::AbstractNLPModel)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.vals, copy(state.mu))
    end
end

function Mu()
    return MuAccumulator()
end

function getData(accumulator::MuAccumulator)
    return accumulator.vals
end
