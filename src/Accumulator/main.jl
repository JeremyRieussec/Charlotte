abstract type AbstractAccumulator end
abstract type AbstractSingleAccumulator end

include("allaccum/ParamsAccumulator.jl")
include("allaccum/DistTo.jl")
include("allaccum/GradAccumulator.jl")
include("allaccum/Times.jl")
include("allaccum/NormStepAccumulator.jl")
include("allaccum/ValueAccumulator.jl")

function genName(aa::AbstractSingleAccumulator)
    return Symbol(typeof(aa))
end

mutable struct Accumulator <: AbstractAccumulator
    accs::Array{AbstractSingleAccumulator, 1}
    
    function Accumulator(ac::AbstractSingleAccumulator...)
        return new(AbstractSingleAccumulator[ac...])
    end
    function Accumulator()
        return new(AbstractSingleAccumulator[Value(), ParamAccumulator()])
    end
    function Accumulator(accs::Array{AbstractSingleAccumulator, 1})
        return new(accs)
    end
end

# Prise en compte de l'iteration 0
function accumulate!(state::AbstractState, accumulator::Accumulator)
    for i in 1:length(accumulator.accs)
        accumulate!(state, accumulator.accs[i])
    end
end

"""
`getData` return a NamedTuple with accumulators default names as names and accumulated values as values.
"""
function getData(accumulator::Accumulator)
    return (; zip([genName.(accumulator.accs)...], [getData.(accumulator.accs)...])...)
end

include("graphAcc.jl")