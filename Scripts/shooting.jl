clear
N=200
delta_x=0.01
E_initial=1.879
delta_E=0.1
x=(delta_x: delta_x: N*delta_x)
V= zeros(1, N)
V(100:N) =1000
b= 1.5
last_diverge=0
  minimum_delta_E=0.005
  while abs(delta_E)>minimum_delta_E
    psi= zeros(1, N)
    psi(1)=1
    psi(2)=1
    [psi,i]=calculate_psi(psi, N, delta_x, E, b,V)
    plot(x, psi,'r')
    title('Square well')
    axis([0 2 -2 2])
    xlabel('distance')
    ylabel('Wavefunction')
    drawnow
    pause(0.5)
    if sign(psi(i+1))~=sign(last_diverge)
    delta_E=-delta_E/2;
  end
  E=E+delta_E
  last_diverge=sign(psi(i+1))
end



# goes in seperate file
function [psi,i] = calculate_psi(psi, N, delta_x, E, b,V)
#This function calculates psi
# Make psi_prime(0) =0 for an even parity solution;
  for i=2:N-1;
  psi(i+1)=2*psi(i)-psi(i-1)-2*(E-V(i))*delta_x^2*psi(i)
  if abs(psi(i+1)) > b
  #  if psi is diverging, exit the loop
  return
  end
end
