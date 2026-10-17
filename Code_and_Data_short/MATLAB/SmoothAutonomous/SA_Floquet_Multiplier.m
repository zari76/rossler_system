clc; close all; clear all; warning off;

% Parameters
a = 0.2;
c = 5.7;
b = 0.8;

% Dimensional scaling;
% R = 10e3;                                                                                                                                                 
% C = 10e-9;
T0 = 1;                       % T0=RC, where R=10kHz and C=10nF

% tolerence settings
opts = odeset('RelTol',1e-6,'AbsTol',1e-6);
initialConditions = [0; 0; 0];   % Initial conditions

%% Find TIme Period
tspan = [0:0.01:2000]*T0;
[t, r] = ode45(@(t, r) rossler_dimensional(t, r, a, c, b, T0), ...
                    tspan, initialConditions, opts);  % Real time in seconds
tol = 0.05;
% Find peaks of x(t)
[pks, locs] = findpeaks(r(:,1),'MinPeakProminence',0.05);
% Remove transient
locs = locs(floor(length(locs)/2):end);

% Plot time series and peaks
figure(1)
plot(t, r(:,1),'r');
hold on
stem(t(locs),r(locs,1), 'bo')
hold off  

r_i = r(locs(1),:);
t_i = t(locs(1));
T = NaN;
for n = 2: length(locs)
    count = locs(n);
    r_n = r(count, :);
    if norm(r_n - r_i) < tol
        T = t(count)-t_i;
        break
    end
end

%% Floquet method

t_ini = t_i;
r_ini = r_i';
tspan = t_ini:0.01*T0:(t_ini + T);

Phi0  = eye(3);                  % initial matrix
Y0 = [r_ini; Phi0(:)];

[t, Y] = ode45(@(t,Y) rossler_floquet_mult(t,Y,a,b,c,T0), tspan, Y0, opts);

Phi_end = reshape(Y(end,4:12), 3,3);   % Phi(t_ini+T)
mu = eig(Phi_end)

theta = linspace(0,2*pi,500);
figure(2);
% Plot unit circle
plot(cos(theta), sin(theta), 'k--', 'LineWidth', 1.5);
hold on;
% Plot multipliers
plot(real(mu), imag(mu), 'ro', ...
    'MarkerSize', 10, ...
    'MarkerFaceColor', 'r');
hold off
xlim([-1,1.01])
xticks([-1 0 1])
yticks([-1 0 1])
grid on
set(gca,'FontSize',26)

%% Modified Rossler System for Floquet Multiplier Calculation
function dY = rossler_floquet_mult(t,Y,a,b,c,T0)
    x = Y(1); y = Y(2); z = Y(3);
    Phi = reshape(Y(4:12),3,3);
    dr = rossler_dimensional(t,[x; y; z],a,c,b,T0);
    J = [0, -1, -1;
         1,  a,  0;
         z,  0,  x-c];
    dPhi = (1/T0) * J * Phi;
    dY = [dr; dPhi(:)];
end

%% Standard Rossler System of equations
function drdt = rossler_dimensional(t, r, a, c, b, T0)
    dx = -r(2) - r(3);
    dy = r(1) + a * r(2);
    sf = 1;
    dz = b/sf+ sf*r(3)*r(1) - r(3)*c;

    drdt = (1/T0) * [dx; dy; dz];
end