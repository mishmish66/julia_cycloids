include("cycloid.jl")

struct DoubleDrive
    stage_1::Cycloid
    stage_2::Cycloid
end