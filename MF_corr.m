function [scorr, t] = MF_corr(s, x, B)
scorr = conv(x, conj(fliplr(s)));
t = (0:length(scorr)-1)/B;
end 