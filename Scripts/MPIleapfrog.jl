using Plots
using MPI
using Statistics

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

function leapfrog(comm, shared)
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
      V[i] = 1e5#(exp.(rank/1.6))
   end
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
   before = fill(0.0, 400)
   after = before
   # Do the leapfrog
   anim = @animate for time_step = 1:20000
      before = fill(0.0, 400)
      after = before
      R_next = real_psi(N, R_cur, I_cur, Δ_t, Δ_x, V)
      R_cur = R_next
      I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
      prob_density = R_cur.^2+I_next.*I_cur
      I_cur = I_next
      if time_step == 1
         before = filter(!isnan, prob_density[200:585])
      end
      if time_step == 19999
         after = filter(!isnan, prob_density[665:1000])
      end
      plot(x, prob_density,
         title = "Wave packet against $(convert(Int64, round(V[600]))) high wall",
         xlabel = "x",
         ylabel = "Probability density",
         ylims = (0,200),
         legend = false,
         show = false
         )
      plot!(x,abs.(V))
   end every 20
   percentage = round(100*(1-((mean(before)-mean(after))/mean(before))); digits=2)
   gif(anim, "./Figures/ParallelTest/MPILeapFrog_$(convert(Int64, round(V[600])))_barrier_$(percentage).gif", fps=30)
   MPI.Win_lock(MPI.LOCK_EXCLUSIVE, 0, 0, win)
   MPI.Put([Float64(percentage)], 1, 0, MPI.Comm_rank(comm), win)
   MPI.Win_unlock(0, win)
   MPI.Barrier(comm)
end

MPI.Init()
comm = MPI.COMM_WORLD
shared = zeros(MPI.Comm_size(comm))
win = MPI.Win()
MPI.Win_create(shared, MPI.INFO_NULL, comm, win)
MPI.Barrier(comm)

@time leapfrog(comm, win)

open("./Files/MPIresults.txt") do fo
   for i = 1:MPI.Comm_size(comm)
      height = (exp.((i-1)/1.6))
      write(fo, "Simulation $i Wall height: $height Percentage: $(shared[i])\n")
   end
end

MPI.Finalize()
