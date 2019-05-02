using RandomNumbers.MersenneTwisters
using MPI
import Printf: @printf

function randnum(r)
    return rand(r, Float64, 1)
end

function speed_test(r, N) where {T<:Number}
    A = Array{T}(undef, N)
    rand!(r, A)
    elapsed = @elapsed rand!(r, A)
    elapsed * N / N * 8 / sizeof(T)
end

function random(N, comm)
    r = MT19937()
    fo = open("$(MPI.Comm_size(comm)).log")
    redirect_stdout(fo)
    speed = speed_test(r, N)
    @printf "Speed Test: %.3f ns/64 bits\n" speed
    flush(fo)
    close(fo)
end

MPI.Init()
const comm = MPI.COMM_WORLD
const rank = MPI.Comm_rank(comm)
const size = MPI.Comm_size(comm)
N = convert(Int64, 24*1000)
r = MT19937()
if(MPI.Comm_rank(comm) == 0)
    touch("./Files/randnum.log")
    rm("./Files/randnum.log")
    println("Starting random number generation of $N random numbers!")
end
shared = zeros(N)
win = MPI.Win()
MPI.Win_create(shared, MPI.INFO_NULL, comm, win)
MPI.Barrier(comm)
offset = convert(Int64, N*(rank/size))
dest = 0
nb_elms = 2
no_assert = 0
#function test()
A = zeros(0)
if rank == dest
    println("Length of A before: ", length(A))
end
MPI.Barrier(comm)
for j = 1:(convert(Int64, N/size))
    append!(A, randnum(r))
end
MPI.Win_lock(MPI.LOCK_EXCLUSIVE, dest, no_assert, win)
MPI.Put(A, length(A), dest, offset, win)
MPI.Win_unlock(dest, win)
if rank == dest
    println("Length of A after: ", length(A))
end
MPI.Barrier(comm)
#end
#@time test()
MPI.Barrier(comm)
if rank == dest
    MPI.Win_lock(MPI.LOCK_SHARED, dest, no_assert, win)
    println("I was sent this: ", shared')
    println("It was length: ", length(shared))
    MPI.Win_unlock(dest, win)
end
#random(N, comm)
MPI.Finalize()
