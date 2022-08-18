include("utils.jl")
include("pcircle.jl")

# Basic Cycloid Functionality =====================================================================

mutable struct Cycloid
    l1::T_l1 where {T_l1<:Number}    # inner element radius
    l2::T_l2 where {T_l2<:Number}    # outer element radius
    k::T_k where {T_k<:Number}     # element relative rate
    θ::T_θ where {T_θ<:Number}      # angle
    pos::T_pos where {T_pos<:Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}}  # position
    inset::T_inset where T_inset<:Number
end

function _get_base_cycloid_edge(cycloid::Cycloid, t::T) where T <: Number
    inner_element = pcircle(cycloid.pos, cycloid.l1, cycloid.θ)
    outer_element = pcircle(inner_element(t), cycloid.l2, t + inner_element.θ)

    return outer_element(t * cycloid.k)
end

function (cycloid::Cycloid)(t::T) where T <: Number
    edge = _get_base_cycloid_edge(cycloid, t)

    norm = cycloid_normal(cycloid, t)
    center_edge = edge - cycloid.pos
    inward = center_edge' * norm < 0.0

    return edge + norm .* (cycloid.inset) .* (inward ? 1 : -1)
end

# Cycloid Tangent Calculation =====================================================================

macro cycloid_d()
    vars = @variables (l1, l2, k, θ, pos[1:2], inset, t_sym)
	cyc_vars = (l1, l2, k, θ, pos, inset)
    sym_cyc = Cycloid(cyc_vars...)

    r⃗ = get_cycloid_edge(sym_cyc, t_sym)
    ddt(x::T) where T = simplify(Symbolics.jacobian(x, [t_sym])[:])
    dr⃗dt = ddt(r⃗)

    return build_function(dr⃗dt, vars...)[1]
end

function cycloid_d(cycloid::Cycloid, t::T) where T <: Number
    @cycloid_d()(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, inset, t)
end

# Cycloid Normal Calculation ======================================================================

macro cycloid_normal()
    vars = @variables (l1, l2, k, θ, pos[1:2], t_sym)
	cyc_vars = (l1, l2, k, θ, pos)
    sym_cyc = Cycloid(cyc_vars..., 0.0)

    r⃗ = get_cycloid_edge(sym_cyc, t_sym)
    ddt(x::T) where T = simplify(Symbolics.jacobian(x, [t_sym])[:])
    dr⃗dt = ddt(r⃗)
    mag_dr⃗dt = sqrt(dr⃗dt' * dr⃗dt)
    t̂ = dr⃗dt ./ mag_dr⃗dt

    c = ddt(t̂)
    mag_c = sqrt(c' * c)
    ĉ = simplify(c ./ mag_c)
	
    return build_function(ĉ, vars...)[1]
end

function cycloid_normal(cycloid::Cycloid, t::T) where T <: Number
    @cycloid_normal()(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, t)
end