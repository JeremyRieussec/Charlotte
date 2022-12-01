struct Values{T} <: AbstractAccumulator{T}
    vals::Array{Array{T, 1}, 1}
    function Values(TYPE::DataType = Float64)
        return new{TYPE}(Array{TYPE, 1}[])
    end
    function Values{T}(vals::Array{Array{T, 1}, 1}) where T
        return new{T}(vals)
    end
end
    
function accumulate!(state::AbstractState, accumulator::Values, mo::AbstractNLPModel)
    push!(accumulator.vals, copy(mo.sampling.valueprev))
end

function getData(accumulator::Values)
    return accumulator.vals
end
