x = collect(0:0.0005:1)                         # creates an array from 0 to 1 in steps of 0.0005
x_0 = fill(0.4, 2001)                           # sets all the following values to their specified values
C = fill(25.0, 2001)                            # have to use fill so that it can multiply arrays properly
sigma_squared = fill(1e-3, 2001)
delta_x = 0.0005
delta_t = 0.2
k_0 = 500.0                                     # decimal point so that it creates a float
psi = C.*exp.((-(x-x_0).^2)./sigma_squared).*exp.((k_0*x)*1im) # equation as in book
using DelimitedFiles
writedlm("x.txt", x, ',')
writedlm("psi.txt", psi, ',')   # writing psi to a file
using Plots
plot(layout = 3)
plot!(x,real(psi),
        title = "Real part of wavefunction",
        xlabel = "Distance",
        ylabel = "Re(wavefunction)",
        subplot = 1,
        legend = false
        )
plot!(x,imag(psi),
        title = "Imaginary part of wavefunction",
        xlabel = "Distance",
        ylabel = "Im(wavefunction)",
        subplot = 2,
        legend = false
        )
plot!(x,real(psi.*conj(psi)),
        title = "Probability of finding a particle",
        xlabel = "Distance",
        ylabel = "psi*conj(psi)",
        subplot = 3,
        legend = false
        )
savefig("Plots.png")
