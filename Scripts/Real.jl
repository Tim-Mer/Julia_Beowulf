function real_psi(N, R_current, I_current, delta_t, delta_x, V)
    R_next = fill(0.0, N)
    s = delta_t/(2*delta_x^2)
   for x in 2:N-1
      R_next[x] = R_current[x]-s*(I_current[x+1]-2*I_current[x]+I_current[x-1])+delta_t*V[x].*I_current[x]
      R_next[1] = R_next[2]
      R_next[N] = R_next[N-1]
   end
   return R_next
end
