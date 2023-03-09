include("../utils.jl")
include("pcircle.jl")
include("line.jl")
include("../../optimization_plan.jl")

# Instant Velocity Center Cycloid =================================================================
mutable struct ICycloid <: PCurve
    E::T where T<:Number
    R::T where T<:Number
    Rᵣ::T where T<:Number # Negative if gear is internal
    Nₗ::T where T<:Number # Number of Lobes
    Nᵣ::T where T<:Number # Number of Rollers
end

macro unpack(cycloid)
    # println(cycloid)
    return quote
        E = $cycloid.E
        R = $cycloid.R
        Rᵣ = $cycloid.Rᵣ
        Nₗ = $cycloid.Nₗ
        Nᵣ = $cycloid.Nᵣ
    end
end

# function mᵥ(cycloid::ICycloid)
#     E, R, Rᵣ, Nₗ, Nᵣ = cycloid.E, cycloid.R, cycloid.Rᵣ, cycloid.Nₗ, cycloid.Nᵣ
#     return (Nₗ-Nᵣ)/Nₗ
# end

# function Q(cycloid::ICycloid)
#     E, R, Rᵣ, Nₗ, Nᵣ = cycloid.E, cycloid.R, cycloid.Rᵣ, cycloid.Nₗ, cycloid.Nᵣ
#     return E*Nₗ/(Nᵣ-Nₗ)
# end

# function T₀₁(ϕ::T where T<:Number)
#     return homtran(ϕ, zeros(1, 2))
# end

# function  T₁₂(cycloid::ICycloid, ϕ::T where T<:Number)
#     return homtran(ϕ*(cycloid.Nᵣ/cycloid.Nₗ), [cycloid.E, zero(T)])
# end

# function T₀₂(cycloid::ICycloid, ϕ::T where T<:Number)
#     return T₀₁(cycloid)*T₁₂(cycloid, ϕ)
# end

# function T₁₃(cycloid::ICycloid)
#     E, R, Rᵣ, Nₗ, Nᵣ = cycloid.E, cycloid.R, cycloid.Rᵣ, cycloid.Nₗ, cycloid.Nᵣ
#     ϕ₁₃ = ϕ*(cycloid.Nᵣ/cycloid.Nₗ)
#     return homtran(ϕ₁₃, [Q; 0])
# end

# function T₀₅(cycloid::ICycloid)
#     return [R; 0.0]
# end

# function P₀₁(cycloid::ICycloid)
# end

# function ψ(cycloid::ICycloid, ϕ::T)  where T<:Number
#     @unpack(cycloid)
#     Q = Q(cycloid)
#     return atan(y_tan, x_tan)
# end

function (cycloid::ICycloid)(t::T) where {T<:Number}
    return coolest_func(cycloid.E, cycloid.R, cycloid.Rᵣ, cycloid.Nₗ, cycloid.Nᵣ, t)
end

# Basic Cycloid Functionality =====================================================================
mutable struct Cycloid <: PCurve
    l1::T_l1 where T_l1<:Number                       # inner element radius
    l2::T_l2 where T_l2<:Number                       # outer element radius
    k::T_k where T_k<:Number                          # element relative rate
    θ::T_θ where T_θ<:Number                          # angle
    pos::T_pos where T_pos<:AbstractVector{<:Number}  # position
    inset::T_inset where T_inset<:Number
end

function _get_base_cycloid_edge(cycloid::Cycloid, t::T) where {T<:Number}
    inner_element = PCircle(cycloid.pos, cycloid.l1, cycloid.θ)
    outer_element = PCircle(inner_element(t), cycloid.l2, t + inner_element.θ)

    return outer_element(t * cycloid.k)
end

function (cycloid::Cycloid)(t::T) where {T<:Number}
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
ddt(x::T) where {T} = simplify(Symbolics.jacobian(x, [t_sym])[:])
dr⃗dt = simplify(ddt(r⃗))
const cycloid_symbolic_dr⃗dt = dr⃗dt

macro cycloid_d()
    return build_function(cycloid_symbolic_dr⃗dt, symbolic_cycloid_vars...)[1]
end

function cycloid_d(cycloid::Cycloid, t::T) where {T<:Number}
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

function cycloid_normal(cycloid::Cycloid, t::T) where {T<:Number}
    @cycloid_normal()(cycloid.l1, cycloid.l2, cycloid.k, cycloid.θ, cycloid.pos, cycloid.inset, t)
end

function estimate_t_end(cycloid::Cycloid)
    return min(2π / (cycloid.k + 1), 128π)
end

# function approximate(cycloid::Cycloid, steps::Integer = 2048)
#     cycloid_end = estimate_t_end(cycloid)

#     point_arr =  [Point2f(cycloid(t)) for t in LinRange(-cycloid_end, cycloid_end, steps)]

#     return [Line(point_arr[i], point_arr[i + 1]) for i in range(1, steps-1)]
# end

# # Intersect Detection List Generation =============================================================
# function generate_cycloid_list(cycloid::Cycloid)
#     list = []
#     # generate maximum point, and also absolute maximum so we don't go crazy
#     cycloid_end = min(2π / (cycloid.k + 1), 128π)

#     step = cycloid_end/2048

#     cur = 0.0

#     tolerance = cycloid.l1 + cycloid.l2 + cycloid.inset * 0.0001

#     while(cur < cycloid_end)
#         cur += step
#         potential.push!(cycloid(cur))
# end