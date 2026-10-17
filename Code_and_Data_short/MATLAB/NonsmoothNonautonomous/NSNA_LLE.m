clc; close all; clear all;
format compact;

% =========================================================
% Generate Rossler Time Series using ode45
% =========================================================

% Rossler parameters
a = 0.2;
b_values = 0.01:0.01:5;
c = 5.7;
mu = 5;
A = 3;
omega = 3;

% Time span
dt = 0.001;
tspan = 0:dt:2000;

% Initial condition
x0 = [0 0 0];

LLE_vs_b = [];

% Initialize figure
figure;
opts = odeset('RelTol',1e-6,'AbsTol',1e-6);
pks_array = [];

% Loop over parameter b
for b = b_values

    fprintf('For b = %.2f\n', b);

    % Solve Rossler system
    [t,X] = ode45(@(t,x) rossler(t,x,a,b,c,mu,A,omega), tspan, x0, opts);

    % remove transient part
    X = X(round(0.9*length(t)):end, :);
    t = t(round(0.9*length(t)):end);

    subplot(2,1,1)

    % Extract local maxima to show periodicity
    [pks, ~] = findpeaks(X(:,1));
    pks = uniquetol(pks, 0.02);

    b_array = b * ones(size(pks));

    pks_array = [pks_array; b_array pks];


    % Plot periodic points as lines
    plot(b_array, pks, 'k.', 'MarkerSize', 6);
    hold on;

    % Use x-component as 1-D time series
    data = X(:,1);

    % Save data for Wolf algorithm
    save('mydata.txt','data','-ascii');

    disp('Rossler time series generated successfully');

    % =========================================================
    % Wolf Algorithm Parameters
    % =========================================================

    fname  = 'mydata.txt';

    datcnt = length(data);
    tau = 10;
    ndim = 3;
    ires = 10;
    maxbox = 6000;

    db = basgen(fname, tau, ndim, ires, datcnt, maxbox);

    dt = .01;
    evolve = 20;
    dismin = 0.001;
    dismax = 0.3;
    thmax = 30;

    [out, SUM] = fet(db, dt, evolve, dismin, dismax, thmax);

    % Final estimate
    LLE = out(end,4);

    fprintf('Largest Lyapunov Exponent = %.6f\n',LLE);

    LLE_vs_b = [LLE_vs_b; LLE];

end

% Enhance the plot
subplot(2,1,1)
scatter(pks_array(:,1), pks_array(:,2), 5, 'b', 'filled')
xlabel('b', 'FontSize', 12);
ylabel('Poincare Points (X Peaks)', 'FontSize', 12);
title('Bifurcation diagram of the rossler autonomous', 'FontSize', 14);
set(gca, 'FontSize', 12);
grid on;

subplot(2,1,2)
plot(b_values, LLE_vs_b, '-b', 'LineWidth',2);
hold on
plot(b_values, zeros(1,length(b_values)), ':r', 'LineWidth',2);
title('Largest Lyapunov Exponent vs b')
xlabel('b'); ylabel('LLE')

% Optional plotting (comment if slow)
% makeplot(db,out,evolve,'NorthWest');

% =========================================================
% Rossler System Function
% =========================================================
function dx = rossler(t,x,a,b,c,mu,A,omega)

dx = zeros(3,1);

dx(1) = -x(2) - x(3);
dx(2) =  x(1) + a*x(2);
dx(3) =  b+ x(3)*x(1) - x(3)*c + mu*(x(1))*heaviside(x(1)-3)+A*sin(omega*t);

end

%%LINKAXES

%%
figure(1)
tiledlayout(2,1)
ax1=nexttile;
% Enhance the plot
scatter(pks_array(:,1), pks_array(:,2), 5, 'b', 'filled')
xlabel('b', 'FontSize', 12);
ylabel('Poincare Points (X Peaks)', 'FontSize', 12);
title('Bifurcation diagram of the rossler nonsmooth autonomous', 'FontSize', 14);
set(gca, 'FontSize', 12);
grid on;

ax2=nexttile;
plot(b_values, LLE_vs_b, '-b', 'LineWidth',2);
hold on
plot(b_values, zeros(1,length(b_values)), ':r', 'LineWidth',2);
title('Largest Lyapunov Exponent vs b')
xlabel('b'); ylabel('LLE')

linkaxes([ax1,ax2],'x')

save("NSNA_bifurcation_and_LLE.mat")