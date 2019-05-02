using RandomNumbers.MersenneTwisters
using MPI

function randnum(r)
    return rand(r, Float64, 1)
end

function main(comm, n)
    rank = MPI.Comm_rank(comm)
    size = MPI.Comm_size(comm)
    N = convert(Int64, 24*n)
    r = MT19937()
    if(rank == 0)
        println("Starting random number generation of $N random numbers!")
    end
    MPI.Barrier(comm)
    for j = 1:(convert(Int64, N/size))
        randnum(r)
    end
    MPI.Barrier(comm)

end

MPI.Init()
comm = MPI.COMM_WORLD
n = 100000000
time = @time main(comm, n)
println(time)
MPI.Finalize()
