include("../utils.jl")
include("pcurve.jl")
include("pcircle.jl")
include("line.jl")
include("cycloid.jl")

abstract type Isect end

function isect(c1::PCurve, c2::PCurve)
    c1_approx_seglist = appriximate(c1)
    c2_approx_seglist = approximate(c2)
    return isect_seglist_seglist(c1_approx_seglist, c2_approx_seglist)
end

function isect_line_line(l₁::Line, l₂::Line)
    l⃗₁ = linevec(l₁)
    l⃗₂ = linevec(l₂)

    l₂⬅l₁_₁ = l₂ - l₁.p1
    
    squeeze = [l⃗₁ normalize!(l⃗₂)]
end

function isect_seg_line(seg::Line, line::Line)
    l1_vec = linevec(l1)
    seg1_to_line1 = seg.p1 - line.p1
    seg2_to_line1 = seg.p2 - line.p1

    c1 = 
    c2 = 

    if cross(l1_vec, l1_to_l2_2) * cross(l1_vec, l1_to_l2_1) < 0
        return c1
end

function isect_seg_seg(l1::Line, l2::Line)
    return isect_seg_line(l1, l2) && isect_seg_line(l2, l1)
end

function (line::Line)(t::Number)
    return (1-t)*line.p1 + t*line.p2
end



function isect_seg_seglist(seg::Line, seglist::Vector{Line})
    for i in eachindex(seglist)
        if isect_segseg(seg, seglist[i])
            return i
        end
    end
    return 0
end

function isect_seglist_seglist(seglist1::Vector{Line}, seglist2::Vector{Line})
    for i1 in eachindex(seglist1)
        i2 = isect_seg_seglist(seglist1[i1], seglist2)
        if (i2 > 0)
            return (i1, i2)
        end
    end
    return nothing
end

# returns earlier one first in tuple
function isect_seglist_self(seglist::Vector{Line})
    for i in 1:(length(seglist)-1)
        seg = seglist[i+1]
        i_isect = isect_seg_seglist(seg, seglist[1:i])
        if i_isect > 0
            return (i_isect, i)
        end
    end
    return (0)
end