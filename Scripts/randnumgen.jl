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
            MPI.Barrier(comm)
            write(f, "$(randnum(r)) \n")
            if(MPI.Comm_rank(comm) == 0)
                println(length)
            end
            length+=1
        end
    close(f)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    N = 50
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
