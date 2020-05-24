
function [xpad]=filter_prepad(x,padval,Nfilt)
% IN THE SONAR THE PADDING NEEDS TO BE SAMPLED VALUES
Nrot=floor(Nfilt/2); % Number of taps rotated by filter
Nrot_end=ceil(Nfilt/2)-1;
xpad=[ones(1,Nrot)*padval,x,ones(1,Nrot_end)*padval];
end
