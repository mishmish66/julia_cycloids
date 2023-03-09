function hand_func(E, R, Rᵣ, Nₗ, Nᵣ, ϕ)
	Nₗ_min_Nᵣ = (Nₗ - Nᵣ)
	K_loc = Nₗ_min_Nᵣ/Nₗ
	Kϕ = ϕ*Nₗ_min_Nᵣ/Nₗ

	sin_ϕ = sin(ϕ)
	cos_ϕ = cos(ϕ)

	Nᵣ_min_Nₗ = -Nₗ_min_Nᵣ
	Q_loc = E*Nᵣ/(-Nₗ_min_Nᵣ)
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