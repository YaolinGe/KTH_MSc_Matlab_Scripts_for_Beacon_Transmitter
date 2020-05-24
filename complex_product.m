function c = complex_product(a, b)
c.re = a.re*b.re - a.im*b.im;
c.im = a.re*b.im + a.im*b.re;
end %complex_product

