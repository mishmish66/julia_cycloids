### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 5675938a-2f8e-11ed-1102-23fbe193abd6
using Symbolics

# ╔═╡ d8b32fab-a25c-42ab-8e2b-cc94ae19abf6
using PlutoUI

# ╔═╡ 66f358fc-ddd5-41c6-90de-a6287528c852
using BenchmarkTools

# ╔═╡ c395a5a2-58ba-4f88-b9fb-b59d6f2c1e8b
@variables E R Rᵣ Nₗ Nᵣ ϕ

# ╔═╡ 71b6b3c1-6fb1-4848-a36b-c799c2d91eec
@variables Q V₂₃ mᵥ ψ ω_I ω_C V_IC ϕ_I

# ╔═╡ 481338d3-b3d9-4c94-89ad-79af66991067
# ω₂ should be ω_I, ω₃ should be ω_C
# 2 = I
# 3 = C

# ╔═╡ fe49df3c-f5fb-4ca8-bbdf-48d89e1b524e
eq₁ = V_IC~E*ω_I~-(Q-E)*ω_C

# ╔═╡ 1855071f-8eb3-4644-9ffb-e75c04de10c0
eq₂ = mᵥ~ω_C/ω_I~(Nₗ-Nᵣ)/Nₗ # Adapted from equation 2 in On the lobe proﬁle design in a cycloid reducer using instant velocity center 

# ╔═╡ 04dd010c-0cbe-43a6-9e8f-a5c061870bd1
eq₂_s_ω_C = ω_C~ω_I*(Nₗ-Nᵣ)/Nₗ

# ╔═╡ bb1e9461-d4d1-4f19-9d8f-028960c94525
eq₃_1 = substitute(eq₁.rhs, Dict(eq₂_s_ω_C.lhs => eq₂_s_ω_C.rhs))

# ╔═╡ b0858596-9023-45c8-99e1-34bce3488307
eq₃_2 = simplify(eq₃_1.lhs/ω_I ~ eq₃_1.rhs/ω_I)

# ╔═╡ 5955f412-6c96-4bc6-8f20-65331cad47ea
eq₃_3 = eq₃_2.lhs*Nₗ ~ expand(eq₃_2.rhs*Nₗ)

# ╔═╡ 6a06b879-41e9-4ff4-b312-26e3b03b49af
eq₃_4 = eq₃_3.lhs-(E*Nₗ - E*Nᵣ) ~ eq₃_3.rhs-(E*Nₗ - E*Nᵣ)

# ╔═╡ 603a7182-fe97-409b-af04-6d7fc99940df
eq₃ = simplify(eq₃_4.rhs/(Nᵣ-Nₗ) ~ eq₃_4.lhs/(Nᵣ-Nₗ))

# ╔═╡ cd55e7d6-a291-46e1-bf4e-99885c00f4bb
eq₄_1 = ψ ~ tan(Q*sin(ϕ)/(R-Q*cos(ϕ)))

# ╔═╡ 63673dce-1948-4e0d-91df-33f4e2b73546
eq₄_2 = ψ ~ tan(sin(ϕ)/(R/Q-cos(ϕ)))

# ╔═╡ 65515c25-4ba4-4121-b3d2-88fc04f48018
eq₄ = substitute(eq₄_2, Dict(eq₃.lhs => eq₃.rhs))

# ╔═╡ 08003a33-bc07-4b3a-a427-7a29cf1990d4
mᵥ ~ (Nₗ-Nᵣ)/Nₗ

# ╔═╡ cae4d88e-7a77-4644-8cfd-d831d528f21d
mᵥ-1 ~ (Nₗ-Nᵣ)/Nₗ - 1

# ╔═╡ 09b84e94-0828-4f60-a5ec-1d35f74b83cf
mᵥ-1 ~ -Nᵣ/Nₗ

# ╔═╡ 03ee7ec0-9796-4602-b44c-040937996ca1
P₁ = Q*[cos(ϕ); sin(ϕ)]

# ╔═╡ c1001a53-d73e-4439-8e10-3ab451edc4bb
T_GI = [cos(ϕ_I) -sin(ϕ_I) 0.0; sin(ϕ_I) cos(ϕ_I) 0.0; 0.0 0.0 1.0]

# ╔═╡ c5157af6-aa91-4889-afdd-894a9600db51
k = (Nₗ - Nᵣ)/Nₗ

# ╔═╡ 7815a798-fefa-4e19-8f74-e001261dc62c
ϕ_C = k*ϕ_I

