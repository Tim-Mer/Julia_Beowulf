using Plots
using Statistics
include("Real.jl")
include("Imag.jl")
#function leapfrog()
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
   for i = 600:N
      V[i] = 1e5
   end
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
   before = fill(0.0, 400)
   after = fill(0.0, 400)
   # Do the leapfrog
   #anim = @animate
   for time_step = 1:20000
      global R_cur, I_cur, prob_density, before, after
      R_next = real_psi(N, R_cur, I_cur, Δ_t, Δ_x, V)
      R_cur = R_next
      I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
      prob_density = R_cur.^2+I_next.*I_cur
      I_cur = I_next
      if time_step == 1
         before = filter(!isnan, prob_density[200:585])
      end
      if time_step == 19999
         after = filter(!isnan, prob_density[615:1000])
      end
#      plot(x, prob_density,
#         title = "Wave packet against ramp down",
#         xlabel = "x",
#         ylabel = "Probability density",
#         ylims = (0,200),
#         legend = false,
#         show = false
   #      )
      #plot!(x,abs.(V))
   end #every 20

   println(100*(1-((mean(before)-mean(after))/mean(before))))
   gif(anim, "./Figures/LeapFrog_testing.gif", fps=30)
#end

#@time leapfrog()
