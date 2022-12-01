

struct SamplingSizeAccumulator <: AbstractSingleAccumulator
    sizesFunc::Array{Int, 1}
    sizesGrad::Array{Int, 1}
    sizesHes::Array{Int, 1}
    
    isFunc::Bool
    isGrad::Bool
    isHes::Bool

    atinterval::Int # frequence of storage

    function SamplingSizeAccumulator(; atinterval::Int = 1, 
                                        isFunc::Bool = true,
                                        isGrad::Bool = false,
                                        isHes::Bool = false)
        return new(Int[], Int[], Int[], isFunc, isGrad, isHes, atinterval)
    end
end

function accumulate!(state::AbstractState, sampling::AbstractSampling, accumulator::SamplingSizeAccumulator)
    if state.iter % accumulator.atinterval == 0
        if accumulator.isFunc
            push!(accumulator.sizesFunc, length(sample(sampling, isFunc = true)))
        end
        if accumulator.isGrad
            push!(accumulator.sizesGrad, length(sample(sampling, isGrad = true)))
        end
        if accumulator.isHes
            push!(accumulator.sizesHes, length(sample(sampling, isHes = true)))
        end        
    end
end

function SamplingSize()
    return SamplingSizeAccumulator()
end

function getData(accumulator::SamplingSizeAccumulator)
    return (accumulator.sizesFunc, accumulator.sizesGrad, accumulator.sizesHes)
end

function genName(aa::SamplingSizeAccumulator)
    return :SamplingSize
end
