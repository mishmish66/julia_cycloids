using Symbolics
import Base: convert

const Float = Float64

const NorD = Union{Num,Float}

# NorD(x::Number) = Float(x)

# convert(::Type{NorD}, Num) = NorD(Num)

function rotmat(θ::T) where T <: Number
    return [cos(θ) sin(θ); sin(θ) -cos(θ)]
end

function cross(v1::T, v2::T) where T <: Vector{T_invec} where T_invec <: Number
    return v1[1] * v2[2] - v1[2] * v2[1]
end