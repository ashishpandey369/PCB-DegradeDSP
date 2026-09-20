%% PCB-DegradeDSP v0.1 - Trace Spacing Sweep
% Software-only proof of concept.
% This experiment sweeps spacing and visualizes the simulated leakage signal
% and a simple degradation indicator.
%
% IMPORTANT: The physical relationships in v0.1 are assumptions for
% algorithm development. Do not use these results as PCB design limits.

clear; clc; close all;

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

cfg.temperature_C = 25;
cfg.humidity_RH = 50;
cfg.voltage_V = 1;
cfg.duration_s = 600;
cfg.fs_Hz = 10;

spacings_mm = [2.0 1.5 1.0 0.75 0.5 0.25 0.10];

finalDI = zeros(size(spacings_mm));
meanLeakage_uA = zeros(size(spacings_mm));

figure('Name','PCB-DegradeDSP v0.1 - Spacing Sweep');

for k = 1:numel(spacings_mm)
    cfg.spacing_mm = spacings_mm(k);
    cfg.seed = 100 + k;

    [t, current, state] = generateDegradationSignal(cfg);

    finalDI(k) = calculateDegradationIndex(current, cfg.fs_Hz);
    meanLeakage_uA(k) = mean(current(end-round(numel(current)*0.10):end));

    subplot(2,1,1);
    plot(t, current);
    hold on;
    xlabel('Time (s)');
    ylabel('Leakage current (uA)');
    title('Synthetic leakage-current response');
    grid on;

    subplot(2,1,2);
    plot(t, state);
    hold on;
    xlabel('Time (s)');
    ylabel('Simulation degradation state');
    title('Model degradation state');
    grid on;
end

figure('Name','PCB-DegradeDSP v0.1 - Spacing Results');

subplot(2,1,1);
semilogx(spacings_mm, meanLeakage_uA, '-o');
set(gca,'XDir','reverse');
xlabel('Trace spacing (mm)');
ylabel('Late-window leakage (uA)');
title('Spacing vs simulated leakage');
grid on;

subplot(2,1,2);
semilogx(spacings_mm, finalDI, '-o');
set(gca,'XDir','reverse');
xlabel('Trace spacing (mm)');
ylabel('Degradation Index');
title('Spacing vs baseline degradation index');
ylim([0 1]);
grid on;

results = table(spacings_mm(:), meanLeakage_uA(:), finalDI(:), ...
    'VariableNames', {'Spacing_mm','LateLeakage_uA','DegradationIndex'});

disp(results);
