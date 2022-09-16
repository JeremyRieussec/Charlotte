module Charlotte
using NLPModels, LinearAlgebra, Random, Statistics


export BTRStruct

abstract type AbstractOptimizer end

include("Sampling/main.jl")
include("State/main.jl")

include("Termination/main.jl")
include("Accumulator/main.jl")
#include("SecondOrderApprox/main.jl")

#include("conjugateGradient/main.jl")

include("update/main.jl")

include("FirstOrder/main.jl")
include("SecondOrder/main.jl")

end # module
