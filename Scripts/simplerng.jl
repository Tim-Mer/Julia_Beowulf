using RandomNumbers.MersenneTwisters
using MPI

function randnum(r)
    return rand(r, Float64, 1)
end

MPI.Init()
const comm = MPI.COMM_WORLD
const rank = MPI.Comm_rank(comm)
const size = MPI.Comm_size(comm)
N = convert(Int64, 24*100000000)
r = MT19937()
if(rank == 0)
    println("Starting random number generation of $N random numbers!")
end
MPI.Barrier(comm)
for j = 1:(convert(Int64, N/size))
    randnum(r)
end
MPI.Barrier(comm)
MPI.Finalize()
