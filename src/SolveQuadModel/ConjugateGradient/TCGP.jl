struct TruncatedProjectedCG!{C <: AbstractConstraint} <: AbstractConjugateGradient
    stop::Function 
    NMax::Int
    function TruncatedProjectedCG!(;stop = stopCGBase, NMax = 100_000, C::Type = Norm2Constraint)
        return new{C}(stop, NMax)
    end
end

function (TPCG::TruncatedProjectedCG!{CBTR})(state::BTRState{H}, constraint::C) where {CBTR, H, C}
    #Region Size Constraint
    x = state.x
    projectedState = genproj(x, state.H, state.g, constraint)
    @show projectedState
    projg = proj(state.g, projectedState, C)
    projH = proj(state.H, projectedState, C)
    projConstraint = proj(constraint, projectedState, state.x, C)
    projectedDim = length(projg)
    projectedStep = zeros(eltype(x), projectedDim)
    
    constraint = combine(projConstraint, CBTR(state.Δ))
    TCG!(projH, projg, constraint, projectedStep)
    state.step[:] = deproj(projectedStep, projectedState, C)
end

TCGP! = TruncatedProjectedCG!()