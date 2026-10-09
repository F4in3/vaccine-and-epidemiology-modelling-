# Vaccination Coverage and Epidemic Modelling in R

## Overview

This project uses a Susceptible–Infected–Recovered (SIR) model to explore how different levels of vaccination coverage affect infectious disease transmission in a simulated population.

I developed this project during my university biology studies. It demonstrates my experience with R programming, numerical simulation, data transformation, statistical summaries and data visualisation.

This is a simplified mathematical simulation, not a prediction of a real disease outbreak.

## Tools & Libraries

- **R** – Programming and simulation
- **deSolve** – Solving differential equations
- **dplyr** – Data manipulation and summarisation
- **tidyr** – Data reshaping
- **ggplot2** – Data visualisation

## Project Objectives

The project investigates how different vaccination coverage levels influence infectious disease outbreaks.

The analysis focuses on:

- Comparing infection curves across vaccination scenarios.
- Investigating how vaccination coverage influences peak infections.
- Calculating the time until peak infection.
- Comparing the total proportion of the population infected.
- Exploring the theoretical herd immunity threshold.

## Methodology

A deterministic SIR model was implemented using differential equations.

The following parameters were used:

| Parameter | Value |
|---|---|
| Basic reproduction number (R0) | 3 |
| Average infectious period | 7 days |
| Initial infected population | 0.1% |
| Simulation duration | 160 days |
| Simulation time step | 0.1 days |
| Theoretical herd immunity threshold | Approximately 66.7% |

Six vaccination coverage scenarios were selected for detailed comparison: 0%, 30%, 50%, approximately 66.7%, 80% and 90%.

An additional analysis simulated coverage levels from 0% to 95%, in 1% increments.

Individuals vaccinated before the outbreak were assumed to be fully protected and placed in the recovered/removed compartment of the SIR model.

## Analysis and Outputs

**1. Infection Curves**

The first visualisation compares the percentage of the population actively infected over time across different vaccination coverage scenarios.

**2. Vaccination Coverage and Outbreak Severity**

The second visualisation examines how vaccination coverage changes:

- Peak active infections.
- Final epidemic size.

A dashed line indicates the theoretical herd immunity threshold.

**3. Summary Statistics**

The script also calculates a results table containing vaccination coverage, initial effective reproduction number, peak active infections, time to peak and total infections during the simulated outbreak.

## How to Run the Project

1. Install R and optionally RStudio.
2. Download the `vaccine.R` file.
3. Open the script in RStudio.
4. Run the script. It includes commands to install the necessary packages.
5. View the generated graphs and summary table in R.

If the graphs do not appear automatically, run `print(figure_1)` and `print(figure_2)` in the R console after executing the script.

No external datasets are required. The project generates simulated data using the SIR model.

The current script does not automatically export the graphs or results as separate files.

## Limitations

The simulation assumes a homogeneous population and full protection from vaccination at the start of the outbreak. It does not account for differences in age, contact patterns, changes in behaviour or waning immunity.

The results illustrate mathematical model behaviour rather than predicting real-world infection numbers.

## Project Background

This project was originally developed during my undergraduate biology degree and reflects my interest in using programming and quantitative methods to solve scientific problems.

I am sharing it as part of my technical portfolio while pursuing a career in data-related roles.

(PDF of paper wrote using this code attached)
