%% Rosssler smooth nonautonomous system
% Plot bifurcation and/or time series + phase portrait

clc; close all; clear all; warning off;

% Parameters
a = 0.2;
c = 5.7;
A = 3;
omega = 3;

% Dimensional scaling;
R = 10e3;
C = 10e-9;
T0 = R*C;                       % T0=RC, where R=10kHz and C=10nF
omega_dim = omega / T0;   % dimensional frequency
f_dim  = omega_dim/(2*pi);
tspan = [0 2000]*T0;

% tolerence settings
opts = odeset('RelTol',1e-6,'AbsTol',1e-6,'MaxStep',1e-5);

initialConditions = [0; 0; 0];   % Initial conditions
pks_array = [];
b_values = 0.1:0.1:5;
   
for b = b_values
    [t_dim, r] = ode45(@(t_dim, r) rossler_dimensional(t_dim, r, a, A, omega_dim, c, b, T0), ...
        tspan, initialConditions, opts);  % Real time in seconds

    x_variable = r(round(0.9*length(t_dim)):end, 1);

    [pks, ~] = findpeaks(x_variable);
    pks = uniquetol(pks, 0.01);

    b_array = b * ones(size(pks));
    pks_array = [pks_array; b_array pks];

    initialConditions = r(end, :);
     if any(isnan(initialConditions))
       initialConditions = [0, 0, 0];
    end
end

%% Time series and phase portrait

% plot time series
figure(1);
subplot(3,1,1)
plot(t_dim,r(:,1))
xlabel('t_{dim}'); ylabel('x(t_{dim})');
xlim([1500 2000]*T0)
title('Time series plot for x(t_{dim}) with dimensional system');
grid on;
subplot(3,1,2)
plot(t_dim,r(:,2))
xlabel('t_{dim}'); ylabel('y(t_{dim})');
xlim([1500 2000]*T0)
title('Time series plot for y(t_{dim}) with dimensional system');
grid on;
subplot(3,1,3)
plot(t_dim,r(:,3))
xlabel('t_{dim}'); ylabel('z(t_{dim})');
xlim([1500 2000]*T0)
title(['Time series plot for z(t_{dim}) with dimensional system']);
grid on;

% plot phase portraits
figure(2)
plot(r(t_dim>1500*T0,1),r(t_dim>1500*T0,2), 'b', 'LineWidth',1)
xlabel('x(t_{dim})'); ylabel('y(t_{dim})');
title(['Phase portrait at b=',num2str(b)]);
grid on;

%% Bifurcation
figure(3)
scatter(pks_array(:,1), pks_array(:,2), 5, 'b', 'filled')
xlabel('Parameter b'); ylabel('x');
title(['Bifurcation with A=',num2str(A),' and \omega_{dim}=',num2str(omega_dim,4),' rad/s']);
grid on;


%% System of equations
function drdt_real = rossler_dimensional(t_dim, r, a, A, omega_dim, c, b, T0)
dx = -r(2) - r(3);
dy = r(1) + a * r(2);
sf =1;
 dz = b/sf+ sf*r(3)*r(1) - r(3)*c + A/sf*sin(omega_dim*t_dim);


drdt_real = (1/T0) * [dx; dy; dz];
end


