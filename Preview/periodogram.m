function Px = periodogram(x, n1, n2)

x = x(:);
if nargin == 1
    n1 = 1;  n2 = length(x); end;
Px = abs(fft(x(n1:n2), 1024)).^2/(n2-n1+1);
Px(1) = Px(2);

end