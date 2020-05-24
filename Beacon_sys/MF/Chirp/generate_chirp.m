function [chirp] = generate_chirp(Fs,f1,f2,Tchirp)
omega1=f1*2*pi;
omega2=f2*2*pi;
dt=1/Fs;

% Haxlösning (del 2), kolla på senare !!!!!!!!!!!!!!!!!!!!!!!!!!
Tchirp=Tchirp*2; 

N_chirp=Tchirp/dt;
omega=omega1:(omega2-omega1)/(N_chirp):omega2-(omega2-omega1)/N_chirp;
% omega=0.5*omega1:0.5*(omega2-omega1)/(N_chirp):0.5*(omega2-(omega2-omega1)/N_chirp);
% omega=0.5*omega1:0.5*(omega2-omega1)/(N_chirp):0.5*(omega2-(omega2-omega1)/N_chirp);

t = 0:dt:(Tchirp-dt);     
% t = (-(t_chirp-dt)/2:dt:(t_chirp-dt)/2);     


% omega0=(omega2-omega1)/2;
    
% chirp=sin(t*omega0+((omega2-omega1)/(2*t_chirp))*t.^2 );
% chirp=sin(t*omega0+0.5*omega.*(t.^2));
% chirp=sin(t*omega0+0.5*(omega2-omega1)*(t.^2));
chirp=sin(t.*omega);

% Haxlösning (del 2), kolla på senare !!!!!!!!!!!!!!!!!!!!!!!!!!
chirp=transpose( chirp(1:floor(length(chirp)/2)) );

% chirp=sin( 2*pi*t.*( f1+0.5*(f2-f1)*t ) );


% figure(69);plot(omega/(2*pi));
end