using GLMakie
include("utils.jl")

struct Circle{T_pos <: Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}, T_rad <: Number, T_θ <: Number}
    pos::T_pos
    radius::T_rad
    θ::T_θ
end

function (circle::Circle)(θ::Number)
    rotmat(θ + circle.θ) * [circle.radius; 0] + circle.pos
end

function draw_circle(circle::Circle, steps::Int=1024)
    step_arr = LinRange(0.0, 2π, steps)
    points = reduce(hcat, circle.(step_arr))

    lines!(points[1, :], [2, :])
end