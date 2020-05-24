function thresholds = thresholding(y, scale)
n = length(y);
Nframe = 64;
Nframes = ceil(n/Nframe);
if iscolumn(y)
    y = y';
end
y = [y, ones(1, Nframes*Nframe-n)*mean(y)];

Y = reshape(y, Nframe, Nframes);
for i = 1:Nframes
    threshold(i) = sqrt(var(Y(:,i)))*scale + mean(Y(:,i));
    thresholds(:,i) = ones(Nframe, 1)*threshold(i);
end %for
thresholds = thresholds(:);

end


