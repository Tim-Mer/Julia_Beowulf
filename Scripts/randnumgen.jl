using RandomNumbers.MersenneTwisters
using MPI
import Printf: @printf

function randnum(r, n)
    return rand(r, Float64, n)
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
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
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
offset = rank
dest = 0
nb_elms = 2
no_assert = 0
MPI.Win_lock(MPI.LOCK_EXCLUSIVE, dest, no_assert, win)
MPI.Put([Float64(rank)], nb_elms, dest, offset, win)
MPI.Win_unlock(dest, win)
MPI.Barrier(comm)
if rank == dest
    MPI.Win_lock(MPI.LOCK_SHARED, dest, no_assert, win)
    println("I was sent this: ", shared')
    MPI.Win_unlock(dest, win)
end
#random(N, comm)
MPI.Finalize()
