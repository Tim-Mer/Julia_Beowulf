using RandomNumbers.MersenneTwisters
using MPI

function randnum(r)
    return rand(r, Float64, 1)
end

function random()
    r = MT19937()
    length = 0
    f = open("./Files/randnum.txt", "w")
        while length < 40
            write(f, "$(randnum(r)) \n")
            if(MPI.Comm_rank(comm) == 0)
                length+=MPI.Comm_size(comm)
            end
            MPI.Barrier(comm)
        end
    close(f)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    if(MPI.Comm_rank(comm) == 0)
        touch("./Files/randnum.txt")
        rm("./Files/randnum.txt")
    end
    MPI.Barrier(comm)
    random()

    MPI.Finalize()
end

main()
