using MPI # Adding the MPI Library

MPI.Init() # Initialising the MPI library
const comm = MPI.COMM_WORLD # setting configuration constants
const rank = MPI.Comm_rank(comm)
const size = MPI.Comm_size(comm)

N = convert(Int64, size*2) # setting N to twice the size
shared = zeros(N) # creating an array that will become shared
win = MPI.Win() # creating the window that will be used to share an array
MPI.Win_create(shared, MPI.INFO_NULL, comm, win) # adding the array to the window
MPI.Barrier(comm) # waiting for all ranks to catch up
offset = N*(rank/size) # setting the offset for each rank
dest = 0 # setting the destination node
nb_elms = 1 # setting the number of elements that will be added at a time
no_assert = 0 # setting assert to false
for i = 0:1
    MPI.Win_lock(MPI.LOCK_EXCLUSIVE, dest, no_assert, win) # locking the shared resource
    MPI.Put([Float64(rank)], nb_elms, dest, convert(Int64, offset+i), win) # adding a ranks rank number to the array
    MPI.Win_unlock(dest, win) # unlocking the resource
end
MPI.Barrier(comm) # waiting for all ranks to catch up

if rank == 0 # Only rank 0 will performe this
    MPI.Win_lock(MPI.LOCK_SHARED, dest, no_assert, win) # locking resource
    println("I was sent this: ", shared') # displaying the shared array
    MPI.Win_unlock(dest, win) # unlocking the resource
end
MPI.Finalize() # Finalising the MPI section of code
