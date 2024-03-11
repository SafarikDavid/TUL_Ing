clear *
N = 10000;

d = randn(N,1);

delay = 3;
delay_2 = 8;

sigma = 0.5;

n_delay_change = 5001;

% udelat aby se to tady menilo v case
x = [d(delay+1:n_delay_change);
    zeros(delay,1);
    d(n_delay_change+delay_2+1:end);
    zeros(delay_2,1)]...
    + sigma * randn(N,1);

L = 15;
mu = 0.01;
w = zeros(L,1);
y = zeros(N,1);


for n = L:N
    xn = x(n:-1:n-L+1);
    y(n) = w'*xn;
    e = d(n) - y(n);
    w = w + mu*xn*e;
    
    if mod(n,10)==0
        subplot(1,2,1)
        plot(w)
        axis([1 L -1 1])
        subplot(1,2,2)
        plot(1:N,d,'k',1:N,y,'r')
        axis([1 N -4 4])
        drawnow
    end
end
