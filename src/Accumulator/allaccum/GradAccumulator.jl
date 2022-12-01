##################################################################################
#                   Gradient 
##################################################################################

struct GradAccumulator{T} <: AbstractSingleAccumulator
    grads::Array{Array{T, 1}, 1}

    atinterval::Int # frequence of storage

    function GradAccumulator(T = Float64; atinterval::Int = 1)
        return new{T}(Array{T, 1}[], atinterval)
    end
    function GradAccumulator{T}(a::Array{Array{T, 1}}; atinterval::Int = 1) where T
        return new{T}(a, atinterval)
    end
end
function accumulate!(state::AbstractState, accumulator::GradAccumulator)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.grads, copy(state.g))
    end 
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


function genName(aa::GradAccumulator)
    return :Grad
end

##################################################################################
#                   NORM of gradient 
##################################################################################

struct NormGradAccumulator{T} <: AbstractSingleAccumulator
    ng::Array{T, 1}

    atinterval::Int # frequence of storage
    
    function NormGradAccumulator(T = Float64; atinterval::Int = 1)
        return new{T}(T[], atinterval)
    end
    function NormGradAccumulator{T}(a::Array{T, 1}; atinterval::Int = 1) where T
        return new{T}(a, atinterval)
    end
end


function accumulate!(state::AbstractState, accumulator::NormGradAccumulator)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.ng, norm(state.g))
    end
    
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

function genName(aa::NormGradAccumulator)
    return :NormGrad
end