using RandomNumbers.MersenneTwisters
using MPI

function randnum(r)
    return rand(r, Float64, 1)
end

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    r = MT19937()
    length = 0
    open("./Files/randnum.txt", "w") do f
        while length < 40
            write(f, "$(randnum(r)) \n")
            MPI.Barrier(comm)
            length+=1
        end
    end
    MPI.Finalize()
end
touch("./Files/randnum.txt")
rm("./Files/randnum.txt")
@time main()
