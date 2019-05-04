function imag_psi_2D(N, I_current, R_current, delta_t, delta_x, V)
   I_next = zeros(N,N)
   s=delta_t/(2*delta_x^2)
   for x = 2:N-1
      for y = 2:N-1
         I_next[x,y]=I_current[x,y] +s*(R_current[x+1,y]-2*R_current[x,y]+R_current[x-1,y]+R_current[x,y+1]-2*R_current[x,y]+R_current[x,y-1])-delta_t*V[x,y].*R_current[x,y]
      end
   end
   return I_next
end
