using GLMakie
include("cycloid.jl")

function get_cycloid_end(cycloid::Cycloid)
    return min(2π / (cycloid.k + 1), 128π)
end

function get_cycloid_range(cycloid::Cycloid, steps::Int=1024)
    cycloid_end = get_cycloid_end(cycloid)
    return LinRange(-cycloid_end, cycloid_end, steps)
end

function vecarr_lines!(vecarr::T_vecarr where T_vecarr)
    points = reduce(hcat, vecarr)
    lines!(points[1, :], points[2, :])
end

function vecarr_lines!(vecarr::T_vecarr where T_vecarr <: Observable)
    points = @lift(reduce(hcat, $vecarr))
    lines!(@lift($points[1, :]), @lift($points[2, :]))
end

function draw_circle(circle::AngledCircle, steps::Int=1024)
    step_arr = LinRange(0.0, 2π, steps)
    points = reduce(hcat, circle.(step_arr))

    lines!(points[1, :], [2, :])
end