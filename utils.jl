using Symbolics
import Base: convert

const Float = Float64

const NorD = Union{Num,Float}

# NorD(x::Number) = Float(x)

# convert(::Type{NorD}, Num) = NorD(Num)

function rotmat(θ::T) where T <: Number
    return [cos(θ) sin(θ); sin(θ) -cos(θ)]
end