using Plots
using Plots.PlotMeasures
using Statistics
using DelimitedFiles
include("Real.jl")
include("Imag.jl")
#function leapfrog()
#for p = 0:50:600
   ENV["PLOTS_TEST"] = "true" #used to remove errors when running on headless linux
   ENV["GKSwstype"] = "100"
   N = 1000 #resolution 1000
   x = collect(0:(1/(N-1)):1) #all possible positions 0:1
   x_0 = fill(0.4, N) #starting possition 0.4
   C = fill(10.0, N) #normalising factor 10.0
   σ_sqrd = fill(1e-3, N) #width 1e-3
   k_0 = 500.0#+p #speed 500.0
   Δ_x = 1e-3 #change in distance 1e-3
   Δ_t = 5e-8 #change in time 5e-8
   ψ = C.*exp.((-(x-x_0).^2)./σ_sqrd).*exp.((k_0*x)*1im) #starting wave equation
   #ψ[1] = 0
   #ψ[1000] = 0
   R_cur = real(ψ)
   I_cur = imag(ψ)
   V = fill(0.0, N)
   #t = collect(0:1/(pi*50.65):2*pi)
   #wave = 5000000 .+ 5000000 .* cos.(2 * pi .+ t)
   #length(wave)
   #for i = 1:N
   #   V[i] = -500*i
   #end
   for i = 600:650
      V[i] = 5e4#1e6#-(i-599)*2500
   end
   for i = 750:800
      V[i] = 5e4#1e6
   end
   #V = wave
   I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
   #before = fill(0.0, 386)
   #after = before
   # Do the leapfrog
   global R_cur, I_cur, prob_density, before, after
   anim = @animate for time_step = 1:40000
      global R_cur, I_cur, prob_density, before, after
      R_next = real_psi(N, R_cur, I_cur, Δ_t, Δ_x, V)
      R_cur = R_next
      I_next = imag_psi(N, I_cur, R_cur, Δ_t, Δ_x, V)
      prob_density = R_cur.^2+I_next.*I_cur # ¦ψ(x,t)¦^2
      I_cur = I_next
#      if time_step == 1
#         before = filter(!isnan, prob_density[200:585])
#      end
#      if time_step == 19999
#         after = filter(!isnan, prob_density[200:585])
#      end
      plt = plot(x, prob_density,
         title = "Double barrier k=$(convert(Int64, k_0)) frame $(time_step)",#sigma_sqrd=$(σ_sqrd[1])",#k=$(convert(Int64, k_0)) frame=$(time_step)",
         xlabel = "x",
         ylabel = "Probability density",
         ylims = (0,200),
         xlims = (0,1),
         legend = false,
         #right_margin = 10mm,
         show = false
         )
      plt = plot!(twinx(), V,
         xaxis = false,
         grid = false,
         ylims = (0,maximum(V)),
         xlims = (1, 1000),
         legend = false,
         show = false,
         color = :red
         )
         if time_step == 1 || time_step%2500 == 0
            savefig(plt, "./Figures/report/test double barrier k=$(convert(Int64, k_0)) frame=$(time_step).png")
            println(time_step)
         end
         #display(plt)
end every 20
   #percentage = round(100*(((mean(before)-mean(after))/mean(before))); digits=2)
   gif(anim, "./Figures/test/Leapfrog_double_barrier_test_k=$(convert(Int64, k_0)).gif", fps=30)
   #println(percentage)
#   open("./Files/test.csv", "w") do f
#      writedlm(f, [before after], ",")
#   end
#end
#end

#@time leapfrog()
