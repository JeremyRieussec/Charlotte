abstract type AbstractBatchSampling <: AbstractSampling end

mutable struct BatchSampling{SHU} <: AbstractBatchSampling
    N::Int
    start::Int #curent batch
    NMax::Int
    shu::SHU
    function BatchSampling{SHU}(;N::Int = 100, NMax::Int = 10) where SHU
        n = new{SHU}()
        n.start = 1
        n.NMax = NMax
        n.N = N
        return n
    end
    function BatchSampling(;N::Int = 100, NMax::Int = 10)
        n = new{UnitRange{Int64}}()
        n.start = 1
        n.NMax = NMax
        n.N = N
        return n
    end
end

########################## Dynamic ##################################
abstract type AbstractDynamicBatchSampling <: AbstractBatchSampling end

# Pour creer un minibatch qui peut changer de taille

function sample(s::BatchSampling; isFunc::Bool = false, isGrad::Bool = false, isHes::Bool = false)
    if s.start + s.N <= s.NMax
        return s.shu[s.start:s.start+s.N-1]
    else
        N1 = s.NMax - s.start
        N2 = s.N - N1
        return union(s.shu[s.start:s.NMax], s.shu[1:N2-1])
    end
end
