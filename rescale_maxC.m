function y=rescale_maxC(y,maxvaly)
maxy=0;
MAX = 1023*1023;
for i=1:length(y.re)
    if(abs(y.re(i))>maxy)
        maxy=abs(y.re(i));
    end
end

for i=1:length(y.im)
    if(abs(y.im(i))>maxy)
        maxy=abs(y.im(i));
    end
end

% disp('maxy is '); disp(maxy);
% disp('MAX is '); disp(MAX);
% disp('maxvaly is '); disp(maxvaly);

if maxy<MAX
    maxy = MAX;
end

% if maxy>maxvaly
%     scale=ceil(maxvaly/maxy); % to avoid overflow
for i=1:length(y.re)
    y.re(i)= int16((y.re(i)*maxvaly)/maxy);
    y.im(i)= int16((y.im(i)*maxvaly)/maxy);
end
% end

end