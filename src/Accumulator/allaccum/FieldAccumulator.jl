struct FieldAccumulator{s, T} <: AbstractAccumulator{T}
    vals::Array{T, 1}
    function FieldAccumulator(s::Symbol, TYPE = Any)
        return new{s, TYPE}(TYPE[])
    end
    function FieldAccumulator{T}(s::Symbol) where T
        return new{s, T}(T[])
    end
    function FieldAccumulator{s, T}(v::Array{T, 1}) where {s, T}
        return new{s, T}(v)
    end
end
function genName(f::FieldAccumulator{s, T}) where {s, T}
    name = Symbol("Field_$s")
end
    
function accumulate!(state::AbstractState, accumulator::FieldAccumulator{s, T}, mo::AbstractNLPModel) where {s, T}
    push!(accumulator.vals, copy(getfield(state, s)))
end

function Field(s::Symbol, t::DataType = Any)
    return FieldAccumulator(s, t)
end

function getData(accumulator::FieldAccumulator)
    return accumulator.vals
end