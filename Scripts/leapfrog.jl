clear;
N=1000;
x= linspace(0,1,N);
x_0=0.4;
C=10;
sigma_squared=1e-3;
k_0=500;
delta_x=1e-3;
delta_t=5e-8;
psi=C*exp(-(x-x_0).^2/sigma_squared).*exp(1i*k_0*x);
R_initial=real(psi);
I_initial=imag(psi);
V= zeros(1, N);
V(600:N) =-1e6;
I_current=I_initial;
R_current=R_initial;
# t=t+delta_t/2;
[I_next] = imag_psi(N, I_current, R_current, delta_t, delta_x, V);
# Do the leapfrog
for time_step = 1:15000
   [R_next]=real_psi(N, R_current, I_current, delta_t, delta_x, V);
   R_current=R_next;
   [I_next] = imag_psi(N, I_current, R_current, delta_t, delta_x, V);
   prob_density=R_current.^2+I_next.*I_current;
   I_current=I_next;
   if rem(time_step, 10)== 0
      plot(x, prob_density,'-b','LineWidth',2);
      title('Reflection from cliff');
      axis([0 1 0 200]);
      xlabel('x');
      ylabel('Probability density');
      drawnow;
   end
end

function [I_next]= imag_psi(N, I_current, R_current, delta_t, delta_x, V)
   I_next= zeros(1,N);
   s=delta_t/(2*delta_x^2);
   for x=2:N-1
      I_next(x)=I_current(x) +s*(R_current(x+1)-2*R_current(x)+R_current(x-1))-delta_t*V(x).*R_current(x);
      I_next(1)=I_next(2);
      I_next(N)=I_next(N-1);
   end
end
function [R_next]= real_psi(N, R_current, I_current, delta_t, delta_x, V)
    R_next= zeros(1,N);
    s=delta_t/(2*delta_x^2);
   for x=2:N-1
      R_next(x)=R_current(x) - s*(I_current(x+1)-2*I_current(x)+I_current(x-1))+delta_t*V(x).*I_current(x);
      R_next(1)=R_next(2);
      R_next(N)=R_next(N-1);
   end
end
