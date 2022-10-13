mutable struct Choose1{RNG} <: AbstractSampling
    rng::RNG
    k::Int
    NMax::Int
    function Choose1(;NMax::Int = 10, rng::RNG = MersenneTwister(67467842763249)) where RNG
        n = new{RNG}()
        n.NMax = NMax
        n.rng = rng
        return n
    end
end
function sample(s::Choose1; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    return [s.k]
end
