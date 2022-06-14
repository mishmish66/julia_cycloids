include("cycloid.jl")
include("cycloid_normal.jl")

function (cycloid::Cycloid)(t::T) where T <: Number
    edge = get_cycloid_edge(cycloid, t)

    norm = cycloid_normal(cycloid, t)
    center_edge = edge - cycloid.pos
    inward = center_edge' * norm < 0.0

    return edge + norm .* (cycloid.inset) .* (inward ? 1 : -1)
end