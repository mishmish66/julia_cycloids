include("cycloid_funcs.jl")
include("lines.jl")

using Symbolics

struct cycloid_gear
    cycloid::OffsetCycloid
    tooth_count::Int
    internal::Bool
    end_t::T_end_t where T_end_t <: Number
end

function cycloid_gear(cycloid::OffsetCycloid, tooth_count::Int, internal::Bool)
    next_tooth_segment(tooth)
end

function create_segment_array_to_loop!(larr::Array{Tuple2{Line, Float, Float}}, cycloid::OffsetCycloid, limit::T_limit = 10000) where T_limit <: Number
    step = 0.01
    current::Int
    isect_count::Int

    for i in 1:limit
        cur_t = step*i
        current_line = Line(cycloid(cur_t - 1), cycloid(cur_t))
        if intersect_parr(larr, current_line)
            isect_count+= 1
            if isect_count 
        else
            isect_count = 0
        end

        larr[i] = (Line(cycloid(cur_t - 1), cycloid(cur_t)), cur_t - 1, cur_t)
    end
end

function intersect_parr(larr::Array{Tuple2{Tuple2{Point, Float}, Tuple2{Point, Float}}}, myline)
    for curline in larr
        if isect_segseg(curline, myline)
            return true
        end
    end
    return false
end

function find_intersect(t1::T, t2::T) where T <: Number
    