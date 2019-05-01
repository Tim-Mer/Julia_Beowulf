using RandomNumbers.MersenneTwisters
using MPI

function randnum(r)
    return rand(r, Float64, 1)
end

function random(N, comm)
    r = MT19937()
    length = 1
    f = open("./Files/randnum.txt", "w")
        while length < N
            write(f, "$(randnum(r)) \n")
            length+=1
            MPI.Barrier(comm)
        end
    close(f)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    N = 10000
    if(MPI.Comm_rank(comm) == 0)
        touch("./Files/randnum.txt")
        rm("./Files/randnum.txt")
        println("Starting random number generation of $N random numbers!")
    end
    MPI.Barrier(comm)
    random(N, comm)

    MPI.Finalize()
end

main()
