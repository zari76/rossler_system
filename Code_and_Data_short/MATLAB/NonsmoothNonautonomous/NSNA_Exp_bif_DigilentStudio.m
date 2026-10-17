clc;
close all;
clear;
warning off;

daqreset

%% Discover Digilent device
daqlist("digilent");
dq = daq("digilent");

addinput(dq, "ADStudio_0", "ai0", "Voltage");
addinput(dq, "ADStudio_0", "ai1", "Voltage");
ch_in = dq.Channels(1:2);
ch_in(1).Name = "V1";
ch_in(2).Name = "V2";

addoutput(dq, "ADStudio_0", "ao0", "Voltage");
addoutput(dq, "ADStudio_0", "ao1", "Voltage");
ch_out = dq.Channels(3:4);
ch_out(1).Name = "b";
ch_out(2).Name = "Vin";

%% Sampling rate
rate = 200e3;
dq.Rate = rate;

f = 4.42e3;
totalduration = 200e-3;
n = totalduration * rate;
t = (1:n)/rate;
waveGen = 3*sin(2*pi*f*t)';

%% Test phase portrait for a test value of b
b = 1;

[data, startTime] = readwrite(dq, [-b*ones(size(waveGen)),waveGen]);

% CH1 = x(t), CH2 = y(t)
t = seconds(data.Time - data.Time(1));
x_variable = data.V1;
y_variable = data.V2;

% Use last 10% of data (same logic as original code)
tstart = round(0.8*length(t));
tend = round(0.9*length(t));

t = t(tstart:tend);
x_variable = x_variable(tstart:tend,1);
y_variable = y_variable(tstart:tend,1);

figure(1)
plot(x_variable,y_variable)



%% Bifurcation parameter values
b_values = [0.9:0.01:5, 0.1:0.01:0.89];

%% Storage
pks_array = [];

%% Bifurcation loop
for b = b_values                                                                                                                               

    fprintf('b = %.2f\n', b);

    [data, startTime] = readwrite(dq, [-b*ones(size(waveGen)),waveGen]);

    % CH1 = x(t), CH2 = y(t)
    t = seconds(data.Time - data.Time(1));
    x_variable = data.V1;
    y_variable = data.V2;
    
    % Use last 10% of data (same logic as original code)
    tstart = round(0.8*length(t));
    tend = round(0.9*length(t));

    t = t(tstart:tend);
    x_variable = x_variable(tstart:tend,1);
    y_variable = y_variable(tstart:tend,1);

    % Peak detection
    [pks,~] = findpeaks(x_variable);
    pks = uniquetol(pks,0.02);
    b_array = b*ones(size(pks));
    pks_array = [pks_array; b_array pks];
end
                                                                                                                                                        
%% Bifurcation plot            
figure(1)
scatter(pks_array(:,1),pks_array(:,2),5,'r','filled')
xlabel('Parameter b')
ylabel('x')
title('Experimental Bifurcation Diagram')
grid on

%% Release hardware
daqreset