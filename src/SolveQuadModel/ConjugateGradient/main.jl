abstract type AbstractConjugateGradient <: AbstractQuadSolve end

include("stopCG.jl")
include("CG.jl")
include("TCG.jl")
include("TCGP.jl")

