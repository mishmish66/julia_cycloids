using Symbolics
import Base: convert

const Float = Float64

const NorD = Union{Num,Float}

# NorD(x::Number) = Float(x)

# convert(::Type{NorD}, Num) = NorD(Num)

function rotmat(θ::T) where {T<:Number}
    return [cos(θ) -sin(θ); sin(θ) cos(θ)]
end

function cross(v1::T, v2::T) where {T<:Vector{<:Number}}
    return v1[1] * v2[2] - v1[2] * v2[1]
end

function rotated_unit(θ::T where T<:Number)
    return [cos(θ); sin(θ)]
end

function homtran(θ::T where T<:Number, pos::T where T<:Vector{<:Number})
    M = zeros(3,3)
    M[1:2, 1:2] = rotmat(θ)
    M[3, 3] = 1
    M[3, 1:2] = pos
    return M
end

function normalize!(vec::T where {T<:Vector{<:Number}})
    inv_mag = 1 / sqrt(vec' * vec)

    for i in eachindex(vec)
        vec[i] *= inv_mag
    end

    return vec
end