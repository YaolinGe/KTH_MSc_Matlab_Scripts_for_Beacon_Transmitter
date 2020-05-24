%% test input data
clear;close all;clc;
dfile = 'data_PL_20000';
y = input_data(dfile);
fc = 47e3;
Fs = 160e3;
B = 5e3;
% y = [y;zeros(20480-length(y),1)];
% y = reshape(y, 2048,10);

y1 = data_acquisition('DB_test', 'DC_VALS');
y2 = data_acquisition('DB_test', 'DC_LP');
y3 = data_acquisition('DB_test', 'DC_LP_DC');
y4 = data_acquisition('DB_test', 'DC_LP_RE');


y1 = y1(:);
y2 = y2(:);
y3 = y3(:);
y4 = y4(:);
yy1.re = y1(1:2:end);
yy1.im = y1(2:2:end);

yy2.re = y2(1:2:end);
yy2.im = y2(2:2:end);

yy3.re = y3(1:2:end);
yy3.im = y3(2:2:end);

yy4.re = y4(1:2:end);
yy4.im = y4(2:2:end);

figure(1);
sgtitle('dc vals')
subplot(3,1,1);
plot(yy1.re);
subplot(3,1,2);
plot(yy1.im);
subplot(3,1,3);
plot(absC(yy1));

figure(2);
sgtitle('low passed filtered')
subplot(3,1,1);
plot(yy2.re);
subplot(3,1,2);
plot(yy2.im);
subplot(3,1,3);
plot(absC(yy2));

figure(3);
sgtitle('downsampled low pass filtered')
subplot(3,1,1);
plot(yy3.re);
subplot(3,1,2);
plot(yy3.im);
subplot(3,1,3);
plot(absC(yy3));

figure(4);
sgtitle('rescaled downsampled low pass filtered')
subplot(3,1,1);
plot(yy4.re);
subplot(3,1,2);
plot(yy4.im);
subplot(3,1,3);
plot(absC(yy4));

% v = data_acquisition('DB_test', 'DC_BUFFER');
[x, yre, yim, xlpre, xlpim, xdcre, xdcim, xrere, xreim] = signal_dc_block(y, fc, Fs, B);

figure(1); hold on;
yre = yre(:);
yim = yim(:);
yy.re = yre;
yy.im = yim;
subplot(3,1,1);hold on;
plot(yy.re);
subplot(3,1,2);hold on;
plot(yy.im);
subplot(3,1,3);hold on;
plot(absC(yy));

figure(2); hold on;
xlpre = xlpre(:);
xlpim = xlpim(:);
ylp.re = xlpre;
ylp.im = xlpim;
subplot(3,1,1);hold on;
plot(ylp.re);
subplot(3,1,2);hold on;
plot(ylp.im);
subplot(3,1,3);hold on;
plot(absC(ylp));

figure(3); hold on;
xdcre = xdcre(:);
xdcim = xdcim(:);
ydc.re = xdcre;
ydc.im = xdcim;
subplot(3,1,1); hold on;
plot(ydc.re);
subplot(3,1,2);hold on;
plot(ydc.im);
subplot(3,1,3);hold on;
plot(absC(ydc));

figure(4); 
xrere = xrere(:);
xreim = xreim(:);
y4re.re = xrere;
y4re.im = xreim;
subplot(3,1,1); hold on;
plot(y4re.re);
subplot(3,1,2);hold on;
plot(y4re.im);
subplot(3,1,3);hold on;
plot(absC(y4re));


% ydc = int16(ydc);

% figure(1);
% for i = 1:10
%     subplot(10,2,2*i-1); 
%     plot(ydc(:,i));
%     subplot(10,2,2*i)
%     plot(v(:,i));
%     disp(isequal(ydc(:,i),v(:,i)))
% end

% sgtitle('low pass filtered comparison')

% figure(1)
% v = v(:);
% x = x(:);
% plot(v*max(x)/max(abs(v)))

% hold on;
% plot(x)
% plot_title('downconversion comparison')
% legend('hardware', 'matlab')




