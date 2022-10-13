
include("NoSampling.jl")

############################ Global structure #################################
global genericsampling = NoSampling()
function changesampling(sampling::AbstractSampling)
    global genericsampling = sampling
end

include("Random.jl")
include("Minibatch.jl")
include("PresetIncrease.jl")
# include("Choose1.jl")

# include("Adaptative/main.jl")
