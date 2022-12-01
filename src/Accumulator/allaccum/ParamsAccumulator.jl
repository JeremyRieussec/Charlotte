##################################################################################
#                   Vector of parameters 
##################################################################################


struct ParamAccumulator{T} <: AbstractSingleAccumulator
    params::Array{Array{T, 1}, 1}

    atinterval::Int # frequence of storage

    function ParamAccumulator(::Type{T} = Float64; atinterval::Int = 1) where T
        return new{T}(Array{Array{T, 1}, 1}(), atinterval)
    end
end

function accumulate!(state::AbstractState, accumulator::ParamAccumulator)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.params, state.x)
    end 
end

function Param(p::ParamAccumulator)
    return p.params
end

function getData(accumulator::ParamAccumulator)
    return accumulator.params
end

function genName(aa::ParamAccumulator)
    return :Param
end


# struct ParamAccumulator{T} <: AbstractAccumulator{Array{T, 1}}
#     params::Array{Array{T, 1}, 1}
#     function ParamAccumulator(T = Float64)
#         return new{T}(Array{T, 1}[])
#     end
#     function ParamAccumulator{T}(params::Array{Array{T, 1}, 1}) where T
#         return new{T}(params)
#     end
# end
# function accumulate!(state::AbstractState, accumulator::ParamAccumulator, mo::AbstractNLPModel)
#     push!(accumulator.params, copy(state.x))
# end

# function Param(T = Float64)
#     return ParamAccumulator(T)
# end

# function Param(p::ParamAccumulator)
#     return p.params
# end

# function getData(accumulator::ParamAccumulator)
#     return accumulator.params
# end