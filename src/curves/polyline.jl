using("line.jl")

struct PolyLine <: PCurve
    lines::Vector{Line}
end

function (polyline::PolyLine)(t<:Real)
    lines[trunc(t) % estimate_t_end(polyline)](t % 1)
end

function estimate_t_end(polyline <: PolyLine)
    return length(polyline.lines)
end