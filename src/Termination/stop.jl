
function isOptimal(st::AbstractState, p::StopParam)
    #not optimal if at least one element of g is greatter than VMAX
    #if !all(abs.(st.g) .<= p.VMAX)
    #    return false
    #end
    for i in 1:length(st.x)
        if abs(st.g[i]*max(st.x[i], p.typX[i])/max(st.fx, p.typVal)) > p.tol
            return false
        end
    end
    println("isOptimal")
    return true
end

function asDiverged(st::AbstractState, p::StopParam)
    result = (norm(st.x) >= p.region)
    if result
        println("asDiverged")
    end
    return result
end

function nmaxReached(st::AbstractState, p::StopParam)
    result = (st.iter == p.NMax)
    if result
        println("nmaxReached")
    end
    return result
end

function tmaxReached(st::AbstractState, p::StopParam)
    result = ((st.time - st.time0)*10^-9 >= p.TMax)
    if result
        println("tmaxReached")
    end
    return result
end


################################################################################

function verificationSingleTest(st::AbstractState, p::RobustFirstOrderTest)
    #not optimal if at least one element of g is greatter than VMAX
    #if !all(abs.(st.g) .<= p.VMAX)
    #    return false
    #end
    for i in 1:length(st.x)
        if abs(st.g[i]*max(st.x[i], p.typX[i])/max(st.fx, p.typVal)) > p.tol
            return false
        end
    end
    println("isOptimal")
    return true
end

function verificationSingleTest(st::AbstractState, p::DivergedTest)
    result = (norm(st.x) >= p.region)
    if result
        println("asDiverged")
    end
    return result
end

function verificationSingleTest(st::AbstractState, p::NMaxTest)
    result = (st.iter == p.NMax)
    if result
        println("nmaxReached")
    end
    return result
end

function verificationSingleTest(st::AbstractState, p::TMaxTest)
    result = ((st.time - st.time0)*10^-9 >= p.TMax)
    if result
        println("tmaxReached")
    end
    return result
end

function verificationSingleTest(st::AbstractState, p::MahalanobisTest)
    dotProduct = dot(st.step, st.g)
    N = st.sampling.N
    if (N < st.sampling.NMax)
        return false
    else
        result = (dotProduct <= p.quantile/N)
        if result
            println("MahalanobisTest")
        end
        return result
    end
end


###############################################################################

function statusTest(test::RobustFirstOrderTest)
    return Optimal()
end

function statusTest(test::NMaxTest)
    return NMaxReached()
end

function statusTest(test::TMaxTest)
    return TimeMaxReached()
end

function statusTest(test::DivergedTest)
    return Diverged()
end

function statusTest(test::MahalanobisTest)
    return Mahalanobis()
end



###############################################################################

function verificationOptimality(state::AbstractState, stopparm::StopParam)
    # println("------ ")
    # println("verificationOptimality (StopParam)")
    isOptimal(state, stopparm) && (status = Optimal(); return status)
    asDiverged(state, stopparm) && (status = Diverged(); return status)
    nmaxReached(state, stopparm) && (status = NMaxReached(); return status)
    tmaxReached(state, stopparm) && (status = TimeMaxReached(); return status)
    return Unknown()
end

function verificationOptimality(state::AbstractState, stopparm::StoppingTests)
    # println("------ ")
    # println("verificationOptimality (StoppingTests)")
    for test in stopparm.stopTests
        verificationSingleTest(state, test) && (status = statusTest(test); return status)
    end
    return Unknown()
end
