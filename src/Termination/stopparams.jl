struct ONEVEC{T} <: AbstractVector{T} end
Base.getindex(i::ONEVEC{T}, args::AbstractVector) where T  = ones(T, length(args))
Base.getindex(i::ONEVEC{T}, args::Int) where T = one(T)
Base.getindex(i::ONEVEC{T}, args::Colon) where T = i

import Base.size
function size(obj::ONEVEC{T}) where T
    return 1
end

function Base.println(obj::ONEVEC{T}) where T
    print(" Here is ONEVEC ")
end

abstract type AbstractStopParam end

struct StopParam{TYPX} <: AbstractStopParam
    typX::TYPX
    typVal::Float64
    VMAX::Float64
    tol::Float64
    NMax::Int
    TMax::Float64
    region::Float64
    function StopParam(;NMax::Int = 1_000, TMax::Float64 = 360.0, typX::V = ONEVEC{Float64}(),
            typVal::Float64 = 1.0, VMAX::Float64 = 1e-3, tol::Float64 = 1e-3) where {V <: AbstractVector}
        return new{V}(typX, typVal, VMAX, tol, NMax, TMax, 1e12)
    end
end


const basestopParam = StopParam()

##############################################################################
abstract type SingleStopTest end

struct NMaxTest <: SingleStopTest
    NMax::Int
    NMaxTest(; NMax::Int=1_000) = new(NMax)
end

struct TMaxTest <: SingleStopTest
    TMax::Float64
    TMaxTest(; TMax::Float64 = 300.0) = new(TMax)
end

struct RobustFirstOrderTest{TYPX} <: SingleStopTest
    typX::TYPX
    typVal::Float64
    VMAX::Float64
    tol::Float64
    function RobustFirstOrderTest{V}(;typX::V = ONEVEC{Float64}(),
                                            typVal::Float64 = 1.0,
                                            VMAX::Float64 = 1e-3,
                                            tol::Float64 = 1e-3)  where {V <: AbstractVector}
        return new{V}(typX, typVal, VMAX,tol)
    end
end

struct DivergedTest <: SingleStopTest
    region::Float64
    DivergedTest(;region::Float64 = 1e12) = new(region)
end

struct MahalanobisTest{T} <: SingleStopTest
    dim::Int
    α_error::T
    quantile::T
    function MahalanobisTest{T}(dim::Int, α_error::Float64) where T
        return new{T}(dim, α_error, T(quantile(Chisq(dim), 1 - α_error)))
    end
end

##### All tests

struct StoppingTests <: AbstractStopParam
    stopTests::Array{SingleStopTest}
    function StoppingTests(stopTests::Array{SingleStopTest})
        return new(stopTests)
    end
end
