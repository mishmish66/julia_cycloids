include("cycloid.jl")

struct Drive
    cycloid::Cycloid
    pinwheel_r::float
    pin_r::Float
    pin_count::Int
    θ::Float
    ϕ::Float
end

function draw_pins(drive::Drive)
    pinwheel = Circle(drive.cycloid.pos, drive.pinwheel_r)
    pin_positions = pinwheel.(LinRange(0.0, 2π, pin_count))

    draw_pin = pin_pos -> draw_circle(Circle(pin_pos, drive.pin_r))

    draw_circle.(pin_positions)
end

function draw_drive(drive::Drive) end
