function y = expand_index(index, N)
for i = 1:N
    y(i) = (i-1)*64 + index(i);
end

end %