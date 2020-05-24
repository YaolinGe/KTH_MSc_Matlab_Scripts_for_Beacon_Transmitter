function y=rescale_minC(y,minvaly)
miny=2^31-1;
for i=1:length(y.re)
    if( abs(y.re(i))<miny && abs(y.re(i))~=0 )
        miny=abs(y.re(i));
    end
end

for i=1:length(y.im)
    if( abs(y.im(i))<miny && abs(y.im(i))~=0 )
        miny=abs(y.im(i));
    end
end

if miny>minvaly
    for i=1:length(y.re)
        y.re(i)=(y.re(i)*minvaly)/miny;
        y.im(i)=(y.im(i)*minvaly)/miny;
    end
end
y.re=round(y.re);
y.im=round(y.im);
end