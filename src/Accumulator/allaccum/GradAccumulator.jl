struct GradAccumulator{T} <: AbstractAccumulator{Array{T, 1}}
    grads::Array{Array{T, 1}, 1}
    function GradAccumulator(T = Float64)
        return new{T}(Array{T, 1}[])
    end
    function GradAccumulator{T}(a::Array{Array{T, 1}}) where T
        return new{T}(a)
    end
end
function accumulate!(state::AbstractState, accumulator::GradAccumulator, mo::AbstractNLPModel)
    push!(accumulator.grads, copy(state.g))
end

function Grad(T = Float64)
    return GradAccumulator(T)
end
function Grad(g::GradAccumulator)
    return g.grads
end

function getData(accumulator::GradAccumulator)
    return Grad(accumulator)
end


struct NormGradAccumulator{T} <: AbstractAccumulator{T}
    ng::Array{T, 1}
    function NormGradAccumulator(T = Float64)
        return new{T}(T[])
    end
    function NormGradAccumulator{T}(a::Array{T, 1}) where T
        return new{T}(a)
    end
end
function accumulate!(state::AbstractState, accumulator::NormGradAccumulator, mo::AbstractNLPModel)
    push!(accumulator.ng, norm(state.g))
end

function NGrad(T = Float64)
    return NormGradAccumulator(T)
end
function NGrad(g::NormGradAccumulator)
    return g.ng
end

function getData(accumulator::NormGradAccumulator)
    return NGrad(accumulator)
end

