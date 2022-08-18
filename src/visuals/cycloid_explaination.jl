using GLMakie
include("../curves/pcircle.jl")
include("utils.jl")

θ = Observable(0.0)

r0 = 1
r1 = 0.1

c0 = AngledCircle([0; 0], r0, 0)

factor = Observable(4);

r⃗1 = @lift(c0($θ))
c1 = @lift(AngledCircle($r⃗1, r1, $θ * $factor))
tip = @lift($c1(0))

range = [θ for θ in LinRange(0, 8π, 2^13)]

lim_rad = r0 + r1
lims = (-lim_rad, lim_rad, -lim_rad, lim_rad) .* 1.25
set_theme!(theme_black())
f = Figure(resolution=(1920, 1920))
ax = Axis(f[1, 1])

limits!(lims...)

c = to_color(:orange)

traj = Observable([])

tail = 40

tailcol = @lift([RGBAf(c.r, c.g, c.b, (i / length($traj))^2) for i in 1:length($traj)])
x = @lift(((datum::Vector{Float64}) -> datum[1]).($traj))
y = @lift(((datum::Vector{Float64}) -> datum[2]).($tra))
lines!(ax, x, y; linewidth=3, color=tailcol)

i = 0
looplen = 2^13
loop = 8π
while true
    θ[] = loop / looplen * i
    if i >= looplen
        i = 0
    end
    if size(traj[])[1] >= tail
        pop!(traj[])
    end
    pushfirst!(traj[], tip[])
    sleep(0.01)
    lines!(ax, x, y; linewidth=3, color=tailcol)
    i += 1
end