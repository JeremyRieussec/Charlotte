abstract type Status end

struct Optimal <: Status end
struct NMaxReached <: Status end
struct TimeMaxReached <: Status end
struct Diverged <: Status end
struct Mahalanobis <: Status end

struct Unknown <: Status end

genSymbol(::Optimal) = :Optimal
genSymbol(::NMaxReached) = :NMaxReached
genSymbol(::TimeMaxReached) = :TimeMaxReached
genSymbol(::Diverged) = :Diverged
genSymbol(::Mahalanobis) = :Mahalanobis

genSymbol(::Unknown) = :Unknown
