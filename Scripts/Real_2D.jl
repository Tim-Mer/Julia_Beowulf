function real_psi_2D(N, R_current, I_current, delta_t, delta_x, V)
   R_next= zeros(N,N)
   s=delta_t/(2*delta_x^2)
   for x = 2:N-1
      for y = 2:N-1
         R_next[x,y] = R_current[x,y] - s*(I_current[x+1,y]-2*I_current[x,y]+I_current[x-1,y]+I_current[x,y+1]-2*I_current[x,y]+I_current[x,y-1])+delta_t*V[x,y].*I_current[x,y]
      end
   end
   return R_next
end
