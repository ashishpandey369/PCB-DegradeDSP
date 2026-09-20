function [t, current, state] = generateDegradationSignal(cfg)
%GENERATEDEGRADATIONSIGNAL Generate a synthetic PCB leakage-current signal.
%
% This is a research simulation model, NOT a validated physical ECM model.
% The model is intentionally modular so it can later be replaced/calibrated
% with experimental measurements.
%
% Inputs:
%   cfg.spacing_mm
%   cfg.temperature_C
%   cfg.humidity_RH
%   cfg.voltage_V
%   cfg.duration_s
%   cfg.fs_Hz
%   cfg.seed
%
% Outputs:
%   t       - time vector
%   current - simulated leakage current in microampere
%   state   - normalized degradation state (0 healthy -> 1 failure)

arguments
    cfg.spacing_mm (1,1) double {mustBePositive}
    cfg.temperature_C (1,1) double
    cfg.humidity_RH (1,1) double {mustBeGreaterThanOrEqual(cfg.humidity_RH,0),mustBeLessThanOrEqual(cfg.humidity_RH,100)}
    cfg.voltage_V (1,1) double {mustBeNonnegative}
    cfg.duration_s (1,1) double {mustBePositive}
    cfg.fs_Hz (1,1) double {mustBePositive}
    cfg.seed (1,1) double = 1
end

rng(cfg.seed);

n = floor(cfg.duration_s * cfg.fs_Hz) + 1;
t = (0:n-1)' / cfg.fs_Hz;

% Dimensionless stress factors. These are deliberately simple assumptions
% for v0.1 and must be calibrated against real/literature data later.
spacingFactor = (1 / cfg.spacing_mm)^0.70;
temperatureFactor = exp(0.025 * max(cfg.temperature_C - 25, 0));
humidityFactor = 1 + 0.020 * max(cfg.humidity_RH - 50, 0);
voltageFactor = 1 + 0.12 * max(cfg.voltage_V - 1, 0);

stress = spacingFactor * temperatureFactor * humidityFactor * voltageFactor;

% Normalize stress to keep v0.1 signals numerically well behaved.
stressNorm = stress / (1 + stress);

% Degradation accelerates gradually as stress increases.
baseRate = 0.015 + 0.12 * stressNorm;
state = min(1, (t / cfg.duration_s).^1.7 * baseRate / max(baseRate, 0.001));

% Baseline leakage rises with degradation.
baseline_uA = 0.8 + 7.0 * state.^1.8;

% Increasing low-frequency drift.
drift = (0.03 + 0.15 * state) .* sin(2*pi*0.15*t);

% Degradation-related intermittent transients.
eventRate = 0.05 + 1.5 * state.^2;
eventProb = min(eventRate / cfg.fs_Hz, 0.5);
events = rand(n,1) < eventProb;

eventAmplitude = (0.5 + 4.0 * state) .* abs(randn(n,1));
transients = events .* eventAmplitude;

% Measurement noise.
noiseStd = 0.05 + 0.10 * state;
noise = noiseStd .* randn(n,1);

current = max(0, baseline_uA + drift + transients + noise);

% Define the simulated physical failure point as the first time the
% degradation state reaches 1. This is a simulation convention.
if any(state >= 1)
    state = min(state,1);
end
end
