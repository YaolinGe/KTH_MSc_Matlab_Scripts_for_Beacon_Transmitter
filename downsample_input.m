function y = downsample_input(x, p, q)
next = q / p;
inext = 1;
i = 1;
while(inext<length(x))
    y(i) = x(inext);
    inext = i * next;
    i = i + 1;

end %while