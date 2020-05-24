N = 32;
x = zeros(1, N);
x(7:26) =  1;

X = fft(x)
stem(real(X))
figure()
stem(imag(X))



syms x
diff(heaviside(x), x)
diff(heaviside(x), x, x)


int(dirac(x), x)