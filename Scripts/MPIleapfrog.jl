using Plots
using MPI

function real_psi(N, R_current, I_current, delta_t, delta_x, V)
    R_next = fill(0.0, N)
    s = delta_t/(2*delta_x^2)
   for x in 2:N-1
      R_next[x] = R_current[x]-s*(I_current[x+1]-2*I_current[x]+I_current[x-1])+delta_t*V[x].*I_current[x]
      R_next[1] = R_next[2]
      R_next[N] = R_next[N-1]
   end
   return R_next
end

function imag_psi(N, I_current, R_current, delta_t, delta_x, V)
   I_next = fill(0.0, N)
   s = delta_t/(2*delta_x^2)
   for x in 2:N-1
      I_next[x] = I_current[x]+s*(R_current[x+1]-2*R_current[x]+R_current[x-1])-delta_t*V[x].*R_current[x];
      I_next[1] = I_next[2]
      I_next[N] = I_next[N-1]
   end
   return I_next
end

function leapfrog(comm)
   rank = MPI.Comm_rank(comm)
   ENV["PLOTS_TEST"] = "true"
   ENV["GKSwstype"] = "100"
   N = 1000
   x = collect(0:(1/(N-1)):1)
   x_0 = fill(0.4, N)
   C = fill(10.0, N)
   σ_sqrd = fill(1e-3, N)
   k_0 = 500.0
   Δ_x = 1e-3
   Δ_t = 5e-8
   ψ = C.*exp.((-(x-x_0).^2)./σ_sqrd).*exp.((k_0*x)*1im)
   R_cur = real(ψ)
   I_cur = imag(ψ)
   V = fill(0.0, N)
   for i = 600:650
      V[i] = (42000*rank)
   end
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)

   # Do the leapfrog
   anim = @animate for time_step = 1:20000
      global R_cur, I_cur
      R_next = real_psi(N, R_cur, I_cur, Δ_t, Δ_x, V)
      R_cur = R_next
      I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
      prob_density = R_cur.^2+I_next.*I_cur
      I_cur = I_next
      plot(x, prob_density,
         title = "Wave packet against $(convert(Int64, V[600])) high wall",
         xlabel = "x",
         ylabel = "Probability density",
         ylims = (0,200),
         legend = false,
         show = false
         )
      plot!(x,abs.(V))
   end every 20
   gif(anim, "./Figures/ParallelTest/MPILeapFrog_$(convert(Int64, V[600]))_barrier.gif", fps=30)
end

MPI.Init()
comm = MPI.COMM_WORLD

@time leapfrog(comm)

MPI.Finalize()
