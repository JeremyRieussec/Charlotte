module Charlotte
using NLPModels, ENLPModels, LinearAlgebra, Random, Statistics, Plots

import NLPModels


include("states/main.jl")
include("Stochastic/Sampling/AbstractSampling/abstractSampling.jl")
include("Accumulator/main.jl")
include("Termination/main.jl")

abstract type AbstractOptimizer end 

abstract type AbstractStochasticMethod end
abstract type Stochastic <:  AbstractStochasticMethod end
abstract type Deterministic <:  AbstractStochasticMethod end


# Deterministic
include("Deterministic/FirstOrder/main.jl")


include("Stochastic/main.jl")


#include("SecondOrderApprox/main.jl")

#include("conjugateGradient/main.jl")

# include("SecondOrder/main.jl")

export changeterminationcriteria, FixedGradientNorm

end # module
