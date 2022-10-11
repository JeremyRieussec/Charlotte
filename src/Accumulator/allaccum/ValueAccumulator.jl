##################################################################################
#                       Function value accumulation
##################################################################################

struct ObjectiveAccumulator{T} <: AbstractSingleAccumulator
    vals::Array{T, 1}

    atinterval::Int # frequence of storage

    function ObjectiveAccumulator(; atinterval::Int = 1)
        return new{Float64}(Float64[], atinterval)
    end

    function ObjectiveAccumulator{T}(vals::Array{T, 1} = T[]; atinterval::Int = 1) where T
        return new{T}(vals, atinterval)
    end
end


function accumulate!(state::AbstractState, accumulator::ObjectiveAccumulator)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.vals, copy(state.fx))
    end
end

function Value()
    return ObjectiveAccumulator()
end

function getData(accumulator::ObjectiveAccumulator)
    return accumulator.vals
end

function genName(aa::ObjectiveAccumulator)
    return :Objective
end
