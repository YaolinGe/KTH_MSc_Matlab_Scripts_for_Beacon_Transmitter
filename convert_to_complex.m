function yr = convert_to_complex(y)
yr.re = y(1:2:end);
yr.im = y(2:2:end);
end