include("utils.jl")
include("circle.jl")

# {T_l1<:Number,T_l2<:Number,T_k<:Number,T_θ<:Number,T_pos<:Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}}
mutable struct Cycloid
    l1::T_l1 where {T_l1<:Number}    # inner element radius
    l2::T_l2 where {T_l2<:Number}    # outer element radius
    k::T_k where {T_k<:Number}     # element relative rate
    θ::T_θ where {T_θ<:Number}      # angle
    pos::T_pos where {T_pos<:Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}}  # position
    inset::T_inset where T_inset<:Number
end

function get_cycloid_edge(cycloid::Cycloid, t::T) where T <: Number
    inner_element = Circle(cycloid.pos, cycloid.l1, cycloid.θ)
    outer_element = Circle(inner_element(t), cycloid.l2, t + inner_element.θ)

    return outer_element(t * cycloid.k)
end