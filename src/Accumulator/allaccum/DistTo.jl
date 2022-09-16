struct DistTo <: AbstractAccumulator{Float64}
    d::Array{Float64, 1}
    xstar::Array{Float64, 1}
    function DistTo(xstar::Array{Float64, 1})
        return new([], xstar)
    end
    function DistTo(d::Array{Float64, 1}, xstar::Array{Float64, 1})
        return new(d, xstar)
    end
end
function accumulate!(state::AbstractState, accumulator::DistTo, mo::AbstractNLPModel)
    push!(accumulator.d, norm(state.x - accumulator.xstar))
end


function DistTo(p::DistTo)
    return p.d
end

function getData(accumulator::DistTo)
    return accumulator.d
end