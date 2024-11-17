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

## Dataset Information

The dataset captures all Extended Hospital Stay Fund (EHSG) grant applications submitted since February 2020. Key details include:
- **Application Criteria**:
  - Referral from a hospital professional required.
  - Non-income-based eligibility.
  - Grants are one-time but may allow further assistance requests.
- **Funding Details**:
  - Average grant per applicant: $500–$3,000.
  - Exclusions: Credit card and hospital bills.

## Repository Contents

This repository includes:
1. **R Script**: The analysis script, which explores the foundation's data using advanced statistical techniques such as regression, clustering, and hypothesis testing.
2. **Dataset**: Contains anonymized information on grant applications, amounts requested, amounts granted, and applicant demographics.
3. **Final Report**: An executive summary that outlines key findings and recommendations for Claire's Place Foundation.
4. **README File**: An overview of the project, its goals, and instructions for replicating the analysis.

## Key Findings

1. Over 50% of the total grants (~$183,000) were distributed across five states: California, Florida, Texas, Georgia, and Ohio.
2. Adults tend to request significantly more funds than adolescents, but adolescents, on average, receive marginally higher grant amounts for smaller requests.
3. The foundation predominantly supports low- and middle-income families, covering essential expenses such as rent and mortgages.

## Instructions

### How to Replicate the Analysis:
1. Clone the repository:
   ```bash
   git clone [repository-link]
   ```
2. Install the required R packages:
   ```R
   install.packages(c("readxl", "tidyverse", "moderndive", "infer", "GGally", "lubridate", "glmnet"))
   ```
3. Load the R script (`claires_place_analysis.R`) and run it in RStudio or a similar IDE.
4. Use the dataset (`claires_data.xlsx`) as the input file.

---

We hope this repository serves as a valuable resource for understanding and enhancing the incredible impact of the Claire's Place Foundation. For questions or collaboration opportunities, please reach out to [solisgab@usc.edu](mailto:solisgab@usc.edu).
