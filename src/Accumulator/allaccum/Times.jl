##################################################################################
#                   Accumulate Times 
##################################################################################


struct Times{T} <: AbstractSingleAccumulator
    times::Array{T, 1} # in nanoseconds

    atinterval::Int # frequence of storage
    coeff_conversion::T # for conversion from to nanoseconds to desired unit

    function Times{T}(times::Array{T, 1} = T[]; atinterval::Int = 1, coeff_conversion::T = T(1e-9)) where T
        return new{T}(times, atinterval, coeff_conversion)
    end

    function Times(; atinterval::Int = 1, coeff_conversion::Float64 = 1e-9) where T
        return Times{Float64}(Float64[]; atinterval = atinterval, coeff_conversion = coeff_conversion)
    end
end

function accumulate!(state::AbstractState, accumulator::Times{T}) where T
    if state.iter % accumulator.atinterval == 0
        push!(accumulator.times, T(state.time))
    end
end

function getData(accumulator::Times)
    return (accumulator.times .- accumulator.times[1])*accumulator.coeff_conversion
end

function genName(aa::Times)
    return :Times
end