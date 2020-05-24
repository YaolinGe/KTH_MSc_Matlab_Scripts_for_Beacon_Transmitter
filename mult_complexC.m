% Vector & single value function
function res=mult_complexC(in1,in2)
    res.re=in1.re.*in2.re-in1.im.*in2.im;
    res.im=in1.re.*in2.im+in1.im.*in2.re;
end