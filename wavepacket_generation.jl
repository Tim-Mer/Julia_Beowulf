x = collect(0:0.0005:1)                         # creates an array from 0 to 1 in steps of 0.0005
x_0 = fill(0.4, 2001)                           # sets all the following values to their specified values
C = fill(25.0, 2001)                            # have to use fill so that it can multiply arrays properly
sigma_squared = fill(1e-3, 2001)
delta_x = 0.0005
delta_t = 0.2
k_0 = 500.0                                     # decimal point so that it creates a float
psi = C.*exp.((-(x-x_0).^2)./sigma_squared).*exp.((k_0*x)*1im) # equation as in book
<<<<<<< HEAD
=======
writedlm("test.txt", psi, ',')
>>>>>>> 1c62080d237e71e73a107c0245aa9a4e2905b6b9
