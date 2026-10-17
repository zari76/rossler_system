clc;
close all;
clear;
warning off;

%% Parameters (non-dimensional)

a = 0.2;
c = 5.7;
b = 4.3;
mu = 5;

%% Dimensional scaling

T0 = 1;

%% ODE settings

opts = odeset( ...
    'RelTol',1e-6, ...
    'AbsTol',1e-6);

initialConditions = [0;0;0];

%% Find the period of the orbit

tspan = (0:0.01:2000)*T0;

[t,r] = ode45( ...
    @(t,r) rossler_dimensional(t,r,a,c,b,mu,T0), ...
    tspan,initialConditions,opts);

tol = 0.05;

% Find peaks of x(t)
[~,locs] = findpeaks(r(:,1),'MinPeakProminence',0.05);

% Remove the transient response
locs = locs(floor(length(locs)/2):end);

% Plot the time series and detected peaks
figure(1)
plot(t,r(:,1),'r');
hold on
stem(t(locs),r(locs,1),'bo')
hold off

r_i = r(locs(1),:);
t_i = t(locs(1));

T = NaN;

for k = 2:length(locs)

    r_k = r(locs(k),:);

    if norm(r_k-r_i) < tol
        T = t(locs(k))-t_i;
        break
    end
end

%% Floquet multiplier calculation

t_ini = t_i;
t_end = t_i+T;
r_ini = r_i';

Phi = eye(3);

current_time = t_ini;
current_state = r_ini;

% Number of crossings of x = 3 during one period
number_of_crossings = 2;

event_opts = odeset(opts,...
    'Events',@crossing_event, ...
    'MaxStep',0.01*T0);

for crossing = 1:number_of_crossings

    % State plus 3-by-3 fundamental matrix
    Phi_ini = eye(3);
    t0 = [current_time,t_end];
    Y0 = [current_state;Phi_ini(:)];

    [~,~,te,Ye] = ode45(@(t,Y) rossler_floquet(t,Y,a,b,c,mu,T0), ...
        t0,Y0,event_opts);


    % Smooth variational evolution up to the crossing
    Phi_segment = reshape(Ye(1,4:12),3,3);
    Phi = Phi_segment*Phi;

    % State at the switching surface
    re = Ye(1,1:3)';

    % First-order saltation matrix from Leine's formula
    S = saltation_matrix(re,a,b,c,mu,T0);

    Phi = S*Phi;

    % Determine the side entered after the crossing
    dxe = -re(2)-re(3);

    if dxe > 0
        side_after = 1;
    else
        side_after = -1;
    end

    % Move slightly away from x = 3 before restarting ode45
    dt_restart = 1e-8*T0;

    f_after = rossler_side(re,a,b,c,mu,T0,side_after);

    current_state = re+dt_restart*f_after;
    current_time = te(1)+dt_restart;
end

%% Integrate from the final crossing to the end of the period

Phi_ini = eye(3);
Y0 = [current_state;Phi_ini(:)];

[~,Y_segment] = ode45(@(t,Y) rossler_floquet(t,Y,a,b,c,mu,T0), ...
    [current_time,t_end], Y0, opts);

Phi_segment = reshape(Y_segment(end,4:12),3,3);
Phi_end = Phi_segment*Phi;

mu_eig = eig(Phi_end)

%% Plot Floquet multipliers

theta = linspace(0,2*pi,500);

figure(2)

plot(cos(theta),sin(theta),'k--','LineWidth',1.5);
hold on

plot( ...
    real(mu_eig),imag(mu_eig),'ro', ...
    'MarkerSize',10, ...
    'MarkerFaceColor','r');

hold off

xticks([-1 0 1])
yticks([-1 0 1])
xlabel('$\mathrm{Re}(\rho)$','Interpreter','latex');
ylabel('$\mathrm{Im}(\rho)$','Interpreter','latex');
set(gca,'FontSize',26)
grid on

%% Rössler system and variational equations

function dY = rossler_floquet(t,Y,a,b,c,mu,T0)

    r = Y(1:3);
    Phi = reshape(Y(4:12),3,3);

    dr = rossler_dimensional( ...
        t,r,a,c,b,mu,T0);

    if r(1) < 3
        J = (1/T0)*[ ...
            0,    -1,   -1;
            1,     a,    0;
            r(3),  0,  r(1)-c];
    else
        J = (1/T0)*[ ...
            0,       -1,   -1;
            1,        a,    0;
            r(3)+mu,  0,  r(1)-c];    
    end

    dPhi = J*Phi;

    dY = [dr;dPhi(:)];
end

%% First-order saltation matrix

function S = saltation_matrix( ...
    re,a,b,c,mu,T0)

    % Normal to h(x) = x - 3 = 0
    n = [1;0;0];

    % Direction of crossing
    dxe = -re(2)-re(3);

    if dxe > 0 % means p+
        side_before = -1;
        side_after = 1;
    else % means p-
        side_before = 1;
        side_after = -1;
    end

    f_minus = rossler_side( ...
        re,a,b,c,mu,T0,side_before);

    f_plus = rossler_side( ...
        re,a,b,c,mu,T0,side_after);

    denominator = n'*f_minus;

    % Leine's first-order saltation formula
    S = eye(3)+ ...
        ((f_plus-f_minus)*n')/denominator;
end

%% Event function for x = 3

function [value,isterminal,direction] = crossing_event(~,Y)

    value = Y(1)-3;
    isterminal = 1;
    direction = 0;
end

%% Rössler system on a specified side of x = 3

function drdt = rossler_side(r,a,b,c,mu,T0,side)

    x = r(1);
    y = r(2);
    z = r(3);

    dx = -y-z;
    dy = x+a*y;

    if side < 0
        dz = b+z*x-z*c;
    else
        dz = b+z*x-z*c+mu*x;
    end

    drdt = (1/T0)*[dx;dy;dz];
end


%% Nonsmooth autonomous Rössler system

function drdt = rossler_dimensional(t,r,a,c,b,mu,T0)

    x = r(1);
    y = r(2);
    z = r(3);

    dx = -y-z;
    dy = x+a*y;
    dz = b+z*x-z*c+mu*x*heaviside(x-3);

    drdt = (1/T0)*[dx;dy;dz];
end
