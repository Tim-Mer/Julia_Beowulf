using RandomNumbers.MersenneTwisters
using MPI
import Printf: @printf

function randnum(r)
    return rand(r, Float64, 1)
end

MPI.Init()
const comm = MPI.COMM_WORLD
const rank = MPI.Comm_rank(comm)
const size = MPI.Comm_size(comm)
N = convert(Int64, 24*4000000)
r = MT19937()
if(MPI.Comm_rank(comm) == 0)
#    touch("./Files/randnum.log")
#    rm("./Files/randnum.log")
    println("Starting random number generation of $N random numbers!")
end
#shared = zeros(N)
#win = MPI.Win()
#MPI.Win_create(shared, MPI.INFO_NULL, comm, win)
#MPI.Barrier(comm)
#offset = convert(Int64, N*(rank/size))
dest = 0
#nb_elms = 2
#no_assert = 0
#function test()
#A = zeros(0)
#if rank == dest
#    println("Length of A before: ", length(A))
#end
MPI.Barrier(comm)
for j = 1:(convert(Int64, N/size))
    randnum(r)#append!(A, randnum(r))
end
#MPI.Win_lock(MPI.LOCK_EXCLUSIVE, dest, no_assert, win)
#MPI.Put(A, length(A), dest, offset, win)
#MPI.Win_unlock(dest, win)
#if rank == dest
    #println("Length of A after: ", length(A))
    #println("Lenght of shared: ", length(shared))
#end
#MPI.Barrier(comm)
#end
#@time test()
MPI.Barrier(comm)
#if rank == dest
#    MPI.Win_lock(MPI.LOCK_SHARED, dest, no_assert, win)
#    println("I was sent this: ", shared')
#    println("It was length: ", length(shared))
#    MPI.Win_unlock(dest, win)
#end
#random(N, comm)
MPI.Finalize()
