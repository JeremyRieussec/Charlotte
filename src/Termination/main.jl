

abstract type AbstractSingleTerminationCriterion end

abstract type AbstractTerminationCriteria end


mutable struct TerminationCriteria <: AbstractTerminationCriteria
    stopTests::Array{AbstractSingleTerminationCriterion, 1}
    status::Symbol

    function TerminationCriteria(stopTests::Array{AbstractSingleTerminationCriterion, 1})
        return new(stopTests, :Unkown)
    end
end
@inline function stop(tc::TerminationCriteria, state::AbstractState)
    for test in tc.stopTests
        if stop(test, state)
            tc.status = gensym(test)
            return true
        end
    end

    return false
end


### Fixed Gradient Norm
struct FixedGradientNorm{T} <: AbstractSingleTerminationCriterion
    value::T
    function FixedGradientNorm(value::T = 1e-5) where T
        return new{T}(value)
    end
end

@inline function stop(tc::FixedGradientNorm, state::AbstractState)
    return norm(state.g) <= tc.value
end

gensym(::FixedGradientNorm) = :FixedGradientNorm


### Maximum iteration
struct NMaxStop <: AbstractSingleTerminationCriterion
    value::Int
    function NMaxStop(value::Int = 1000)
        return new(value)
    end
end

@inline function stop(tc::NMaxStop, state::AbstractState)
    return state.iter > tc.value
end

gensym(::NMaxStop) = :NMax


### Maximum time 
struct TMaxStop{T} <: AbstractSingleTerminationCriterion
    value::T # in seconds 

    function TMaxStop(value::T = 180.0) where T
        return new{T}(value)
    end
end

@inline function stop(tc::TMaxStop, state::AbstractState)
    return (state.time - state.time0)/1e9 > tc.value
end

gensym(::TMaxStop) = :TMax


### Definition of global stopiing criteria
stopTests = [NMaxStop(), TMaxStop(), FixedGradientNorm(1e-4)]
global genericterminationcriteria = TerminationCriteria(stopTests)
function changeterminationcriteria(tc::AbstractTerminationCriteria)
    global genericterminationcriteria = tc
end