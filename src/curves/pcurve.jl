# Parametric Curve Type
abstract type PCurve end

function approximate(curve::curve_t, steps::steps_t = 2048) where {curve_t <: PCurve, steps_t <: Integer}
    t_vals = [t for t in range(1, estimate_t_end(curve), steps)]
    t_pairs = [(t_vals[i], t_vals[i + 1]) for t in range(1, steps - 1)]
    lines = [Line(curve(t_pair[1]), curve(t_pair[2])) for t_pair in t_pairs]
    return (line_list = lines, t_list = t_pairs)
end

function estimate_t_end(curve::PCurve)
    println("estimate_t_end not implemented for type $(typeof(curve))")
end