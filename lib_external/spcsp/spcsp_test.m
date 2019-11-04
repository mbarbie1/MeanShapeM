clc; clear all; close all;
%Run this script to see smoothing cubic splines with periodic conditions
%used to approximate closed curves in 2D and 3D space.

%2D curve approximation: smoothing a noisy ellipse
a = 5; b = 2;
t = 0:.2:2*pi;
%noisy ellipse points
Y = [a*cos(t); b*sin(t)] + rand(2,length(t))-.5;
x = 1:numel(t);
xx = linspace(x(1),x(end),10*length(x)+1);
for p=0.1  
    % 
    pp = spcsp(x,Y,p);
    %     
    val = ppval(pp,xx);
    figure('Color','w');
    plot(Y(1,:),Y(2,:),'r--',val(1,:),val(2,:),'b-','LineWidth',5);
    title('spcsp in 2D');
    set(gca,'FontSize',30);
    grid on;
    legend('Noisy curve','Spline approx');
    xlabel('x');
    ylabel('y');
end

% 3D curve approximation: smoothing warped ellipse 
a = 5; b = 2;
t = 0:.2:2*pi;
z = [1:22,10:-1:1];
%noisy ellipse points
Y = [a*cos(t); b*sin(t); z] + rand(3,length(t))-.5;
x = 1:numel(t);
xx = linspace(x(1),x(end),10*length(x)+1);
for p=0.1  
    % 
    pp = spcsp(x,Y,p);
    %     
    val = ppval(pp,xx);
    figure('Color','w');
    plot3(Y(1,:),Y(2,:),Y(3,:),'r--',val(1,:),val(2,:),val(3,:),'b-','LineWidth',5);
    title('spcsp in 3D');
    set(gca,'FontSize',30);
    grid on;
    legend('Noisy curve','Spline approx');
    xlabel('x');
    ylabel('y');
    zlabel('z');
end