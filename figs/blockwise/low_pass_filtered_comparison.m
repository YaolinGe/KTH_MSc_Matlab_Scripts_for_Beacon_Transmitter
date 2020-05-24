%% test input data
clear;close all;clc;
dfile = 'data_PL_20000';
y = input_data(dfile);
fc = 47e3;
Fs = 160e3;
B = 5e3;
% y = [y;zeros(20480-length(y),1)];
% y = reshape(y, 2048,10);


v = data_acquisition('DB_test');

[x, ydc] = signal_dc_block(y, fc, Fs, B);


figure(1);
for i = 1:10
    subplot(10,2,2*i-1); 
    plot(ydc(:,i));
    subplot(10,2,2*i)
    plot(v(:,i));
    disp(isequal(ydc(:,i),v(:,i)))
end

sgtitle('low pass filtered comparison')


%%
%% test input data
clear;close all;clc;
dfile = 'data_PL_20000';
y = input_data(dfile);
fc = 47e3;
Fs = 160e3;
B = 5e3;


[ v, v_dc ] = data_acquisition('DB_test');

[x, ydc] = signal_dc_block(y, fc, Fs, B);
ydc = int16(ydc);

figure(1);
for i = 1:10
    subplot(10,2,2*i-1); 
    plot(ydc(:,i));
    subplot(10,2,2*i)
    plot(v(:,i));
    disp(isequal(ydc(:,i),v(:,i)))
end

sgtitle('low pass filtered comparison')

figure(2)
v = v(:);
plot(v)
ydc = ydc(:);
hold on;
plot(ydc)
grid on; grid minor; box on;
title('low pass filtered comparison')

figure(3)
v_dc = v_dc(:);
x = x(:);
plot(v_dc);
hold on;
plot(x)
grid on; grid minor; box on;
title("downconversion comparison")



