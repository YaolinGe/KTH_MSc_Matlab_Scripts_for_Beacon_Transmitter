function check_reshape(y_re, y, row, col)
y_new = y(1:row * col);
for i = 1:col
    ma = isequal(y_re(:, i), y_new((i-1)*64+1:i*64));
end
if all(ma)
    disp("RESHAPE iS CORRECT! CONGRATS!");
else
    disp("RESHAPE IS NOT CORRECT! PLEASE CHECK!");
end