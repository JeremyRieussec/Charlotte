@enum HessianApproximation HessianMatrix Hessianprod

function updatehessian!(mo::AbstractNLPModel, state::BTRState, ::Val{HessianMatrix})
    state.H = hess(mo, state.x)
end
function updatehessian!(mo::AbstractNLPModel, state::BTRState, ::Val{Hessianprod})
    state.H = hess(mo, state.x)
end
function updatehessian!(mo::AbstractNLPModel, state::BTRState, ha::HessianApproximation)
    return updatehessian!(mo, state, Val(ha))
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