struct ConjugateGradient{C <: AbstractConstraint} <: AbstractConjugateGradient
    stop::Function 
    NMax::Int

    nbIterCG::Int

    function ConjugateGradient(;stop = stopCGBase, NMax = 100_000, C::Type = Norm2Constraint)
        return new{C}(stop, NMax, 0)
    end
end

function (cg!::ConjugateGradient{C})(state::BTRState, constraint::AbstractConstraint = Unconstraint(); verbose::Bool = false) where C
    c = combine(constraint, C(state.Delta))

    verbose && println("--- CG classic ")
    
    cg!(state.H, state.grad, state.step)
end

function (cg!::ConjugateGradient)(H::AbstractMatrix, g::Vector, s::Vector)
    normg0 = norm(g)
    n = length(x)
    r =  H*s + g
    p = -r
    k = 0
    Hp = zeros(n)
    alpha = 0.0
    rrold = 0.0
    while ! cg!.stop(norm(g), normg0, k, n, cg!.NMax)
        Hp[:] = H*p
        κ = p'*Hp
        if κ <= 0 
            return Inf*ones(n)
        end
        alpha = (r'*r)/(p'*Hp)
        x += alpha*p
        rrold = r'*r
        r += alpha*Hp
        beta = r'*r/rrold
        p[:] .*= beta
        p[:] -= r
        k+=1
    end
end

CG! = ConjugateGradient()