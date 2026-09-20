# v0.1 Model Assumptions

## Purpose

Version 0.1 is a software-only signal-processing prototype. It is designed to test the research workflow before hardware validation.

## Five-trace concept

The future physical test coupon will contain five parallel traces with controlled spacing. v0.1 does not model full electromagnetic or electrochemical physics.

## Simulated inputs

- Trace spacing
- Temperature
- Relative humidity
- Applied low-voltage stimulus
- Observation time
- Sampling frequency

## Simulated output

A synthetic leakage-current waveform in microampere.

## Current degradation model

The prototype uses simple phenomenological relationships:

- Smaller spacing increases a dimensionless stress factor.
- Temperature above 25 C increases the stress factor.
- Relative humidity above 50% increases the stress factor.
- Voltage above 1 V increases the stress factor.
- Degradation accelerates with accumulated stress.
- Leakage current increases as the simulated degradation state increases.
- Intermittent transients become more frequent as degradation increases.

These equations are **not claimed to be a validated ECM lifetime model**.

## Failure criterion

v0.1 uses the simulated degradation state reaching 1 as a software failure criterion. This is not a physical PCB failure threshold.

## Research transition

Later versions should replace these assumptions with:

1. Parameters extracted from published experimental datasets.
2. Experimental measurements from a controlled PCB test coupon.
3. A validated degradation/failure criterion.
4. Statistical uncertainty and confidence intervals.

## Primary research metric

Detection lead time relative to the defined failure criterion.
