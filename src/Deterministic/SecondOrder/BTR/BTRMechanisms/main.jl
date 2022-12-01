#-------------------          Trust Region mechanisms      -----------------------
abstract type AbstractBasicTrustRegion end

@inline function acceptCandidate!(state::BTRState, b::AbstractBasicTrustRegion)::Bool
    @warn "acceptCandidate! not defined for $(typeof(b))"
end

function updateRadius!(state::BTRState, b::AbstractBasicTrustRegion)
    @warn "updateRadius! not defined for $(typeof(b))"
end

include("coeffMechanism.jl")
include("stepNormMechanism.jl")
include("gradientMechanism.jl")