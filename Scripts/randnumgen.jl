using RandomNumbers.MersenneTwisters
using MPI

function randnum(r, n)
    return rand(r, Float64, n)
end

function random(N, comm)
    r = MT19937()
    x = zeros(N)
    n = convert(Int64, N/MPI.Comm_size(comm))
    MPI.Scatter(x, n, 0, comm)
    len = 1
    #f = open("./Files/randnum.txt", "w")
    while len < n
        MPI.Barrier(comm)
        randnum(r, 1)
        #write(f, "$(randnum(r)) \n")
        len+=1
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
