include("isect.jl")

# This is a struct that is meant to be produced by a factory function which finds the intersection of the curve
struct Closed_Curve <: PCurve
    curve::PCurve
    start_t::start_t_type where {start_t_type<:Number}
    end_t::end_t_type where {end_t_type<:Number}
end

# This is very naive, should add some kind of dr⃗dt to it, but I'm too lazy right now
function closed_curve(curve::T where T<:PCurve, tolerance::T where T<:Number = 0.0001)
    seglist, t_pairs = approximate(curve)

    found = false

    for i in range(1, length(seglist) - 1)
        seg = seglist[i+1]
        if isect_seglist_self(seglist)
            start_t, end_t = converge_intersection(seg, t_pairs[i], t_pairs[i + 1], tolerance)
            found = true
        end
    end

    if !found
        return nothing
    end
end

function converge_intersection(
    curve::T where T <: PCurve,
    start_t_tuple::T where {T<:Tuple{<:Number,<:Number}},
    end_t_tuple::T where {T<:Tuple{<:Number,<:Number}},
    tolerance::T where T <: Number)

    start_t_bisect = (start_t_tuple[1] + start_t_tuple[2]) / 2
    end_t_bisect = (end_t_tuple[1] + end_t_tuple[2]) / 2

    r⃗_1_2 = curve(end_t_bisect) - curve(start_t_bisect)
    if (r⃗_1_2' * r⃗_1_2 < tolerance^2)
        return (start_t_bisect, end_t_bisect)
    end

    start_lower = Line(curve(start_t_tuple[1]), curve(start_t_bisect))
    start_higher = Line(curve(start_t_bisect), curve(start_t_tuple[2]))
    end_lower = Line(curve(end_t_tuple[1]), curve(end_t_bisect))
    end_higher = Line(curve(end_t_bisect), curve(end_t_tuple[2]))

    # This is ugly but is the best way I can think of right now for just 4 cases
    if isect_segseg(start_lower, end_lower)
        return converge_intersection(curve, (start_t_tuple[1], start_t_bisect), (end_t_tuple[1], end_t_bisect), tolerance)
    elseif isect_segseg(start_lower, end_higher)
        return converge_intersection(curve, (start_t_tuple[1], start_t_bisect), (end_t_bisect, end_t_tuple[2]), tolerance)
    elseif isect_segseg(start_higher, end_lower)
        return converge_intersection(curve, (start_t_bisect, start_t_tuple[2]), (end_t_tuple[1], end_t_bisect), tolerance)
    else #if isect_segseg(start_higher, end_lower)
        return converge_intersection(curve, (start_t_bisect, start_t_tuple[2]), (end_t_bisect, end_t_tuple[2]), tolerance)
    end
end

function estimate_t_end(closed_curve::Closed_Curve)
    return 1
end