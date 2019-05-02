include("common.jl")
using RandomNumbers.MersenneTwisters
const TEST_NAME = "Beowulf_Cluster"
#using MPI
function main()
    #MPI.Init()
    #comm = MPI.COMM_WORLD
    r = MT19937()
    test_all(r, 10000)
    #MPI.Finalize()
end

main()
