function thres = expand_threshold(threshold, N)
for i = 1:N
    thres(:, i) = threshold(i) * ones(64, 1);
end
thres = thres(:);
















