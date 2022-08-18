using Symbolics

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