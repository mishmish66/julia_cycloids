using GLMakie
include("utils.jl")
include("pcurve.jl")

struct pcircle{T_pos <: Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}, T_rad <: Number, T_θ <: Number} <: pcurve
    pos::T_pos
    radius::T_rad
    θ::T_θ
end

function (circle::pcircle)(θ::Number)
    rotmat(θ + circle.θ) * [circle.radius; 0] + circle.pos
end