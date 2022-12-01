import Charlotte
include("model.jl")
dims = [1, 3, 5, 10, 15]
models = [TMPModel(i) for i in dims]
sols = [mo.A\(-0.5*mo.b) for mo in models]

btr = Charlotte.BasicTrustRegion{Charlotte.HessianMatrix}()

@testset verbose = true "quadratic NLPModels with $(typeof(btr))" begin
    @testset "problem of dimension $(dims[i])" for i in 1:length(dims)
        @test norm(btr(models[i])[1].x - sols[i]) <= 1e-2
    end
end