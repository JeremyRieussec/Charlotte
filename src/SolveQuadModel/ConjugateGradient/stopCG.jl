function stopCGBase(normg::T, normg0::T, k::Int, kmax::Int) where T
    χ::T = T(0.1)
    θ::T = T(0.5)
    if (k == kmax) || (normg <= normg0*min(χ, normg0^θ))
        return true
    else
        return false
    end
end
