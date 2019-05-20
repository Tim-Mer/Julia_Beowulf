using RandomNumbers.MersenneTwisters

function randnum(r)
    return rand(r, Float64, 1)
end

N = convert(Int64, 24*4000000)
r = MT19937()
println("Starting random number generation of $N random numbers!")

for j = 1:N
    randnum(r)
end
