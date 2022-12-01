include("Constraint/main.jl")

abstract type AbstractQuadSolve end

# function of type AbstractQuadSolve must have arguments
#       - state::BTRState
#       - constraints::Constraint
#       - keywords: 
#           - verbose

function (solveQP::AbstractQuadSolve)(state::BTRState, constraint::AbstractConstraint = Unconstraint(); verbose::Bool = false) where C
    @warn "solving function for $(typeof(solveQP)) not defined"
end

include("OtherMethods/main.jl")
include("ConjugateGradient/main.jl")

global solveQuadModel! = TCG!
function setsolveQuadModel!(f!::Function)
    global solveQuadModel! = f!
end

cg! = TCG!