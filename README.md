# Scientific Research: The More, the Merrier? Innovation-Led Sustainable Development.   

This repository contains the dataset and code required to replicate the empirical results presented in the study “The More, the Merrier? Innovation-Led Sustainable Development". Both Stata and R implementations are provided to ensure transparency and facilitate reproducibility across different statistical environments.

## Overviews
The empirical strategy is structured into four main components:

### Part 1: Baseline results
- Conduct a comparative analysis between DKSE and KRLS.
- Examine the impact of Innovation (GII) on Sustainable Development (SDG).
- Analyze the effects of GII’s two main pillars—Innovation Input and Innovation Output—on SDG.
- Investigate the interaction effect of INQ.

### Part 2: Heterogeneity analysis
- Investigate the impact of GII on the 17 SDGs (Goal 1 - Goal 17).
- Analyze the effects of the seven components of the GII on the SDGs.
- Examine how the key relationship varies across income levels and country blocs.

### Part 3: Granger test for non-causality
- Implement Granger non-causality testing between pairs of variables.

### Part 4: Robustness check
- Using another measurement of Sustainable Development and another estimator to ensure the validation of main findings.

## Methods and Data

### Methods:
The research applies advanced econometric approaches:
- Driscoll–Kraay Standard Rrrors (DKSE) (Hainmueller & Hazlett, 2014).
- Kernel Regularized Least Squares (KRLS) (Driscoll & Kraay, 1998).
- Granger Non-causality Test (Xiao et al., 2023).
- Method of Moments Quantile Regression (MMQR) (Machado & Santos Silva, 2019).

### Data:
Clean data are provided in folder `clean_data`:
- File `main_data.dta` is used for Parts 1 and 2.
- File `granger-test_data.dta` is used for Part 3.
- File `robustness-check_data.dta` is used for Part 4.
- Sources: World Intellectual Property Organization (Global Innovation Index), Sustainable Development Report, World Bank.

## Environment

- Stata 17.
- R 4.5.3.

## Contributors

- Dang Minh Nhat.
- Le Hong Ngoc.
- Ho Phuong Uyen.
- Tran Nguyen Hoang Nguyen.
- Tran Thi Ai Van.
- Nguyen Phuc Hung.
- Trinh Minh Quy.

## Contact

For questions or replication issues, please contact:  
- nhatdang0164@gmail.com.
