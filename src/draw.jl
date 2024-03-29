include("./curves/cycloid.jl")
include("./curves/line.jl")
include("./curves/pcircle.jl")
using MakieCore

# Cycloid Draw ====================================================================================

function _get_cycloid_points(cycloid::Cycloid)
    cycloid_end = min(2π / (cycloid.k + 1), 128π)
    range = LinRange(-cycloid_end, cycloid_end, 2048)

    return [Point2f(cycloid(t)) for t in range]
end

function _get_cycloid_points(cycloid::ICycloid)
    cycloid_end = 2π/cycloid.Nᵣ/2 #abs((2π * cycloid.Nᵣ - cycloid.Nₗ)/cycloid.Nₗ)
    range = LinRange(-cycloid_end, cycloid_end, 2048)

    return [Point2f(cycloid(t)) for t in range]
end

PointBased = MakieCore.PointBased

MakieCore.convert_arguments(P::PointBased, x::Cycloid) = convert_arguments(P, _get_cycloid_points(x))

MakieCore.convert_arguments(P::PointBased, x::ICycloid) = convert_arguments(P, _get_cycloid_points(x))

# Circle Draw =====================================================================================

function _get_circle_points(circle::PCircle, steps::Int=1024)
    step_arr = [Point2f(circle(t)) for t in LinRange(0.0, 2π, steps)]
end

MakieCore.convert_arguments(P::PointBased, x::PCircle) = convert_arguments(P, _get_circle_points(x))

# Line Draw =======================================================================================

MakieCore.convert_arguments(P::PointBased, x::Line) = convert_arguments(P, [Point2f(x.p1), Point2f(x.p2)])