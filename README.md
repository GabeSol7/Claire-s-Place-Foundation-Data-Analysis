# Claire's Place Foundation Data Analysis

## Overview of the Project

The **Claire's Place Foundation** is a non-profit organization that provides emotional and financial support to families and individuals affected by cystic fibrosis (CF). This project quantifies the foundation's impact using data from grant applications and highlights opportunities for improving data collection and analysis.

### Key Challenges:
1. How do we effectively quantify the foundation's impact on the CF community?
2. Are we collecting the right information to showcase the foundation's impact?
3. What improvements can be made to enhance future data collection and analysis?

## Goals of Claire's Place Foundation

- **Vision**: Providing emotional and financial support to families living with cystic fibrosis (CF).
- **Mission**: Claire's Place Foundation supports families by raising awareness and providing education, financial assistance, and emotional support.

### Programs:
1. **Extended Hospital Stay Fund**:
   - Grants for essential expenses (e.g., rent, mortgage, groceries) during hospital stays of 14+ consecutive days.
2. **Family Support Program**:
   - Connects CF families to share experiences and support, reducing isolation.
3. **Work Proudly Program**:
   - Provides job training and resources for work-from-home employment to CF adults and caregivers.

## Repository Contents

This repository includes:
1. **`Claire's Place_Analysis.R`**: The R script containing the analysis, which explores the foundation's data using advanced statistical techniques such as regression, clustering, and hypothesis testing.
2. **`Claires_Data_updated(2).xlsx`**: The dataset with anonymized information on grant applications, including amounts requested, amounts granted, and applicant demographics.
3. **`Claires Place_Write Up.pdf`**: An executive summary that outlines key findings and recommendations for Claire's Place Foundation.
4. **`README.md`**: This file provides an overview of the project, its goals, and instructions for replicating the analysis.

## Dataset Information

The dataset captures all Extended Hospital Stay Fund (EHSG) grant applications submitted since February 2020. Key details include:
- **Application Criteria**:
  - Referral from a hospital professional required.
  - Non-income-based eligibility.
  - Grants are one-time but may allow further assistance requests.
- **Funding Details**:
  - Average grant per applicant: $500–$3,000.
  - Exclusions: Credit card and hospital bills.

## Instructions

### How to Replicate the Analysis
1. **Install the required R packages**:
   ```R
   install.packages(c("readxl", "tidyverse", "moderndive", "infer", "GGally", "lubridate", "glmnet"))
   ```
2. **Run the R script**:
   - Open `Claire's Place_Analysis.R` in RStudio or a similar IDE.
   - Ensure `Claires_Data_updated(2).xlsx` is in the working directory.
   - Execute the script step by step to reproduce the analysis.
3. **Review the Outputs**:
   - The script generates statistical summaries, visualizations, and regression models to evaluate the foundation's impact.

## Contact

For questions or collaboration opportunities, please reach out to [solisgab@usc.edu](mailto:solisgab@usc.edu).

---

This README provides a structured overview of the repository and enhances clarity for users replicating the analysis.
