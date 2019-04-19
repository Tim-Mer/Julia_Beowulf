import MPI

function main()
    MPI.Init()

    twoD()

    MPI.Finalize()
end

main()
