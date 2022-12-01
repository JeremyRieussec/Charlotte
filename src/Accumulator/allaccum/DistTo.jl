##################################################################################
#                   Distance to solution 
##################################################################################

struct DistTo{T} <: AbstractSingleAccumulator
    d::Array{T, 1}
    xstar::Array{T, 1}

    atinterval::Int # frequence of storage

    function DistTo(xstar::Array{T, 1}; atinterval::Int = 1) where T
        return new{T}(T[], xstar, atinterval)
    end
    function DistTo(d::Array{T, 1}, xstar::Array{T, 1}; atinterval::Int = 1) where T
        return new{T}(d, xstar, atinterval)
    end
end

function accumulate!(state::AbstractState, accumulator::DistTo)
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.d, norm(state.x - accumulator.xstar))
    end 
end


function DistTo(p::DistTo)
    return p.d
end

function getData(accumulator::DistTo)
    return accumulator.d
end

function genName(aa::DistTo)
    return :DistTo
end