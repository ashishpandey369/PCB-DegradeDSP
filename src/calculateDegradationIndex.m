function DI = calculateDegradationIndex(current, fs_Hz)
%CALCULATEDEGRADATIONINDEX Simple v0.1 signal-based degradation index.
%
% Combines normalized RMS, variance and trend. This is a baseline DSP
% indicator; FFT/wavelet features will be added in later versions.

current = current(:);

rmsValue = sqrt(mean(current.^2));
varianceValue = var(current);

x = (1:numel(current))';
p = polyfit(x, current, 1);
slopeValue = p(1) * fs_Hz;

% Robust normalization for the initial prototype.
rmsScore = min(rmsValue / 10, 1);
varianceScore = min(varianceValue / 5, 1);
slopeScore = min(abs(slopeValue) / 0.05, 1);

DI = min(1, 0.4*rmsScore + 0.3*varianceScore + 0.3*slopeScore);
end
