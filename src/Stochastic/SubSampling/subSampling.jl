## ############### For Hessian gestion -- SubSampling #################

### Not done yet
#       - variable subsample size --> see Krejic

abstract type AbstractSubSampling end

struct ConstantSizeSubSampling <: AbstractSubSampling
    N::Int
    ConstantSizeSubSampling(N::Int) = new(N)
end

struct ConstantCoeffSubSampling <: AbstractSubSampling
    Nmax::Int
    coeff::Float64
    ConstantCoeffSubSampling(maxSize::Int, coeff::Float64) = new(maxSize, coeff)
end

################# function computation sub-sample size ###################
function computeSubSampleSize(subSampling::ConstantSizeSubSampling, N::Int, minSize::Int, maxSize::Int)
    return max(minSize , min(subSampling.N, maxSize))
end

function computeSubSampleSize(subSampling::ConstantCoeffSubSampling, N::Int, minSize::Int, maxSize::Int)
    return max(minSize , min(ceil(Int, subSampling.coeff*N), maxSize, subSampling.Nmax))
end

##### println
import Base.println

function println(subSampling::ConstantCoeffSubSampling)
    println("Constant coefficient subSampling : \n" )
    println(" - max size = $(subSampling.Nmax)\n")
    println(" - coeff = $(subSampling.coeff)\n")
end

import Base.write

function write(io::IOStream, subSampling::ConstantCoeffSubSampling)
    write(io,"Constant coefficient subSampling : \n" )
    write(io," - max size = $(subSampling.Nmax)\n")
    write(io, " - coeff = $(subSampling.coeff)\n")
end

function write(io::IOStream, subSampling::ConstantSizeSubSampling)
    write(io, "Constant coefficient subSampling \n" )
    write(io, " - max size = $(subSampling.Nmax) \n")
end
