using Symbolics
include("cycloid.jl")

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