x = collect(0:0.0005:1)                         # creates an array from 0 to 1 in steps of 0.0005
x_0 = fill(0.4, 2001)                           # sets all the following values to their specified values
C = fill(25.0, 2001)                            # have to use fill so that it can multiply arrays properly
sigma_squared = fill(1e-3, 2001)
delta_x = 0.0005
delta_t = 0.2
k_0 = 500.0                                     # decimal point so that a float is created
# psi or ψ is the wavefunction
psi = C.*exp.((-(x-x_0).^2)./sigma_squared).*exp.((k_0*x)*1im) # equation as in book
# using the . is for elementwise operations
# saving psi and x to files so that they can be read by the plotting script
using DelimitedFiles
writedlm("Files/x.txt", x, ',')
writedlm("Files/psi.txt", psi, ',')
