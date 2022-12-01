## ##############     For Variance calculation     #####################

abstract type AbstractVar end

mutable struct TrueVar{T} <: AbstractVar
    f_old::T
    f_cand::T
    f_cur::T

    f_values_old::Array{T, 1}
    f_values_cand::Array{T, 1}
    f_values_cur::Array{T, 1}

    smoothing::AbstractSmoothing

    alpha_error::T
    z_alpha::T
    function TrueVar{T}(smoothing::AbstractSmoothing ;
                            alpha_error::T = T(0.05)) where T
        z_alpha = quantile(Normal(), 1 - alpha_error)

        return new{T}(zero(T), zero(T), zero(T), T[], T[], T[], smoothing, T(alpha_error), T(z_alpha))
    end
end

mutable struct FirstOrderVar{S<:AbstractSampling} <: AbstractVar
    smoothing::AbstractSmoothing

    alpha_error::Float64
    z_alpha::Float64

    function FirstOrderVar( sam::Type{S}, smoothing::AbstractSmoothing;
                            alpha_error::Float64 = 0.05) where {S<:AbstractSampling}

        z_alpha = quantile(Normal(), 1 - alpha_error)

        return new{S}(smoothing, alpha_error, z_alpha)
    end
end

mutable struct FirstOrderVarApprox{S<:AbstractSampling} <: AbstractVar
    smoothing::AbstractSmoothing

    alpha_error::Float64
    z_alpha::Float64

    function FirstOrderVarApprox(sam::Type{S}, smoothing::AbstractSmoothing ;
                            alpha_error::Float64 = 0.05) where {S<:AbstractSampling}

        z_alpha = quantile(Normal(), 1 - alpha_error)

        return new{S}(smoothing, alpha_error, z_alpha)
    end
end
