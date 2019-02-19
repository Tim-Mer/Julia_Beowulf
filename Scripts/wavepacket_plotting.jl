using DelimitedFiles
rpsi = readdlm("Files/psi.txt", ',', ComplexF64)
rx = readdlm("Files/x.txt", ',', Float64)

using Plots
#plt = plot(layout = 3)
p1 =    plot(rx,real(rpsi),
        title = "Real part of wavefunction",
        xlabel = "Distance",
        ylabel = "Re(wavefunction)",
        #subplot = 1,
        legend = false
        )
p2 =    plot(rx,imag(rpsi),
        title = "Imaginary part of wavefunction",
        xlabel = "Distance",
        ylabel = "Im(wavefunction)",
        #subplot = 2,
        legend = false
        )
p3 =    plot(rx,real(rpsi.*conj(rpsi)),
        title = "Probability of finding a particle",
        xlabel = "Distance",
        ylabel = "psi*conj(psi)",
        #subplot = 3,
        legend = false
        )
plt = plot(p1, p2, p3, layout = 3)
savefig(p1, "Figures/Plot1.png")
savefig(p2, "Figures/Plot2.png")
savefig(p3, "Figures/Plot3.png")
savefig(plt, "Figures/Plots.png")
display(plt)
