# Experimental Investigation of Nonlinear Phenomena in Rössler Systems

This repository contains MATLAB scripts, PSIM circuit models and supporting data associated with the manuscript 

## Repository structure

```text
.
├── MATLAB/
│   ├── SmoothAutonomous/
│   ├── SmoothNonautonomous/
│   ├── NonsmoothAutonomous/
│   └── NonsmoothNonautonomous/
├── PSIM/
│   ├── SA_data/
│   ├── SNA_data/
│   ├── NSA_data/
│   ├── NSNA_data/
│   ├── [PSIM schematic for SA]
│   ├── [PSIM schematic for SNA]
│   ├── [PSIM schematic for NSA]
│   └── [PSIM schematic for NSNA]
├── ExperimentalData/
│   └── LLE/
│       └── [LLE and bif_num data for four cases]
└── README.md
```

The schematic filenames above are placeholders: the repository contains one PSIM schematic for each case. The actual filenames should be used when following the instructions below.

## Mathematical models

All four systems share

\[
\dot{x}=-y-z,\qquad \dot{y}=x+ay.
\]

The third equation differs between cases:

**Smooth autonomous (SA)**

\[
\dot{z}=b+z(x-c).
\]

**Smooth nonautonomous (SNA)**

\[
\dot{z}=b+z(x-c)+A\sin(\omega t).
\]

**Nonsmooth autonomous (NSA)**

\[
\dot{z}=\begin{cases}b+z(x-c)+\mu x,&x\geq 3,\\b+z(x-c),&x<3.\end{cases}
\]

**Nonsmooth nonautonomous (NSNA)**

\[
\dot{z}=\begin{cases}b+z(x-c)+\mu x+A\sin(\omega t),&x\geq 3,\\b+z(x-c)+A\sin(\omega t),&x<3.\end{cases}
\]

The parameters used in the study are \(a=0.2\), \(c=5.7\), \(\mu=5\), \(A=3\) and \(\omega=3\), with \(b\) varied to investigate changes in the dynamics. Consult the individual scripts and manuscript for case-specific ranges, initial conditions, numerical tolerances and experimental settings.

## Contents

### MATLAB

The four subfolders contain numerical scripts associated with each Rössler variant. These support numerical investigations such as trajectories, phase portraits, bifurcation behaviour and stability analysis, where implemented in the supplied files.

### PSIM

The four schematic files correspond to the SA, SNA, NSA and NSNA electronic circuit models. The `SA_data`, `SNA_data`, `NSA_data` and `NSNA_data` folders contain the associated PSIM data. Use the matching schematic and data folder for each case.

### ExperimentalData

The `LLE` folder contains files described by the authors as LLE and `bif_num` data for the four cases. **Check each file's provenance before publication:** numerical bifurcation or LLE results should not be labelled as raw experimental measurements. Add any raw experimental data needed to reproduce the manuscript's experimental results, or document their repository location.

## Software

- MATLAB, for numerical simulations and analysis.
- PSIM, for electronic circuit simulations.
- Software capable of reading the supplied experimental data formats (for example MATLAB or a spreadsheet program, depending on the files).

## How to reproduce the results

1. Download or clone this repository, retaining its directory structure.
2. For a selected case, open the corresponding folder under `MATLAB/` and identify its main script. Run it in MATLAB with the required supporting functions on the MATLAB path.
3. To reproduce circuit simulation results, open the corresponding PSIM schematic and use the matching `PSIM/*_data/` folder where applicable.
4. To inspect the supplied LLE and bifurcation data, locate the relevant case files in `ExperimentalData/LLE/` and load them using their native format.
5. Compare the outputs with the corresponding plots and parameter settings in the manuscript.

## Data and code availability

The code, circuit schematics and supporting data in this repository are intended to support reproduction of the results reported in the associated manuscript. For a permanent, citable record, archive a tagged release in a research repository such as Zenodo and include its DOI in the manuscript and ScholarOne data access statement.

## Contact

For questions about reproducing the results, contact the corresponding author through the published manuscript.
