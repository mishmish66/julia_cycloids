include("../utils.jl")
include("../draw.jl")
using GLMakie

# General Stuff Declaration =======================================================================

set_theme!(theme_black())
f = Figure(resolution=(1920, 1920))
top_left = GridLayout(f[1, 1])
inside = GridLayout(top_left[1, 1])

θ = Observable(0.0)

stepval = 8π/(2^14)

step_slider = Slider(inside[1, 1], range = -stepval*20:stepval/4:stepval*20, startvalue=stepval)
step = step_slider.value

k_sldr = Slider(inside[2, 1], range = -10:1:10, startvalue = 5)
k = k_sldr.value

r_1_sldr = Slider(inside[3,1], range = 0:0.025:1, startvalue = 0.15)
r_1 = r_1_sldr.value

r_2_sldr = Slider(inside[4, 1], range = 0:0.025:2, startvalue=1.0)
r_2 = r_2_sldr.value

θ_1 = @lift($θ * $k)
θ_2 = θ

r⃗_0 = [0, 0]
r⃗_1 = @lift(rotmat($θ_1)*Point2f($r_1, 0))
r⃗_2 = @lift(rotmat($θ_2)*Point2f($r_2, 0))

tip = @lift($r⃗_1 + $r⃗_2)

l1 = @lift(Line(r⃗_0, r⃗_0 + $r⃗_1))
l2 = @lift(Line($r⃗_1, $r⃗_1 + $r⃗_2))

lim_rad = r_1[] + r_2[]
lims = (-lim_rad, lim_rad, -lim_rad, lim_rad) .* 1.25

colsize!(f.layout, 1, Relative(3/8))
rowsize!(f.layout, 1, Relative(5/8))

# Lines Figure ====================================================================================

lower_group = GridLayout(f[2, 1:2])

lower_ax1 = Axis(lower_group[1, 1])

lines!(l1, color=:salmon)

lower_ax2 = Axis(lower_group[1, 2])

l_0_2 = @lift(Line(r⃗_0, $r⃗_2))

lines!(l_0_2, color=:violet)

colsize!(lower_group, 1, Relative(1/2))
colsize!(lower_group, 2, Relative(1/2))

limits!(lower_ax1, lims...)
limits!(lower_ax2, lims...)

lower_ax1.aspect = AxisAspect(1)
lower_ax2.aspect = AxisAspect(1)

# Cycloid Figure ==================================================================================

top_right = GridLayout(f[1, 2])
ax = Axis(top_right[1, 1])

limits!(lims...)

c = to_color(:orange)

traj = [r⃗_2[]]

tail = 2^11

function createColorTraj(arr)
    len = length(arr)
    return [RGBAf(c.r, c.g, c.b, (i / len)^2) for i in 1:len]
end

xdata = Observable([traj[1][1]])
ydata = Observable([traj[1][2]])

colorTraj = Observable(createColorTraj(traj))

function points_update()
    points = reduce(hcat, traj)
    # println("POINTS")
    # println(points)
    # println("POINTED")
    colorTraj[] = createColorTraj(traj)
    xdata.val = points[1, :]
    ydata[] = points[2, :]
end

lines!(xdata, ydata, color=colorTraj)

lines!(l1, color=:salmon)
lines!(l2, color=:violet)

top_left = GridLayout(f[1, 1])
# Animate! ========================================================================================

while true
    if θ[] >= 8π
        θ[] -= 8π
    end
    if length(traj) >= tail
        popfirst!(traj)
    end
    push!(traj, l2[](1))
    points_update()
    sleep(0.001)
    θ[] = θ[] += step[]
end

println("gutter")