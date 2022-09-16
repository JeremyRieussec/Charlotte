"""
Accumulator are structures made to accumulate information during an optimisation. Each optimisation algorithm should call an `accumulate!` function at the every iteration of the while loop.
"""
abstract type AbstractAccumulator{T} end
function genName(::Type{AAT}) where {AAT <: AbstractAccumulator}
    AAT.name.name
end
gentype(::Type{AAT}) where {T, AAT <: AbstractAccumulator{T}} = T

function initialize!(state::AbstractState, accumulator::AbstractAccumulator, mo::AbstractNLPModel)

end

include("allaccum/main.jl")

include("Accumulator.jl")

include("saveToLog.jl")