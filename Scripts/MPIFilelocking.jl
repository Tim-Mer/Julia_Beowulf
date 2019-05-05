using RandomNumbers.MersenneTwisters
using MPI
import Printf: @printf

MPI.Init()
const comm = MPI.COMM_WORLD
const rank = MPI.Comm_rank(comm)
const size = MPI.Comm_size(comm)
N = 48#00#000000
if(MPI.Comm_rank(comm) == 0)
    touch("./Files/randnum.log")
    rm("./Files/randnum.log")
    println("Starting random number generation of $N random numbers!")
end
shared = zeros(N)
win = MPI.Win()
MPI.Win_create(shared, MPI.INFO_NULL, comm, win)
MPI.Barrier(comm)
offset = N*(rank/size)
dest = 0
nb_elms = 1
no_assert = 0
for i = 0:1
for i = 0:(convert(Int64, N/size))
    MPI.Win_lock(MPI.LOCK_EXCLUSIVE, dest, no_assert, win)
    MPI.Put([Float64(rank)], nb_elms, dest, convert(Int64, offset+i), win)
    MPI.Win_unlock(dest, win)
end
MPI.Barrier(comm)
if rank == dest
    MPI.Win_lock(MPI.LOCK_SHARED, dest, no_assert, win)
    println("I was sent this: ", shared')
    MPI.Win_unlock(dest, win)
end

MPI.Finalize()
