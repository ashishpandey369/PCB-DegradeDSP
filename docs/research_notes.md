# Research Notes

## Working hypothesis

A combination of time-domain, frequency-domain, and time-frequency features extracted from a leakage-current signal may detect progressive PCB degradation earlier than a conventional absolute-current threshold.

## Physical phenomenon

The initial physical reference is electrochemical migration (ECM) in PCB interconnects. ECM is an established reliability failure mechanism involving electrically biased conductors, moisture/electrolyte conditions, ion transport, and dendritic conductive growth.

## Simulation-first policy

The first implementation will use synthetic signals whose behavior is explicitly documented as a model assumption. We will keep the signal generator modular so it can later be calibrated or replaced with real measurements.

## Key evaluation metric

**Detection lead time** relative to a defined failure criterion.

Additional metrics:

- False alarm rate
- Sensitivity
- Specificity
- Precision
- F1 score
- Robustness to measurement noise
- Stability across randomized runs

## RUL terminology

Use:

- Time-to-Failure (TTF)
- Remaining Useful Life (RUL)
- Degradation Index (DI)

Avoid presenting a simulation as a guaranteed real-world PCB lifespan prediction.

## Future hardware validation

Potential architecture:

PCB test coupon -> controlled low-voltage stimulus/current measurement -> ADC/ESP32 or DAQ -> CSV -> MATLAB DSP pipeline

The hardware phase is planned only after the software methodology is stable.
