function y = stretch_vector(in)
N = length(in);
for i = 1:N
    yr(:,i) = in(i).re;
    yi(:,i) = in(i).im;
end %for

yr = yr(:);
yi = yi(:);

y.re = yr;
y.im = yi;

end

