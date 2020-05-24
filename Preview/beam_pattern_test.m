clear
close all
clc


N = 5: 5: 100;
lambda = 0.1;
d = lambda/2;
theta = -pi:0.001:pi;


for i = 1:length(N)
    BPC(i,:) = 10 * log((sin(N(i) * pi * d * sin(theta)/lambda) ./ (N(i) * sin(pi *d * sin(theta)/lambda))).^2);
end



plot(rad2deg(theta), BPC(1,:));
hold on;
plot(rad2deg(theta), BPC(2,:));
plot(rad2deg(theta), BPC(3,:));
plot(rad2deg(theta), BPC(4,:));
plot(rad2deg(theta), BPC(5,:));
% plot(rad2deg(theta), BPC(6,:));
% plot(rad2deg(theta), BPC(7,:));
% plot(rad2deg(theta), BPC(8,:));
ylim([-100, 0])
xlim([rad2deg(-max(theta)/2),rad2deg(max(theta)/2)])
legend('5', '10', '15')

