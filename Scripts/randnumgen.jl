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
        y = randnum(r, 1)
        append!(x, MPI.Gather(y, 0, comm))
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
    N = 2000000#00
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
