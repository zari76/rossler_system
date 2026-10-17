clc;
close all;
clear;
warning off;

daqreset

%% Discover Digilent device
daqlist("digilent");

%% Output DAQ (W1 = bifurcation parameter)
dq_out = daq("digilent");
addoutput(dq_out,"ADStudio_0","ao0","Voltage");

%% Input DAQ (CH1 = X, CH2 = Y)
dq_in = daq("digilent");

addinput(dq_in,"ADStudio_0","ai0","Voltage"); % X
addinput(dq_in,"ADStudio_0","ai1","Voltage"); % Y

%% Sampling rate
systemRate = 1e8;      % 100 MHz
rDiv = uint32(1000);
dq_in.Rate = systemRate/rDiv;   % 100 kHz

%% Bifurcation parameter values
b_values = 0.1:0.01:5;

%% Storage
pks_array = [];

%% Bifurcation loop
for b = b_values

    fprintf('b = %.4f\n', b);

    % Set bifurcation parameter through W1
    write(dq_out, -b);

    % Settling time
    % pause(5);

    % Acquire 1 second of experimental data
    [data,startTime] = read(dq_in, milliseconds(200));

    % CH1 = x(t)
    x_variable = data.ADStudio_0_ai0;

    % Use last 10% of data (same logic as original code)
    x_variable = x_variable(round(0.9*length(x_variable)):end);

    % Peak detection
    [pks,~] = findpeaks(x_variable);

    % Remove nearly identical peaks
    pks = uniquetol(pks,0.02);

    % Store bifurcation data
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