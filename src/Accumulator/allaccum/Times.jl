struct Times <: AbstractAccumulator{Float64}
    times::Array{Float64, 1}
    function Times(times::Array{Float64, 1} = Float64[])
        return new(times)
    end
end

function accumulate!(state::AbstractState, accumulator::Times, mo::AbstractNLPModel)
    #ti = time_ns()
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.times, state.time)
    end
end

function getData(accumulator::Times)
    return (accumulator.times .- accumulator.times[1])*accumulator.coeff_conversion
end
