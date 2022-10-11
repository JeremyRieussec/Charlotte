module Charlotte
using NLPModels, ENLPModels, LinearAlgebra, Random, Statistics, Plots

import NLPModels

include("states/main.jl")
include("Accumulator/main.jl")
include("Termination/main.jl")

abstract type AbstractOptimizer end 

include("FirstOrder/main.jl")

# include("Sampling/main.jl")

#include("SecondOrderApprox/main.jl")

#include("conjugateGradient/main.jl")

# include("update/main.jl")

# include("SecondOrder/main.jl")

export changeterminationcriteria, FixedGradientNorm

end # module
