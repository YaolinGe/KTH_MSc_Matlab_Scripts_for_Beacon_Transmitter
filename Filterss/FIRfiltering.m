function [sw] = FIRfiltering(s, hw, TDorFD)
%% Usage: compute the filtering result using time domain or frequncy domain
if TDorFD
    sw =  conv(s, hw);
else
    N = max(length(s), length(hw));
    S = fft(s, N);
    HW = fft(hw, N);
    SW = S.*HW;
    sw = real(ifft(SW));
end %If
    
