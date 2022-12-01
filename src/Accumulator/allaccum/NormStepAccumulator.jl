##################################################################################
#                   Norm of steps 
##################################################################################

struct NormStepAccumulator{T} <: AbstractSingleAccumulator
    vals::Array{T, 1}

    atinterval::Int # frequence of storage

    function NormStepAccumulator(; atinterval::Int = 1)
        return new{Float64}([])
    end
    function NormStepAccumulator(vals::Array{T, 1}; atinterval::Int = 1) where T
        return new{T}(vals)
    end
end

function accumulate!(state::AbstractState, accumulator::NormStepAccumulator)
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

function genName(aa::NormStepAccumulator)
    return :NormStep
end
