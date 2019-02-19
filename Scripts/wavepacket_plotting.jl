using DelimitedFiles
rpsi = readdlm("Files/psi.txt", ',', ComplexF64)
rx = readdlm("Files/x.txt", ',', Float64)

using Plots
plt = plot(layout = 3)
plot!(rx,real(rpsi),
        title = "Real part of wavefunction",
        xlabel = "Distance",
        ylabel = "Re(wavefunction)",
        subplot = 1,
        legend = false
        )
plot!(rx,imag(rpsi),
        title = "Imaginary part of wavefunction",
        xlabel = "Distance",
        ylabel = "Im(wavefunction)",
        subplot = 2,
        legend = false
        )
plot!(rx,real(rpsi.*conj(rpsi)),
        title = "Probability of finding a particle",
        xlabel = "Distance",
        ylabel = "psi*conj(psi)",
        subplot = 3,
        legend = false
        )
savefig(plt, "Figures/Plots.png")
display(plt)
