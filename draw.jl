using GLMakie

include("cycloid_funcs.jl")

function draw_cycloids(drawn_cycloids::Union{Observable{Cycloid},Cycloid}...)
    foreach(drawn_cycloids) do drawn_cycloid
        draw_cycloid(drawn_cycloid)
    end
end

function draw_cycloid(cycloid::Cycloid, steps=1024)
    cycloid_end = min(2π / (cycloid.k + 1))
    draw_shape(cycloid, 0.0, cycloid_end, steps)
end

function get_cycloid_end(cycloid::Cycloid)
    return min(2π / (cycloid.k + 1), 128π)
end

function draw_cycloid(cycloid::Observable{Cycloid}, steps::Int=1024)
    cycloid_end = min(2π / (cycloid.k + 1))
    draw_shape(cycloid, 0.0, cycloid_end, steps)
end

function get_cycloid_range(cycloid::Cycloid, steps::Int=1024)
    cycloid_end = get_cycloid_end(cycloid)
    return LinRange(-cycloid_end, cycloid_end, steps)
end

function get_cycloid_points(cycloid::Cycloid, steps::Int)
    step_arr = LinRange(0.0, min(2π / (cycloid.k + 1), 1024π), steps)
    points = cycloid.(step_arr)
    return reduce(hcat, points)
end

function draw_shape(shape::T_shape where T_shape, start::T_start where T_start, stop::T_stop where T_stop, steps::T_steps where T_steps)
    step_arr = LinRange(start, stop, steps)
    println(step_arr)
    points = shape.(step_arr)
    points = reduce(hcat, points)
    
    lines!(points[1, :], points[2, :])
end

function vecarr_lines!(vecarr::T_vecarr where T_vecarr)
    points = reduce(hcat, vecarr)
    lines!(points[1, :], points[2, :])
end

function vecarr_lines!(vecarr::T_vecarr where T_vecarr <: Observable)
    points = @lift(reduce(hcat, $vecarr))
    lines!(@lift($points[1, :]), @lift($points[2, :]))
end

function draw_shape(shape::T_shape where T_shape <: Observable, start::T_start where T_start, stop::T_stop where T_stop, steps::T_steps where T_steps)
    step_arr = @lift($LinRange(start, stop, steps))
    points = @lift(reduce(hcat, shape.($step_arr)))
    
    lines!(@lift($points[1, :]), @lift($points[2, :]))
end