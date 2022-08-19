include("../utils.jl")
include("../draw.jl")
using GLMakie

# Create Figure ===================================================================================

set_theme!(theme_black())
f = Figure(resolution=(1920, 1920))

# Add Slider ======================================================================================

inset_slider = Slider(f[2, 1], range = -0.5:0.01:0.5, startvalue=0.0)
eccentricity_slider = Slider(f[3, 1], range= -0.5:0.01:0.5, startvalue=0.15)
rat_slider = Slider(f[4, 1], range = -10:1:10, startvalue=5)
step_slider = Slider(f[5, 1], range= -8π/100:8π/2000:8π/100, startvalue=0.15)

# Create the Cycloid ==============================================================================

inset = inset_slider.value
k = 5
eccentricity = eccentricity_slider.value
l2 = 1.0
edge = eccentricity[] + l2
edge = edge * 1.5
θ = Observable(0.0)
pos = @lift(rotmat($θ)*[$eccentricity, 0.0] + [l2, 0.0])
rat = rat_slider.value
rot = @lift(-$θ/($rat-1))

cyc = @lift(Cycloid($eccentricity, l2, -1 + 1/$rat, $rot, [0, 0], $inset))

circle = @lift(PCircle($pos, $inset, 0.0))

# Create the Axes =================================================================================

ax = Axis(f[1, 1])
ax.aspect = AxisAspect(1)
limits!(-edge, edge, -edge, edge)

# Draw the Cycloid ================================================================================

lines!(circle, color=:cyan)
lines!(cyc, color=:orange)

# Animate! ========================================================================================

animation_step = step_slider.value

function update()
    θ[] += animation_step[]
    if θ[] >= 8π
        θ[] -= 8π
    end
end

while true
    sleep(0.01)
    update()
end