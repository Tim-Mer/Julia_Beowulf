include("common.jl")
using RandomNumbers.MersenneTwisters
const TEST_NAME = "Beowulf_Cluster"

r = MT19937(123)
test_all(r, 10000)
