struct Norm2Constraint <: AbstractConstraint 
    r::Float64
end
#From s, reach the border of the constraint in the direction d
function reach(s::Vector, d::Vector, nc::Norm2Constraint)
    sd = dot(s, d)
    dd = dot(d,d)
    ss = dot(s,s)
    alpha = (-sd + sqrt(sd^2 - dd*(ss - nc.r*nc.r)))/(2*dd)
    return alpha
end

function outside(s::Vector, TC::Norm2Constraint)
    return dot(s,s) > TC.r^2
end

function inside(s::Vector, TC::Norm2Constraint)
    return dot(s,s) <= TC.r^2
end

