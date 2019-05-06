using Plots
using Statistics
using DelimitedFiles
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
   #t = collect(0:1/(pi*50.65):2*pi)
   #wave = 500000 .+ 500000 .* cos.(2 * pi .+ t)
   #length(wave)
   for i = 550:600
      V[i] = 5e4
   end
   for i = 700:750
      V[i] = 5e4
   end
   #V = wave
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
   before = fill(0.0, 386)
   after = before
   # Do the leapfrog
   anim = @animate for time_step = 1:20000
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
         after = filter(!isnan, prob_density[200:585])
      end
      plot(x, prob_density,
         title = "Wave packet testing",
         xlabel = "x",
         ylabel = "Probability density",
         ylims = (0,200),
         xlims = (0,1),
         legend = false,
         show = false
         )
      plot!(twinx() ,abs.(V),
         xticks = 0:0.25:1,
         ylims = (0, (V[600])),
         legend = false,
         show = false,
         color = :red
         )
      #display(plt)
end every 20
   percentage = round(100*(((mean(before)-mean(after))/mean(before))); digits=2)
   gif(anim, "./Figures/LeapFrog_testing_double_barrier.gif", fps=30)
   println(percentage)
#   open("./Files/test.csv", "w") do f
#      writedlm(f, [before after], ",")
   #end
#end

#@time leapfrog()
