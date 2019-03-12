function calculate_psi(psi, N, delta_x, E, b,V)
  for i=2:N-1
    psi(i+1)=2*psi(i)-psi(i-1)-2*(E-V(i))*delta_x^2*psi(i)
    if abs(psi(i+1)) > b
        return psi, i
    end
  end
end