# ╔═╡ 23ccf7fa-62c2-494e-be90-ad3049d494ec
ϕ_IC = simplify(ϕ_C-ϕ_I)

# ╔═╡ c2888906-41c9-4a07-9512-70b9366538d9
begin
	T_GC = zeros(Num, 3, 3)
	T_GC[3, 3] = 1
	C⃗_I = [E; 0; 1]
	T_GC[1:3, 3] = T_GI*C⃗_I
	T_GC[1:2, 1:2] = [cos(ϕ_C) -sin(ϕ_C); sin(ϕ_C) cos(ϕ_C)]
	T_GC
end

# ╔═╡ 903130ee-4540-4425-8b2b-a05a68acdd37
T_GC[1:3, 3]

# ╔═╡ 4aefb83b-a854-4c4f-874c-3e4e2f1d878c
begin
	T_CG = zeros(Num, 3, 3)
	T_CG[3, 3] = 1
	rot_CG = T_GC[1:2, 1:2]'
	C⃗_G = -rot_CG*T_GC[1:2, 3]
	T_CG[1:2, 1:2] = rot_CG
	T_CG[1:2, 3] = C⃗_G
	T_CG
end

# ╔═╡ 2a2ba11f-4a6b-4289-8859-0412e0b6c00a
Q⃗_I = [E*Nᵣ/(Nᵣ-Nₗ); 0]#[Q; 0; 1]

# ╔═╡ d35686b1-a552-4239-a14b-e43576aea5ef
begin
	T_GR = zeros(Num, 3,3)
	T_GR[3, 3] = 1
	T_GR[1, 1] = 1
	T_GR[2, 2] = 1
	PR⃗_G = [R; 0; 1]
	T_GR[1:3, 3] = PR⃗_G
	T_GR
end

# ╔═╡ 2c565cc4-5163-41a7-a45e-ca78574c56a0
begin
	T_RG = zeros(Num, 3, 3)
	T_RG[3, 3] = 1
	rot_RG = T_GR[1:2, 1:2]'
	R⃗_G_2 = -rot_RG*T_GR[1:2, 3]
	T_RG[1:2, 1:2] = rot_RG
	T_RG[1:2, 3] = R⃗_G_2
	T_RG
end

# ╔═╡ 5150a785-59b2-4692-bd72-444f7989d668
T_CR = T_CG*T_GR

# ╔═╡ 539d981d-d3ac-491f-8e08-39e61b572675
ψ_act = atan(sin(ϕ_I)/(R*(Nᵣ-Nₗ)/(E*Nᵣ)-cos(ϕ_I)))

# ╔═╡ 3aabce87-2cf1-4fa6-9b71-e91786407ec9
ψ⃗ = 

# ╔═╡ 3676e62f-a09b-4c4c-a0e5-564576980ef4
Q⃗_G = (T_GI*[Q⃗_I; 0.0])[1:2]

# ╔═╡ 0d9753ca-330c-430e-b97d-843e7dc11272
Q⃗_R = simplify((T_RG*[Q⃗_G; 1.0])[1:2])

