include("../utils.jl")
include("../draw.jl")
using GLMakie

# Create the Axes =================================================================================

set_theme!(theme_black())
f = Figure(resolution=(1920, 1920))
top_left = GridLayout(f[1, 1])
inside = GridLayout(top_left[1, 1])
ax = Axis(f[1, 1])

ax.aspect = AxisAspect(1)

# Add Slider ======================================================================================

inset_slider = Slider(f[2, 1], range = -0.5:0.01:0.5, startvalue=0.0)

# Draw the Cycloid

inset = inset_slider.value
k = 5
eccentricity = 0.1
l2 = 1.0
edge = eccentricity + l2
edge = edge * 1.5
limits!(-edge, edge, -edge, edge)

θ = Observable(0.0)
pos = @lift(rotmat($θ)*[eccentricity, 0.0])

cyc = @lift(Cycloid(eccentricity, l2, -1 - 1/3, 0.0, $pos, $inset))

lines!(cyc)

function update()
    θ[] += 8π/250
    if θ[] >= 8π
        θ[] -= 8π
    end
end

while true
    sleep(0.005)
    update()
end