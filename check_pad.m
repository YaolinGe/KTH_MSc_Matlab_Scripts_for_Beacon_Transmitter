function check_pad(ypad, Nbpad, Nfwpad)
bpad = ypad(:,[1:Nbpad]);
fwpad = ypad(:, [end-Nfwpad+1:end]);
% pad = [bpad, fwpad];
ypad = ypad(:, [Nbpad+1:end-Nfwpad]);

ypad_fw = [ypad([2:end], [1:Nfwpad]); zeros(1, Nfwpad)];
ypad_b = [zeros(1, Nbpad); ypad([1:end-1], [end-Nbpad+1:end])];

% bpad == ypad_b
% fwpad == ypad_fw
if isequal(bpad, ypad_b)&&isequal(fwpad, ypad_fw)
    disp('padding is correct, Congrats!');
else
    disp('Oops, something is wrong in padding!');
end