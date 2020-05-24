function y = depad(ypad, Nbpad, Nfwpad)
%% depad returns the matrix which is depadded 
y = ypad(:, Nbpad+1:end-Nfwpad);

end