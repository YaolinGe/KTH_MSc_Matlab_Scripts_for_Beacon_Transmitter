
function y=filt_derot(y_rotated,Ntaps)
Nrot=floor(Ntaps/2);
% Compensate for filter offset 
if(length(y_rotated(:,1))<length(y_rotated(1,:)))
    y=fliplr(circshift(fliplr(y_rotated),Nrot));
else
    y=flipud(circshift(flipud(y_rotated),Nrot));
end
y(end-Nrot+1:end)=0;
end