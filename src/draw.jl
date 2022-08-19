include("./curves/cycloid.jl")
include("./curves/lines.jl")
include("./curves/pcircle.jl")
using GLMakie

# Cycloid Draw ====================================================================================

# function get_cycloid_end(cycloid::Cycloid)
#     # return min(max(2π * (cycloid.k + 1), 2π / (cycloid.k + 1)), 128π)
#     return min(2π / (cycloid.k + 1), 128π)
# end

# function get_cycloid_range(cycloid::Cycloid, steps::Int=1024)
#     cycloid_end = get_cycloid_end(cycloid)
#     return LinRange(-cycloid_end, cycloid_end, steps)
# end

function _get_cycloid_points(cycloid::Cycloid)
    cycloid_end = min(2π / (cycloid.k + 1), 128π)
    range = LinRange(-cycloid_end, cycloid_end, steps)
    return [Point2f(cycloid(t)) for t in range]
end

Makie.convert_arguments(P::PointBased, x::Cycloid) = convert_arguments(P, _get_cycloid_points(x))

# Circle Draw =====================================================================================

function _circle_points(circle::PCircle, steps::Int=1024)
    step_arr = [Point2f(circle(t)) for t in LinRange(0.0, 2π, steps)]
end

Makie.convert_arguments(P::PointBased, x::PCircle) = convert_arguments(P, [Point2f(x.p1), Point2f(x.p2)])

# Line Draw =======================================================================================

Makie.convert_arguments(P::PointBased, x::Line) = convert_arguments(P, [Point2f(x.p1), Point2f(x.p2)])