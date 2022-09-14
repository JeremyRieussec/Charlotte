module Charlotte
using ENLPModels, LinearAlgebra, QPSolve

include("states/main.jl")
include("Accumulator/main.jl")
include("Termination/main.jl")
include("secondorder/main.jl")
end # module
