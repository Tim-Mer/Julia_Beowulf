# This file is ran using the numgentest script located in the home directory
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
        println("With each node computing $(convert(Int64, round(N/size))) random numbers!")
    end
    MPI.Barrier(comm)
    for j = 1:(convert(Int64, round(N/size)))
        randnum(r)
    end
    MPI.Barrier(comm)
end

MPI.Init()
comm = MPI.COMM_WORLD
n = 2e8
if MPI.Comm_rank(comm) == 0
    @time main(comm, n)
else
    main(comm, n)
end
MPI.Finalize()
