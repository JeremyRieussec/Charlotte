
struct NaiveSolveQuad{C <: AbstractConstraint} <: AbstractQuadSolve

    function NaiveSolveQuad(; C::Type = Norm2Constraint)
        return new{C}( 0)
    end
end

function (NaiveSQ!::NaiveSolveQuad{C})(state::BTRState, constraint::AbstractConstraint = Unconstraint(); verbose::Bool = false) where C
    c = combine(constraint, C(state.Delta))

    verbose && println("--- Naive solving ")
    
    state.step = state.H \ (-0.5*state.grad)

    # truncate to trust-region boundaries
    if norm(state.step) > state.Delta
        state.step = state.Delta * normalize(state.step)
    end

end

