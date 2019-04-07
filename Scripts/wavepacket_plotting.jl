# reading in files using the approatiate datatype
using DelimitedFiles
rpsi = readdlm("./Files/psi.txt", ',', ComplexF64)
rx = readdlm("./Files/x.txt", ',', Float64)

# plotting all 3 plots
using Plots
p1 =    plot(rx,real(rpsi),
        title = "Real part",
        xlabel = "Distance",
        ylabel = "Re(wavefunction)",
        legend = false,
        linecolor = :red
        )
p2 =    plot(rx,imag(rpsi),
        title = "Imaginary part",
        xlabel = "Distance",
        ylabel = "Im(wavefunction)",
        legend = false,
        linecolor = :blue
        )
p3 =    plot(rx,real(rpsi.*conj(rpsi)),
        title = "Probability of finding a particle",
        xlabel = "Distance",
        ylabel = "psi*conj(psi)",
        legend = false,
        linecolor = :black
        )
plt = plot(p1, p2, p3, layout = 3) # plotting all 3 plots on one page
# saving the plots as .png
savefig(p1, "Figures/Plot1.png")
savefig(p2, "Figures/Plot2.png")
savefig(p3, "Figures/Plot3.png")
savefig(plt, "Figures/Plots.png")
# displays the plt in atom
display(plt)
