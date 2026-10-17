%% Rossler smooth autononomous sytem
% Plotting bifurcation diagram, and/or time series + phase portraits

clc; close all; clear all; warning off;

% Parameters
a = 0.2;
c = 5.7;

% Dimensional scaling;
R = 10e3;
C = 10e-9;
T0 = R*C;                       % T0=RC, where R=10kHz and C=10nF
tspan = [0 2000]*T0;

% Tolerence settings
opts = odeset('RelTol',1e-6,'AbsTol',1e-6);

initialConditions = [0; 0; 0];   % Initial conditions
pks_array = [];
b_values = 0.1:0.1:5;

for b = b_values
    [t, r] = ode45(@(t, r) rossler_dimensional(t, r, a, c, b, T0), ...
                        tspan, initialConditions, opts);  % Real time in seconds

    x_variable = r(round(0.9*length(t)):end, 1);

    [pks, ~] = findpeaks(x_variable);
    pks = uniquetol(pks, 0.02);

    b_array = b * ones(size(pks));
    pks_array = [pks_array; b_array pks];

    initialConditions = r(end, :);
    if any(isnan(initialConditions))
        initialConditions = [0, 0, 0];
    end
end

%% Time series and phase portraits 
% (for single value of b)

% plot time series
figure(1);
subplot(3,1,1)
plot(t,r(:,1))
xlabel('t_{dim}'); ylabel('x(t_{dim})');
xlim([1900 2000]*T0)
title('Time series plot for x(t_{dim}) with dimensional system');
grid on;
subplot(3,1,2)
plot(t,r(:,2))
xlabel('t_{dim}'); ylabel('y(t_{dim})');
xlim([1900 2000]*T0)
title('Time series plot for y(t_{dim}) with dimensional system');
grid on;
subplot(3,1,3)
plot(t,r(:,3))
xlabel('t_{dim}'); ylabel('z(t_{dim})');
xlim([1900 2000]*T0)
title('Time series plot for z(t_{dim}) with dimensional system');
grid on;

% plot phase portraits
figure(2)
plot(r(t>1700*T0,1),r(t>1700*T0,2), 'b', 'LineWidth',1)
xlabel('x(t)'); ylabel('y(t)');
title(['Phase portrait at b=',num2str(b)]);
grid on;
hold off


%% Bifurcation
% (for range of b_values)

figure(3)
scatter(pks_array(:,1), pks_array(:,2), 5, 'b', 'filled')
xlabel('Parameter b'); ylabel('x');
title('Bifurcation with b');
grid on;


%% System of equations with scaling
function drdt = rossler_dimensional(t, r, a, c, b, T0)
    dx = -r(2) - r(3);
    dy = r(1) + a * r(2);
    sf = 2.5;
    dz = b/sf+ sf*r(3)*r(1) - r(3)*c;

    drdt = (1/T0) * [dx; dy; dz];
end