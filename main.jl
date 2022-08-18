include("./src/draw.jl")

θ = Observable(0.0)
inset = Observable(0.1)

cyc = @lift(Cycloid(0.2, 1.0, -1 - 1/3, $θ, [0.0; 0.0], $inset))
# cyc = Cycloid(0.1, 1.0, -1.2, θ, [0.0; 0.0], 0.2)

set_theme!(theme_black())
f = Figure(resolution=(1920, 1920))
lim_rad = cyc[].l1 + cyc[].l2   
lims = (-lim_rad, lim_rad, -lim_rad, lim_rad) .* 1.25
ax = Axis(f[1, 1])

limits!(lims...)

draw_cycloid(cyc)

function do_thing(t)
    norm = cycloid_normal(cyc[], t) .* 0.1
    return cyc[](t) + norm
end

θ_it = LinRange(0, 2π, 512)
# record(f, "what_even.mp4", θ_it, framerate = 60) do θ_i
#     θ[] = θ_i
# end

while (true)
    sleep(0.025)
    θ[] += 2π / 480
end