include("./curves/cycloid.jl")
include("./curves/lines.jl")
include("./curves/pcircle.jl")
using GLMakie

# vecarr Draw =====================================================================================

function vecarr_lines!(vecarr::T_vecarr where T_vecarr)
    points = reduce(hcat, vecarr)
    lines!(points[1, :], points[2, :])
end

function vecarr_lines!(vecarr::T_vecarr where T_vecarr <: Observable)
    points = @lift(reduce(hcat, $vecarr))
    lines!(@lift($points[1, :]), @lift($points[2, :]))
end

# Cycloid Draw ====================================================================================

function get_cycloid_end(cycloid::Cycloid)
    return min(2π / (cycloid.k + 1), 128π)
end

function get_cycloid_range(cycloid::Cycloid, steps::Int=1024)
    cycloid_end = get_cycloid_end(cycloid)
    return LinRange(-cycloid_end, cycloid_end, steps)
end

# function cycloid_arr(cycloid::Cycloid, steps::Int=1024)
#     cycloid_end = min(2π / (cycloid.k + 1), 128π)
#     step_arr = [t for t in LinRange(-cycloid_end, cycloid_end, steps)]
#     cycloid.(step_arr)
# end

function draw_cycloid(cycloid::Cycloid, steps::Int=1024)
    arr = cycloid.([t for t in get_cycloid_range(cycloid, steps)])
    vecarr_lines!(arr)
end

function draw_cycloid(cycloid::Observable{Cycloid}, steps::Int=1024)
    arr = @lift($cycloid.([t for t in get_cycloid_range($cycloid, steps)]))
    vecarr_lines!(arr)
end

# Circle Draw =====================================================================================

function draw_circle(circle::PCircle, steps::Int=1024)
    step_arr = [t for t in LinRange(0.0, 2π, steps)]
    points = circle.(step_arr)
    # points = reduce(hcat, circle.(step_arr))

    vecarr_lines!(points)
end

function draw_circle(circle::Observable{PCircle}, steps::Int=1024)
    step_arr = [t for t in LinRange(0.0, 2π, steps)]
    points = @lift($circle.(step_arr))

    vecarr_lines!(points)
end

# Line Draw =======================================================================================

function draw_lineseg(seg::Line, steps::Int=1024)
    step_arr = [t for t in LinRange(0.0, 1, steps)]
    points = seg.(step_arr)
    
    vecarr_lines!(points)
end