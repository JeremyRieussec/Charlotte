struct SamplingSizeAccumulator <: AbstractAccumulator{Tuple{Int,Int,Int}}
    sizes::Array{Tuple{Int64,Int64,Int64}, 1}
    function SamplingSizeAccumulator(v::Array{Tuple{Int64,Int64,Int64}} = Tuple{Int64,Int64,Int64}[])
        return new(v)
    end
end
function accumulate!(state::AbstractState, accumulator::SamplingSizeAccumulator, mo::AbstractNLPModel)
    N1 = length(sample(state.sampling, isFunc = true))
    N2 = length(sample(state.sampling, isGrad = true))
    N3 = length(sample(state.sampling, isHes = true))
    push!(accumulator.sizes, (N1, N2, N3))
end

function SamplingSize()
    return SamplingSizeAccumulator()
end

function getData(accumulator::SamplingSizeAccumulator)
    return accumulator.sizes
end
