mutable struct Accumulator
    accs::Array{AbstractAccumulator, 1}
    atinterval::Int
    status::Status
    function Accumulator(ac::AbstractAccumulator...; atinterval::Int = 1)
        return new(AbstractAccumulator[ac...], atinterval, Unknown())
    end
    function Accumulator(;atinterval::Int = 1, status::Status =  Unknown())
        return new(AbstractAccumulator[], atinterval, status)
    end
    function Accumulator(accs::Array{AbstractAccumulator, 1}, atinterval::Int, status::Status)
        return new(accs, atinterval, status)
    end
end

# Prise en compte de l'iteration 0
function accumulate!(state::AbstractState, accumulator::Accumulator, mo::AbstractNLPModel)
    #=if (state.iter == 0)
        for i in 1:length(accumulator.accs)
            if (typeof(accumulator.accs[i]) <: Union{Times, NormGradAccumulator, ValueAccumulator, IterAccumulator,  ParamAccumulator, SamplingSizeAccumulator, DeltaAccumulator, DistTo})
                accumulate!(state, accumulator.accs[i], mo)
            end
        end
    else # state.iter > 0
        if (state.iter % accumulator.atinterval) == 0
            for i in 1:length(accumulator.accs)
                accumulate!(state, accumulator.accs[i], mo)
            end
        end
    end=#
    if (state.iter % accumulator.atinterval) == 0
        for i in 1:length(accumulator.accs)
            accumulate!(state, accumulator.accs[i], mo)
        end
    end
end

function initialize!(state::AbstractState, accumulator::Accumulator, mo::AbstractNLPModel)
    initialize!([state], accumulator.accs, [mo])
end
"""
`getData` return a NamedTuple with accumulators default names as names and accumulated values as values.
"""
function getData(accumulator::Accumulator)
    return (; zip([:atinterval, :status, genName.(accumulator.accs)...], [accumulator.atinterval, accumulator.status, getData.(accumulator.accs)...])...)
end
