using MPI
using Plots

function imag_psi_2D(N, I_current, R_current, delta_t, delta_x, V, comm)
   rank = MPI.Comm_rank(comm)
   size = MPI.Comm_size(comm)
   I_next = zeros(N,N)
   s=delta_t/(2*delta_x^2)
   for x = (((rank/size)*N)):(((rank/size)*N)+(N/size)-1)
      if x < 2
         x = x+2
      end
      for y = (((rank/size)*N)):(((rank/size)*N)+(N/size)-1)
         if y < 2
            y = y+2
         end
         I_next[x,y]=I_current[x,y] +s*(R_current[x+1,y]-2*R_current[x,y]+R_current[x-1,y]+R_current[x,y+1]-2*R_current[x,y]+R_current[x,y-1])-delta_t*V[x,y].*R_current[x,y]
      end
   end
   MPI.Barrier(comm)
   return I_next
end

function real_psi_2D(N, R_current, I_current, delta_t, delta_x, V, comm)
   rank = MPI.Comm_rank(comm)
   size = MPI.Comm_size(comm)
   R_next= zeros(N,N)
   s=delta_t/(2*delta_x^2)
   for x = (((rank/size)*N)):(((rank/size)*N)+(N/size)-1)
      if x < 2
         x = x+2
      end
      for y = (((rank/size)*N)):(((rank/size)*N)+(N/size)-1)
         if y < 2
            y = y+2
         end
         R_next[x,y] = R_current[x,y] - s*(I_current[x+1,y]-2*I_current[x,y]+I_current[x-1,y]+I_current[x,y+1]-2*I_current[x,y]+I_current[x,y-1])+delta_t*V[x,y].*I_current[x,y]
      end
   end
   MPI.Barrier(comm)
   return R_next
end

function imag_psi(N, I_current, R_current, delta_t, delta_x, V)
   I_next = fill(0.0, N)
   s = delta_t/(2*delta_x^2)
   for x in 2:N-1
      I_next[x] = I_current[x]+s*(R_current[x+1]-2*R_current[x]+R_current[x-1])-delta_t*V[x].*R_current[x];
      I_next[1] = I_next[2]
      I_next[N] = I_next[N-1]
   end
   return I_next
end


function main()
   ENV["PLOTS_TEST"] = "true"
   ENV["GKSwstype"] = "100"
   N = 200
   x_0 = fill(0.25, (N,N))
   y_0 = fill(0.5, (N,N))
   C = fill(10.0, (N,N))
   sigma_squared = fill(0.01, (N,N))
   k_0 = 40.0
   delta_x = 1/200
   delta_t = 0.00001
   a = range(0, stop = 1, length = N)
   x = zeros(N,N)
   for i = 1:N
      for j = 1:N
         x[i,j] = a[j]
      end
   end
   y = zeros(N,N)
   for i = 1:N
      for j = 1:N
         y[j,i] = a[j]
      end
   end
   V = zeros(N,N)
   for i = 1:N
      for j = convert(Int64, N/2):N
         V[i,j] = 1e3
      end
   end
   psi_stationary = C.*exp.((-(x-x_0).^2)./sigma_squared).*exp.((-(y-y_0).^2)./sigma_squared)
   plane_wave = exp.(1im*k_0*x) #+1im*k_0*y)
   psi_z = psi_stationary.*plane_wave
   R_initial = real(psi_z)
   I_initial = imag(psi_z)
   I_current = I_initial
   R_current = R_initial
   I_next = imag_psi(N, I_current, R_current, delta_t, delta_x, V)

    MPI.Init()
    comm = MPI.COMM_WORLD

    anim = @animate for time_step = 1:2000
       #global R_current, I_current, N, delta_t, delta_x, V, prob_density
       R_next = real_psi_2D(N, R_current, I_current, delta_t, delta_x, V, comm)
       R_current = R_next
       I_next = imag_psi_2D(N, I_current, R_current, delta_t, delta_x, V, comm)
       prob_density = R_current.^2 + I_next.*I_current
       I_current = I_next
       surface(x[1,:],y[:,1], prob_density,
          title = "Probability density function (wall)",
          xlabel = "x",
          ylabel = "y",
          zlabel = "ps*psi",
          xlims = (0,1), ylims = (0,1), zlims = (0,100),
          color = :speed,
          axis = true,
          grid = true,
          cbar = true,
          legend = false,
          show = false
       );
    end every 5

    if gethostname() == "masternode"
      gif(anim, "./Figures/bigtwoD_Leapfrog_wall.gif", fps=30)
    end
    MPI.Finalize()
end

main()
