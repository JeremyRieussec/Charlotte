struct TruncatedConjugateGradient!{C <: AbstractConstraint} <: AbstractConjugateGradient
    stop::Function
    NMax::Int

    nbIterCG::Int

    function TruncatedConjugateGradient!(;stop = stopCGBase, NMax = 10, C::Type = Norm2Constraint)
        return new{C}(stop, NMax, 0)
    end
end

function (TCG!::TruncatedConjugateGradient!{C})(mo::AbstractNLPModel, state::BTRState, constraint::AbstractConstraint = Unconstraint(); verbose::Bool = false) where C
    c = combine(constraint, C(state.Delta))

    verbose && println("--- TCG classic ")
    
    TCG!.nbIterCG = TCG!(mo, state.x, state.H, state.grad, c, state.step, verbose = verbose)
end


function (TCG!::TruncatedConjugateGradient!{C})(mo::AbstractNLPModel, x::Vector{T}, H::AbstractMatrix, g::Vector{T}, TC, s::Vector{T}; verbose::Bool = false) where {T,C}
    s[:] .= T(0.0)
    normg0 = norm(g)
    n = length(g)
    r =  matrixVectorProduct(mo, x, v, H)
    p = -r
    k = 0
    Hp = zeros(n)
    
    while !TCG!.stop(norm(p), normg0, k, min(n, TCG!.NMax))
        Hp[:] = H*p
        κ = dot(p,Hp)
        verbose && println("κ = ", κ)
        k+=1
        if κ <= 0
            s[:] += reach(s, p, TC) * p
            verbose && println("TCG on border")
            break
        end
        alpha = dot(r, r)/dot(p, Hp)
        if outside(s+alpha*p, TC)
            alpha = reach(s, p, TC)
            s[:] += alpha * p
            verbose && println("TCG on border")
            break
        end
        s[:] += alpha*p
        rrold = dot(r,r)
        r[:] += alpha*Hp
        beta = dot(r, r)/rrold
        p[:] .*= beta
        p[:] -= r

    end
    verbose && println("TCG stoped on iteration $k")

    return k
end

TCG! = TruncatedCG! = TruncatedConjugateGradient!()
