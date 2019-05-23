using Plots

function calculate_psi(psi, N, delta_x, E, b,V)
  for i=2:N-1
    psi[i+1]=2*psi[i]-psi[i-1]-2*(E-V[i])*delta_x^2*psi[i]
    if abs(psi[i+1]) > b
        return psi, i
    end
  end
end

N = 200
delta_x = 0.01
E_initial = 2#1.879
delta_E = 0.1
x = collect(delta_x: delta_x: N*delta_x)
V = fill(0.0, N)
for i = 101:N
  V[i] = 1000
end
b = 1.5
last_diverge = 0
minimum_delta_E = 0.0005
E = E_initial
while abs(delta_E) > minimum_delta_E
    global E, psi, i, last_diverge, delta_E, plt, j
    psi = fill(0.0, N)
    psi[1] = 1
    psi[2] = 1
    psi,i = calculate_psi(psi, N, delta_x, E, b,V)
    plt = plot(append!(-(x[end:-1:1]), x), append!((psi[end:-1:1]), psi),
    title = "Square well",
    xlims = (-2, 2),
    ylims = (-2, 2),
    xlabel = "distance",
    ylabel = "Wavefunction",
    legend = false
    )
    plt = plot!(append!(-(x[end:-1:1]), x),append!((V[end:-1:1]), V))
    if sign(psi[i+1]) != sign(last_diverge)
        delta_E = -delta_E/2
    end
    E = E + delta_E
    last_diverge = sign(psi[i+1])
    #display(plt)
    sleep(0.1)
    savefig(plt, "./Figures/test/shooting$(E_initial)_$(j).png")
    println(E)
end
