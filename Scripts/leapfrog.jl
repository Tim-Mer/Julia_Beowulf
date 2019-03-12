using Plots
include("Real.jl")
include("Imag.jl")
N = 1000
x = collect(0:(1/(N-1)):1)
x_0 = fill(0.4, N)
C = fill(10.0, N)
sigma_squared = fill(1e-3, N)
k_0 = 500.0
Δ_x = 1e-3
Δ_t = 5e-8
ψ = C.*exp.((-(x-x_0).^2)./σ_sqrd).*exp.((k_0*x)*1im)
R_cur = real(ψ)
I_cur = imag(ψ)
V = fill(0.0, N)
for i = 600:N
   V[i] = -1e6
end
I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)

# Do the leapfrog
anim = @animate for time_step = 1:15000
   global R_cur, I_cur
   R_next = real_psi(N, R_cur, I_cur, Δ_t, Δ_x, V)
   R_cur = R_next
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
   prob_density = R_cur.^2+I_next.*I_cur
   I_cur = I_next
   plot(x, prob_density,
   title = "Reflection from cliff",
   xlabel = "x",
   ylabel = "Probability density",
   ylims = (0,200),
   legend = false
   )
end every 10

gif(anim, "./Figures/LeapFrog.gif", fps=30)
