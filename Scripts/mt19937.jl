include("common.jl")
using RandomNumbers.MersenneTwisters
#using MPI
function main()
    #MPI.Init()
    #comm = MPI.COMM_WORLD
    const TEST_NAME = "Beowulf_Cluster"
    r = MT19937()
    test_all(r, 10000)
    #MPI.Finalize()
end

main()
