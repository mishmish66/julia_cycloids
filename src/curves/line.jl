include("../utils.jl")
include("pcurve.jl")

struct Line <: PCurve
    p1::T where T<:Vector{<:Number}
    p2::T where T<:Vector{<:Number}
end

function linevec(l::Line)
    return l.p2 - l.p1
end

function approximate(line::Line)
    return (line_list=[line], t_list=[(0.0, 1.0)])
end

function estimate_t_end(line::PCurve)
    return 1
end

function (line::Line)(t::T) where {T<:Number}
    return (1-t)*line.p1 + t*line.p2
end

import Base: -
import Base: *

function -(vec1::T where T <: AbstractVector{<:Number}, vec2::T where T <: AbstractVector{<:Number})
    len = min(length(vec1), length(vec2))
    return [vec1[i] - vec2[i] for i in 1:len]
end

function -(line::Line, vec::T where T <: AbstractVector{<:Number})
    return Line(-(line.p1, vec), -(line.p2, vec))
end

function *(mat::AbstractMatrix{<:Number}, line::Line)
    return Line(mat * line.p1, mat * line.p2)
end