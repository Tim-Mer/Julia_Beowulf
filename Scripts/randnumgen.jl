using RandomNumbers.MersenneTwisters
using MPI

function randnum(r, n)
    return rand(r, Float64, n)
end

function random(N, comm)
    r = MT19937()
    x = zeros(0)
    len = 1
    #f = open("./Files/randnum.txt", "w")
    while len < N
        MPI.Barrier(comm)
        append!(x, randnum(r, MPI.Comm_size(comm)))
        #write(f, "$(randnum(r)) \n")
        len+=MPI.Comm_size(comm)
    end
    if(MPI.Comm_rank(comm) == 0)
        println("Length x: $(length(x))")
    end
    MPI.Barrier(comm)
    #close(f)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    N = 200000#000
    if(MPI.Comm_rank(comm) == 0)
        #touch("./Files/randnum.txt")
        #rm("./Files/randnum.txt")
        println("Starting random number generation of $N random numbers!")
    end
    MPI.Barrier(comm)
    random(N, comm)

    MPI.Finalize()
end

main()
