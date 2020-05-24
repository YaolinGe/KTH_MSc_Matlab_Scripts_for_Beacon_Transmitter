function yref = generate_refsig_sine(np, fc)
Fs = 160e3;
B = 5e3;
FXPRES = pow2(12);
Scale = 1023;

T = 1/fc;
Tp = T * np;
Np = Tp * Fs;

t = (0:Np - 1)/Fs;
yref = sig2FXP(sin(2*pi*fc*t), FXPRES);
yref_dc = signal_dc(yref, fc, Fs, B);
% yref_out = absC(yref_dc); 
yref_dc = rescale_maxC(yref_dc, Scale);

end