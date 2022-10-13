#common learning rates for sgd based methods

function LR1(k::Int, tau::Int, epsilon0::Float64, epsilon::Float64)
    k >= tau ? epsilon : 
        (alpha = k/tau; 
        (1 - alpha) * epsilon0 + alpha * epsilon)
end


function LR2(k::Int, tau::Int, alpha::Float64, epsilon::Float64)
    max(alpha/k, epsilon)
end