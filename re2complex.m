function [x_c]=re2complex(x)
x_c.re=x;
x_c.im=zeros(1,length(x));
end
