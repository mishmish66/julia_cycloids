include("../utils.jl")
include("pcircle.jl")

# Basic Cycloid Functionality =====================================================================

mutable struct Cycloid <: PCurve
    l1::T_l1 where {T_l1<:Number}    # inner element radius
    l2::T_l2 where {T_l2<:Number}    # outer element radius
    k::T_k where {T_k<:Number}     # element relative rate
    θ::T_θ where {T_θ<:Number}      # angle
    pos::T_pos where {T_pos<:Union{Symbolics.Arr{Num,},Vector{T} where T<:Number}}  # position
    inset::T_inset where T_inset<:Number
end

function _get_base_cycloid_edge(cycloid::Cycloid, t::T) where T <: Number
    inner_element = PCircle(cycloid.pos, cycloid.l1, cycloid.θ)
    outer_element = PCircle(inner_element(t), cycloid.l2, t + inner_element.θ)

    return outer_element(t * cycloid.k)
end

function (cycloid::Cycloid)(t::T) where T <: Number
    edge = _get_base_cycloid_edge(cycloid, t)

    norm = cycloid_normal(cycloid, t)
    center_edge = edge - cycloid.pos
    inward = center_edge' * norm < 0.0

    return edge + norm .* (cycloid.inset) .* (inward ? 1 : -1)
end

# Cycloid dr⃗dt Calculation =======================================================================

const symbolic_cycloid_vars = @variables (l1, l2, k, θ, pos[1:2], inset, t_sym)
cyc_vars = (l1, l2, k, θ, pos, inset)
sym_cyc = Cycloid(cyc_vars...)

r⃗ = _get_base_cycloid_edge(sym_cyc, t_sym)
ddt(x::T) where T = simplify(Symbolics.jacobian(x, [t_sym])[:])
dr⃗dt = simplify(ddt(r⃗))
const cycloid_symbolic_dr⃗dt = dr⃗dt

macro cycloid_d()
    return build_function(cycloid_symbolic_dr⃗dt, symbolic_cycloid_vars...)[1]
end

function cycloid_d(cycloid::Cycloid, t::T) where T <: Number
    @cycloid_d()(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, inset, t)
end

# Cycloid Normal Calculation ======================================================================

mag_dr⃗dt = sqrt(dr⃗dt' * dr⃗dt)
t̂ = dr⃗dt ./ mag_dr⃗dt

c = ddt(t̂)
mag_c = sqrt(c' * c)
ĉ = simplify(c ./ mag_c)

const cycloid_symbolic_ĉ = ĉ

# I was hoping this would be a cleaner way to define these things than macros but I didn't finish

# const _cycloid_normal_expr = build_function(cycloid_symbolic_ĉ, symbolic_cycloid_vars...)[1]

# const cycloid_normal = function (cycloid::Cycloid, t::T) where T <: Number
#     return _cycloid_normal(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, t)
# end

macro cycloid_normal()
    return build_function(cycloid_symbolic_ĉ, symbolic_cycloid_vars...)[1]
end

function cycloid_normal(cycloid::Cycloid, t::T) where T <: Number
    @cycloid_normal()(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, cycloid.inset, t)
end