# ╔═╡ 1dbc5858-630c-49e6-8c23-a3043d4c205f
sqmag_Q⃗_r = simplify(Q⃗_R'*Q⃗_R)

# ╔═╡ c7f61dba-17d6-4685-8a52-9d15229b553f
mag_Q⃗_R = simplify(sqrt(Q⃗_R'*Q⃗_R))

# ╔═╡ 9d2c0177-75ff-4edd-8ebd-b05055253ee4
Q̂_R = Q⃗_R/mag_Q⃗_R

# ╔═╡ fe1747b0-bdc8-4016-9e7f-79ea65cb8508
PV⃗_R = [Rᵣ*Q̂_R; 1.0] #[Rᵣ*[-cos(ψ_act), sin(ψ_act)]; 1.0]

# ╔═╡ 0ac8ca2e-1cf8-49f3-9690-ed5f2aa36d88
sin_ψ = 

# ╔═╡ 9826601a-8130-4f32-ac4d-3f561f927095
PV⃗_C = simplify(T_CR*PV⃗_R)

# ╔═╡ 0a563f06-ec4e-4292-9ad6-56894addeeea
build_function(PV⃗_C, [E R Rᵣ Nₗ Nᵣ ϕ_I]...)

# ╔═╡ 636591d5-62a0-497c-9edc-17e252f3dd60
PV⃗_C

# ╔═╡ 04525774-4063-4f1e-a467-8d35e84342ec
function hand_func(E, R, Rᵣ, Nₗ, Nᵣ, ϕ)
	Nₗ_min_Nᵣ = (Nₗ - Nᵣ)
	K_loc = Nₗ_min_Nᵣ/Nₗ
	Kϕ = ϕ*K_loc

	sin_ϕ = sin(ϕ)
	cos_ϕ = cos(ϕ)

	Nᵣ_min_Nₗ = -Nₗ_min_Nᵣ
	Q_loc = E*Nᵣ/Nᵣ_min_Nₗ
	Q_sin_ϕ = Q_loc*sin_ϕ
	Q_cos_ϕ = Q_loc*cos_ϕ
	
	Q_cos_ϕ_min_R = Q_cos_ϕ - R
	Q_cos_ϕ_min_R_allsq = Q_cos_ϕ_min_R*Q_cos_ϕ_min_R
	Nᵣ_pl_Nₗ = Nᵣ + Nₗ
	A_sq = Q_cos_ϕ_min_R_allsq*Nᵣ_pl_Nₗ*Nᵣ_pl_Nₗ + sin_ϕ*sin_ϕ*Nᵣ*Nᵣ*E*E
	A = sqrt(A_sq)

	sin_Kϕ = sin(Kϕ)
	cos_Kϕ = cos(Kϕ)

	Rᵣ_Q_sin_ϕ = Rᵣ*Q_sin_ϕ

	B = Rᵣ*Q_cos_ϕ_min_R*cos_Kϕ + Rᵣ_Q_sin_ϕ*sin_Kϕ
	C = -Rᵣ*Q_cos_ϕ_min_R*sin_Kϕ + Rᵣ_Q_sin_ϕ*cos_Kϕ

	R_min_E_cos_ϕ = R-E*cos_ϕ
	E_sin_ϕ = E*sin_ϕ

	D = R-E*cos_ϕ*cos_Kϕ-E_sin_ϕ*sin_Kϕ
	E = -R_min_E_cos_ϕ*sin_Kϕ-E_sin_ϕ*cos_Kϕ

	return [B/A+D; C/A+E]
end

# ╔═╡ c596ceb3-4349-454c-9b43-b279765e24c2
func = eval(build_function(PV⃗_C, [E R Rᵣ Nₗ Nᵣ ϕ_I]...)[1])

# ╔═╡ 4f5302af-5477-412f-9778-3c5a356aaf6b
coolest_func = func

# ╔═╡ 3d366731-b779-40b8-be41-2173ba979cd6
func(rand(), rand(), rand(), rand(), rand(), 0.0)

# ╔═╡ d66199eb-bc1b-4e9a-8c5e-674928fbfaae
@benchmark eval(func)(rand(), rand(), rand(), rand(), rand(), rand())

# ╔═╡ 396eeb75-bdb6-4588-8ed6-c2f082c2f4a2
@benchmark eval(hand_func)(rand(), rand(), rand(), rand(), rand(), rand())

# ╔═╡ 82ef3842-6eef-44f6-9393-83d3f258a8eb
E⃗_G = E*[cos(ϕ_I); sin(ϕ_I)]

# ╔═╡ 356d7c32-d03c-4d1c-8fcd-fb5bb32d704f
R⃗_G = [R; 0.0]

# ╔═╡ a94bb12e-22ba-4571-8b94-44628cc210a3
function norm(vec::T) where T <: Vector
	return sqrt(vec'*vec)
end

# ╔═╡ dbc83763-e75d-41b8-a33a-98d7e62912e4
fᵢ = simplify(norm(E⃗_G - R⃗_G)/norm(Q⃗_G-R⃗_G) * (R - Q*cos(ϕ_I)))

# ╔═╡ e9dbc3e8-71dc-4e09-b579-77181ddeecbd
F_I = 

# ╔═╡ 20938838-c797-4778-87d7-1422b15685bc
E⃗_G - R⃗_G

# ╔═╡ 5718ca9e-be07-4661-b746-eb62e1cef272
Q⃗_G

# ╔═╡ 0626fc31-7641-44bf-aae4-67bf42ad0ba1
R⃗_G

# ╔═╡ be13eef6-9c8f-486a-8ba4-45982ed597ee
N_L1, N_R1, N_L2, N_R2 = 6, 5, 5, 4

# ╔═╡ 283220b2-3fcb-42cf-8d06-0112a9a2dd2d
((N_L1 - N_R1)/N_L1 - (N_L2 - N_R2)/N_L2)/(1-(N_L1 - N_R1)/N_L1)

# ╔═╡ e5b562cc-3aea-4bd5-96e2-7894840705b1
1/25

# ╔═╡ abec3418-e7e6-4252-a562-8b8f09fb03e3
@variables N_l1, N_r1, N_l2, N_r2

# ╔═╡ c6f062e6-ea42-4b43-9fe8-3e55c7220ca3
ex = simplify(((N_l1 - N_r1)/N_l1 - (N_l2 - N_r2)/N_l2)/(1-(N_l1 - N_r1)/N_l1))

# ╔═╡ 0d624b39-62bc-46b3-886a-5d640ed5f360
N_L1*N_R2/N_L2/N_R1 - 1

# ╔═╡ 2c01b64a-4869-4b89-9757-d776ff4955e7
eq = 15*N_l1*N_r2 - 15*N_r1*N_l2 ~ -N_r1*N_l2

# ╔═╡ f37ac48e-f1c2-4265-b5a0-0c6488ce6fb1
N_l1 ~ Symbolics.solve_for(eq, N_l1)

# ╔═╡ a4958219-caed-4392-ba42-859a87fe7e82
zeros(Int, 20, 20, 20, 20)

# ╔═╡ 08870453-0865-43b6-b6e4-e7eeb36bd825
print(build_function(PV⃗_C, [E R Rᵣ Nₗ Nᵣ ϕ_I]...; target = Symbolics.CTarget()))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"

[compat]
BenchmarkTools = "~1.3.1"
PlutoUI = "~0.7.40"
Symbolics = "~4.10.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.AbstractAlgebra]]
deps = ["GroupsCore", "InteractiveUtils", "LinearAlgebra", "MacroTools", "Markdown", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "ba2beb5f2a3170a0ef87953daefd97135cf46ecd"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.27.4"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "5c0b629df8a5566a06f5fef5100b53ea56e465a0"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.2"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["ArrayInterfaceCore", "Compat", "IfElse", "LinearAlgebra", "Static"]
git-tree-sha1 = "d6173480145eb632d6571c148d94b9d3d773820e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "6.0.23"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "5bb0f8292405a516880a3809954cb832ae7a31c5"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.20"

[[deps.ArrayInterfaceStaticArrays]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceStaticArraysCore", "LinearAlgebra", "Static", "StaticArrays"]
git-tree-sha1 = "efb000a9f643f018d5154e56814e338b5746c560"
uuid = "b0d46f97-bff5-4637-a19a-dd75974142cd"
version = "0.1.4"

[[deps.ArrayInterfaceStaticArraysCore]]
deps = ["Adapt", "ArrayInterfaceCore", "LinearAlgebra", "StaticArraysCore"]
git-tree-sha1 = "a1e2cf6ced6505cbad2490532388683f1e88c3ed"
uuid = "dd5226c6-a4d4-4bc7-8575-46859f9c95b9"
version = "0.1.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "b15a6bc52594f5e4a3b825858d1089618871bf9d"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.36"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bijections]]
git-tree-sha1 = "fe4f8c5ee7f76f2198d5c2a06d3961c249cce7bd"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.4"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "8a494fe0c4ae21047f28eb48ac968f0b8a6fcaa7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.4"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "332a332c97c7071600984b3c31d9067e1a4e6e25"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "78bee250c6826e1cf805a88b7f1e86025275d208"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.46.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "992a23afdb109d0d2f8802a30cf5ae4b1fe7ea68"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "8579b5cdae93e55c0cff50fbb0c2d1220efd5beb"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.70"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "dc45fbbe91d6d17a8e187abad39fb45963d97388"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.13"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "d0fa82f39c2a5cdb3ee385ad52bc05c42cb4b9f0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.5"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "87519eb762f85534445f5cda35be12e32759ee14"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.4"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "187198a4ed8ccd7b5d99c41b69c679269ea2b2d4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.32"

[[deps.FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "a5e6e7f12607e90d71b09e6ce2c965e41b337968"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.1"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.Groebner]]
deps = ["AbstractAlgebra", "Combinatorics", "Logging", "MultivariatePolynomials", "Primes", "Random"]
git-tree-sha1 = "144cd8158cce5b36614b9c95b8afab6911bd469b"
uuid = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
version = "0.2.10"

[[deps.GroupsCore]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9e1a5e9f3b81ad6a5c613d181664a0efc6fe6dd7"
uuid = "d5909c97-4eac-4ecc-a3dc-fdd0858a4120"
version = "0.4.0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "f366daebdfb079fd1fe4e3d560f99a0c892e15bc"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "076bb0da51a8c8d1229936a1af7bdfacd65037e1"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.2"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LabelledArrays]]
deps = ["ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "3926535a04c12fb986028a4a86bf5a0a3cf88b91"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.12.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "1a43be956d433b5d0321197150c2f94e16c0aaa0"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.16"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Metatheory]]
deps = ["AutoHashEquals", "DataStructures", "Dates", "DocStringExtensions", "Parameters", "Reexport", "TermInterface", "ThreadsX", "TimerOutputs"]
git-tree-sha1 = "a160e323d3684889e6026914576f1f4288de131d"
uuid = "e9d8d322-4543-424a-9be4-0cc815abe26c"
version = "1.3.4"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "6bb7786e4f24d44b4e29df03c69add1b63d88f01"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "393fc4d82a73c6fe0e2963dd7c882b09257be537"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.6"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4e675d6e9ec02061800d6cfb695812becbd03cdf"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.4"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ForwardDiff", "ReverseDiff"]
git-tree-sha1 = "ebe90ecfb31f1781a6da31a986036896e5847fb8"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "311a2aa90a64076ea0fac2ad7492e914e6feeb81"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "3c009334f45dfd546a16a57960a821a1a023d241"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.5.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "062986376ce6d394b23d5d90f01d81426113a3c9"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArraysCore", "ChainRulesCore", "DocStringExtensions", "FillArrays", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "Tables", "ZygoteRules"]
git-tree-sha1 = "3004608dc42101a944e44c1c68b599fa7c669080"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.32.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ReverseDiff]]
deps = ["ChainRulesCore", "DiffResults", "DiffRules", "ForwardDiff", "FunctionWrappers", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "Random", "SpecialFunctions", "StaticArrays", "Statistics"]
git-tree-sha1 = "b8e2eb3d8e1530acb73d8949eab3cedb1d43f840"
uuid = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
version = "1.14.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SciMLBase]]
deps = ["ArrayInterfaceCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "RecipesBase", "RecursiveArrayTools", "StaticArraysCore", "Statistics", "Tables"]
git-tree-sha1 = "0d8622edebac09e7bf93460cbad4602d5c9b3be9"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.54.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "39c9f91521de844bad65049efd4f9223e7ed43f9"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.14"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "f94f9d627ba3f91e41a815b9f9f977d729e2e06f"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.7.6"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "dfec37b90740e3b9aa5dc2613892a3fc155c3b42"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.6"

[[deps.StaticArraysCore]]
git-tree-sha1 = "ec2bd695e905a3c755b33026954b119ea17f2d22"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.3.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "Metatheory", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "027b43d312f6d52187bb16c2d4f0588ddb8c4bb2"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.19.11"

[[deps.Symbolics]]
deps = ["ArrayInterfaceCore", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "Groebner", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Markdown", "Metatheory", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TermInterface", "TreeViews"]
git-tree-sha1 = "873596ee5c98f913bcb2cbb2dc779d815c5aeb86"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "4.10.4"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadsX]]
deps = ["ArgCheck", "BangBang", "ConstructionBase", "InitialValues", "MicroCollections", "Referenceables", "Setfield", "SplittablesBase", "Transducers"]
git-tree-sha1 = "d223de97c948636a4f34d1f84d92fd7602dc555b"
uuid = "ac1d9e8a-700a-412c-b207-f0111f4b6c0d"
version = "0.1.10"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "9dfcb767e17b0849d6aaf85997c98a5aea292513"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.21"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "c76399a3bbe6f5a88faa33c8f8a65aa631d95013"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.73"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─5675938a-2f8e-11ed-1102-23fbe193abd6
# ╟─d8b32fab-a25c-42ab-8e2b-cc94ae19abf6
# ╠═66f358fc-ddd5-41c6-90de-a6287528c852
# ╠═c395a5a2-58ba-4f88-b9fb-b59d6f2c1e8b
# ╠═71b6b3c1-6fb1-4848-a36b-c799c2d91eec
# ╠═481338d3-b3d9-4c94-89ad-79af66991067
# ╠═fe49df3c-f5fb-4ca8-bbdf-48d89e1b524e
# ╠═1855071f-8eb3-4644-9ffb-e75c04de10c0
# ╠═04dd010c-0cbe-43a6-9e8f-a5c061870bd1
# ╟─bb1e9461-d4d1-4f19-9d8f-028960c94525
# ╠═b0858596-9023-45c8-99e1-34bce3488307
# ╟─5955f412-6c96-4bc6-8f20-65331cad47ea
# ╟─6a06b879-41e9-4ff4-b312-26e3b03b49af
# ╠═603a7182-fe97-409b-af04-6d7fc99940df
# ╟─cd55e7d6-a291-46e1-bf4e-99885c00f4bb
# ╟─63673dce-1948-4e0d-91df-33f4e2b73546
# ╠═65515c25-4ba4-4121-b3d2-88fc04f48018
# ╟─08003a33-bc07-4b3a-a427-7a29cf1990d4
# ╟─cae4d88e-7a77-4644-8cfd-d831d528f21d
# ╟─09b84e94-0828-4f60-a5ec-1d35f74b83cf
# ╠═03ee7ec0-9796-4602-b44c-040937996ca1
# ╠═c1001a53-d73e-4439-8e10-3ab451edc4bb
# ╠═c5157af6-aa91-4889-afdd-894a9600db51
# ╠═7815a798-fefa-4e19-8f74-e001261dc62c
# ╠═23ccf7fa-62c2-494e-be90-ad3049d494ec
# ╠═c2888906-41c9-4a07-9512-70b9366538d9
# ╠═903130ee-4540-4425-8b2b-a05a68acdd37
# ╠═4aefb83b-a854-4c4f-874c-3e4e2f1d878c
# ╠═2a2ba11f-4a6b-4289-8859-0412e0b6c00a
# ╠═d35686b1-a552-4239-a14b-e43576aea5ef
# ╠═2c565cc4-5163-41a7-a45e-ca78574c56a0
# ╠═5150a785-59b2-4692-bd72-444f7989d668
# ╠═539d981d-d3ac-491f-8e08-39e61b572675
# ╠═3aabce87-2cf1-4fa6-9b71-e91786407ec9
# ╠═3676e62f-a09b-4c4c-a0e5-564576980ef4
# ╠═0d9753ca-330c-430e-b97d-843e7dc11272
# ╠═1dbc5858-630c-49e6-8c23-a3043d4c205f
# ╠═c7f61dba-17d6-4685-8a52-9d15229b553f
# ╠═9d2c0177-75ff-4edd-8ebd-b05055253ee4
# ╠═fe1747b0-bdc8-4016-9e7f-79ea65cb8508
# ╠═0ac8ca2e-1cf8-49f3-9690-ed5f2aa36d88
# ╠═9826601a-8130-4f32-ac4d-3f561f927095
# ╠═0a563f06-ec4e-4292-9ad6-56894addeeea
# ╠═636591d5-62a0-497c-9edc-17e252f3dd60
# ╠═04525774-4063-4f1e-a467-8d35e84342ec
# ╠═c596ceb3-4349-454c-9b43-b279765e24c2
# ╠═4f5302af-5477-412f-9778-3c5a356aaf6b
# ╠═3d366731-b779-40b8-be41-2173ba979cd6
# ╠═d66199eb-bc1b-4e9a-8c5e-674928fbfaae
# ╠═396eeb75-bdb6-4588-8ed6-c2f082c2f4a2
# ╠═82ef3842-6eef-44f6-9393-83d3f258a8eb
# ╠═356d7c32-d03c-4d1c-8fcd-fb5bb32d704f
# ╠═a94bb12e-22ba-4571-8b94-44628cc210a3
# ╠═dbc83763-e75d-41b8-a33a-98d7e62912e4
# ╠═e9dbc3e8-71dc-4e09-b579-77181ddeecbd
# ╠═20938838-c797-4778-87d7-1422b15685bc
# ╠═5718ca9e-be07-4661-b746-eb62e1cef272
# ╠═0626fc31-7641-44bf-aae4-67bf42ad0ba1
# ╠═be13eef6-9c8f-486a-8ba4-45982ed597ee
# ╠═283220b2-3fcb-42cf-8d06-0112a9a2dd2d
# ╠═e5b562cc-3aea-4bd5-96e2-7894840705b1
# ╠═abec3418-e7e6-4252-a562-8b8f09fb03e3
# ╠═c6f062e6-ea42-4b43-9fe8-3e55c7220ca3
# ╠═0d624b39-62bc-46b3-886a-5d640ed5f360
# ╠═2c01b64a-4869-4b89-9757-d776ff4955e7
# ╠═f37ac48e-f1c2-4265-b5a0-0c6488ce6fb1
# ╠═a4958219-caed-4392-ba42-859a87fe7e82
# ╠═08870453-0865-43b6-b6e4-e7eeb36bd825
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
