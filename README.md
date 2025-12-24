# ⚡ Harry Potter Franchise: Statistical Analysis & ROI Prediction

A statistical project that analyzes the financial success and critical reception of the Harry Potter film franchise. 

This project goes beyond simple data visualization by employing **Parametric and Non-Parametric Bootstrap methods** to estimate confidence intervals for Return on Investment (ROI) and using **Linear Regression** to predict future performance based on budget and runtime.

## Project Overview

The goal of this study is to define "success" not just by Box Office revenue, but by analyzing profitability (ROI) and public reception.

**Key Questions Answered:**
* Which movie was the most profitable relative to its budget?
* Which movie was the most "liked" by critics?
* Is there a correlation between Budget, Box Office, and Critical Ratings?
* Can we predict the ROI of a film using a Linear Regression model?

## Technologies & Methods

* **Language:** R
* **Libraries:** `readxl`, `dplyr`
* **Statistical Methods:**
    * **Non-Parametric Bootstrap:** Used to estimate the distribution of the "most successful" film and the mean ROI of the saga.
    * **Parametric Bootstrap:** Used to validate the stability of coefficients in a Linear Regression model.
    * **Correlation Analysis:** Pearson correlation coefficient.
    * **Linear Regression:** Modeling ROI ~ Budget + Release Year + Runtime.

## Repository Structure

* `final_adc.R`: The main R script containing all statistical computations, simulations (1000 replications), and visualizations.
* `Final_project_ADC.pdf`: The detailed academic report explaining the methodology and conclusions.
* `movies.csv` (Dataset): Contains data on Budget, Box Office, Runtime, and Release Year for all 8 films.

## Key Findings

Based on the analysis performed in `final_adc.R`:

1.  **The "Most Profitable" vs. "Most Successful":**
    * While *Harry Potter and the Deathly Hallows Part 2* had the highest absolute Box Office, the bootstrap analysis suggests *Harry Potter and the Chamber of Secrets* often appears as the most **profitable** (highest ROI) due to its lower budget.
    * However, when combining ROI and Critical Rating into a weighted score, the finale (*Deathly Hallows Part 2*) is the clear winner.

2.  **Correlations:**
    * There is a strong positive correlation (~0.64) between **Budget** and **Box Office**.
    * Interestingly, Critics' Ratings also showed a positive correlation with the Release Year, suggesting the movies improved over time.

3.  **ROI Estimation:**
    * The mean ROI for the entire saga is approximately **6.17** (for every $1 spent, the franchise earned ~$6.17).

## How to Run

1.  Clone the repository.
2.  Open `final_adc.R` in RStudio.
3.  **Important:** Update the file path in line 3 to point to your local dataset:
    ```r
    # Change this line to your local path
    dataset = read_excel("./path/to/movies.csv")
    ```
4.  Run the script to generate the plots and bootstrap simulations.

## Author

**Nerea de la Torre Veguillas**
Universitat Autònoma de Barcelona | Matemàtica Computacional i Analítica de Dades
