abstract type AbstractTerminationCriteria end

struct FixedGradientNorm{T} <: AbstractTerminationCriteria
    value::T
    function FixedGradientNorm(value::T = 1e-5) where T
        return new{T}(value)
    end
end
@inline function stop(tc::FixedGradientNorm, state::AbstractState)
    return norm(state.grad) <= tc.value
end

global genericterminationcriteria = FixedGradientNorm(1e-4)
function changeterminationcriteria(tc::AbstractTerminationCriteria)
    global genericterminationcriteria = tc
end