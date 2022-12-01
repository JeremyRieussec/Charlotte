@enum HessianApproximation HessianMatrix Hessianprod

function matrixVectorProduct(mo::AbstractNLPModel, x::Vector, v::Vector,  ha::HessianApproximation)
    @warn "matrixVectorProduct not defined for $(typeof(ha))"
end

function updatehessian!(mo::AbstractNLPModel, state::BTRState, ha::HessianApproximation)
    return updatehessian!(mo, state, Val(ha))
end



function updatehessian!(mo::AbstractNLPModel, state::BTRState, ::Val{HessianMatrix})
    state.H = ENLPModels.hess(mo, state.x)
end

function updatehessian!(mo::AbstractNLPModel, state::BTRState, ::Val{Hessianprod})
    state.H = ENLPModels.hess(mo, state.x)
end

function matrixVectorProduct(mo::AbstractNLPModel, x::Vector, v::Vector,  ha::HessianMatrix)
    return ENLPModels.hprod(mo, x, v)
end


function gethesstype(ha::HessianApproximation, ::Type{T}) where T
    return gethesstype(Val(ha), T)
end

function gethesstype(::Val{HessianMatrix}, ::Type{T}) where T
    return Matrix{T}
end

function gethesstype(::Val{Hessianprod}, ::Type{T}) where T
    return #Matrix{T} #todo
end

