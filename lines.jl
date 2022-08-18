include("utils.jl")

struct Line
    p1::Vector{T_p1_invec} where T_p1_invec <: Number
    p2::Vector{T_p2_invec} where T_p2_invec <: Number
end

function linevec(l::Line)
    return l.p2 - l.p1
end

function isect_segline(l1::Line, l2::Line)
    l1_vec = linevec(l1)
    l1_to_l2_1 = l2.p1 - l1.p1
    l1_to_l2_2 = l2.p2 - l1.p1

    c1 = cross(l1_vec, l1_to_l2_1)
    c2 = cross(l1_vec, l1_to_l2_2)

    return c1 > 0 && c2 < 0 || c1 < 0 && c2 > 0
end

function isect_segseg(l1::Line, l2::Line)
    return isect_segline(l1, l2) && isect_segline(l2, l1)
end