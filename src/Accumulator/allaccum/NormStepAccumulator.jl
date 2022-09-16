struct NormStepAccumulator <: AbstractAccumulator{Float64}
    vals::Array{Float64, 1}
    function NormStepAccumulator()
        return new([])
    end
    function NormStepAccumulator(vals::Array{Float64, 1})
        return new(vals)
    end
end
function accumulate!(state::AbstractState, accumulator::NormStepAccumulator, mo::AbstractNLPModel)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.vals, norm(state.step))
    end
end

function NStep()
    return NormStepAccumulator()
end

function NStep(p::NormStepAccumulator)
    return p.vals
end

function getData(accumulator::NormStepAccumulator)
    return accumulator.vals
end
