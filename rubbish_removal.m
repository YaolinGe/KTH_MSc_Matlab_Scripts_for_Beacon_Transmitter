function y = rubbish_removal(input, Ntaps)

Nrot = floor(Ntaps/2);
y = fliplr(circshift(fliplr(input), Nrot));
y(end-Nrot+1:end) = 0;

end