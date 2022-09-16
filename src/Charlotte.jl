module Charlotte
using ENLPModels, LinearAlgebra, Random, Statistics

include("states/main.jl")
include("Accumulator/main.jl")
include("Termination/main.jl")

abstract type AbstractOptimizer end

# include("Sampling/main.jl")

#include("SecondOrderApprox/main.jl")

#include("conjugateGradient/main.jl")

# include("update/main.jl")

# include("FirstOrder/main.jl")
# include("SecondOrder/main.jl")

end # module
