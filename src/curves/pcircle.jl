include("line.jl")

struct PCircle{T_pos<:AbstractVector{<:Number},T_rad<:Number,T_θ<:Number} <: PCurve
    pos::T_pos
    radius::T_rad
    θ::T_θ
end

function (circle::PCircle)(θ::Number)
    rotmat(θ + circle.θ) * [circle.radius; 0] + circle.pos
end

function estimate_t_end(_::PCircle)
    return 2π
end

# function approximate(circle::PCircle, steps::Integer = 1024)
#     return [Line(point_arr[i], point_arr[i + 1]) for i in range(1, steps-1)]
# end