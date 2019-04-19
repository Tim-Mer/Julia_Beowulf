import MPI
include("2Dparallel-impl.jl")

function main()
    MPI.Init()

    twoD()

    MPI.Finalize()
end

main()
