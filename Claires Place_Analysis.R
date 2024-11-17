# =============================================================================
# Healthcare Grant Analysis: Impact Assessment and Statistical Modeling
# =============================================================================
# Author: Gabriel Solis
# Date: December 2022
# Description: Statistical analysis of healthcare foundation grant data to assess
#              impact and identify key determinants of grant allocation.
# Project Goal: Quantify the impact of the Claire's Place Foundation on the 
#              cystic fibrosis (CF) community through analysis of grant data.
# =============================================================================

# Required Libraries
library(tidyverse)  # For data manipulation and visualization
library(moderndive) # For statistical modeling
library(infer)      # For statistical inference
library(GGally)     # For correlation analysis
library(dplyr)      # For data manipulation
library(lubridate)  # For date handling
library(broom)      # For tidying model outputs

# =============================================================================
# Data Preprocessing and Feature Engineering
# =============================================================================

# Read raw data from Excel file
Claires <- read_excel("Claires_Data_updated(2).xlsx", 2)

# Create categorical variables for demographic analysis
Claires <- Claires %>%
  mutate(
    # Create age categories: Adult (born 2003 or earlier) or Adolescent
    Age_cat = if_else(Birth_year <= 2003, "Adult", "Adolescent"),
    
    # Create income brackets based on reported income levels
    Income_cat = case_when(
      Income <= "$0 - $25,000" ~ "Low",
      Income <= "$26,000 - $51,000" ~ "Medium",
      TRUE ~ "High"
    ),
    
    # Categorize household sizes into meaningful groups
    Household_cat = case_when(
      Household_size <= 2 ~ "Small",   # Singles and couples
      Household_size < 5 ~ "Medium",   # Small families
      TRUE ~ "Large"                   # Large families
    ),
    
    # Convert application dates to monthly periods for temporal analysis
    Month = floor_date(Date_of_application, "month")
  )

# =============================================================================
# Geographic Impact Analysis
# =============================================================================

# Create visualization of application distribution across states
# This helps identify states with highest need/engagement
Claires %>%
  ggplot(aes(x = State)) +
  geom_bar(fill = "purple", color = "white") +
  theme(axis.text.x = element_text(size = 5, angle = 30, hjust = 0.5)) +
  labs(y = "Number of Applications", 
       title = "Geographic Distribution of Grant Applications")

# Analyze relationship between requested and granted amounts
# Simple linear regression to understand grant allocation patterns
lm_arg <- lm(Amount_granted ~ Amount_requested, data = Claires)
summary(lm_arg)

# Visualize relationship between requested and granted amounts
# Remove outliers for better visualization
Claires %>%
  filter(Amount_requested != 16309.64 & Amount_requested != 28060.00) %>%
  ggplot(aes(x = Amount_requested, y = Amount_granted)) +
  geom_point(color = "purple") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(x = "Amount Requested ($)", 
       y = "Amount Granted ($)", 
       title = "Relationship Between Requested and Granted Amounts")

# =============================================================================
# Statistical Inference: Age-Based Analysis
# =============================================================================

# Hypothesis Test: Do adults request different amounts than adolescents?
# H0: No difference in mean requested amounts between adults and adolescents
# H1: Adults request different amounts than adolescents

# Calculate observed statistic
obs_stat_ar <- Claires %>%
  filter(!is.na(Amount_requested)) %>%
  specify(Amount_requested ~ Age_cat) %>%
  calculate(stat = "diff in means", order = c("Adult", "Adolescent"))

# Generate null distribution through permutation
null_dist_ar <- Claires %>%
  filter(!is.na(Amount_requested)) %>%
  specify(Amount_requested ~ Age_cat) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 5000) %>%
  calculate(stat = "diff in means", order = c("Adult", "Adolescent"))

# Calculate p-value and visualize results
p_value <- get_p_value(null_dist_ar, obs_stat_ar, direction = "right")
visualize(null_dist_ar) +
  shade_p_value(obs_stat_ar, direction = "right") +
  ggtitle("Hypothesis Test: Difference in Requested Amounts by Age")

# =============================================================================
# Advanced Modeling: Interaction Effects
# =============================================================================

# Examine how age category moderates the relationship between 
# requested and granted amounts
lm_argc <- lm(Amount_granted ~ Amount_requested * Age_cat, data = Claires)
summary(lm_argc)

# Visualize interaction effects
Claires %>%
  filter(Amount_requested != 16309.64 & Amount_requested != 28060.00) %>%
  ggplot(aes(x = Amount_requested, y = Amount_granted, color = Age_cat)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~Age_cat) +
  labs(x = "Amount Requested ($)", 
       y = "Amount Granted ($)", 
       title = "Age-Based Differences in Grant Allocation Patterns")

# =============================================================================
# Geographic Impact Assessment
# =============================================================================

# Calculate state-level impact metrics
Impact_ag_state <- Claires %>%
  filter(!is.na(Amount_granted)) %>%
  group_by(State) %>%
  summarize(
    mean_ag = mean(Amount_granted, na.rm = TRUE),    # Average grant per state
    total_grants = sum(Amount_granted, na.rm = TRUE), # Total impact per state
    n = n()                                          # Number of applications
  ) %>%
  arrange(desc(total_grants))

# Visualize top 5 states by total grant amount
Impact_ag_state %>%
  top_n(5, total_grants) %>%
  ggplot(aes(x = reorder(State, total_grants), y = total_grants, fill = State)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(x = "State", 
       y = "Total Grants ($)", 
       title = "States with Highest Grant Allocation") +
  scale_fill_brewer(palette = "Set1")

# =============================================================================
# Correlation Analysis
# =============================================================================

# Examine relationships between key numeric variables
cor_matrix <- Claires %>%
  select(Birth_year, Household_size, Amount_requested, Amount_granted) %>%
  cor(use = "complete.obs")  # Handle missing values

print(cor_matrix)

# =============================================================================
# Bootstrap Analysis for Robust Inference
# =============================================================================

# Generate bootstrap distribution for age-based differences
# This provides more robust inference than traditional t-tests
boot_dist_ar <- Claires %>%
  filter(!is.na(Amount_requested)) %>%
  specify(Amount_requested ~ Age_cat) %>%
  generate(reps = 5000) %>%  # 5000 bootstrap resamples
  calculate(stat = "diff in means", order = c("Adult", "Adolescent"))

# Calculate confidence interval from bootstrap distribution
ci_boot_ar <- get_confidence_interval(boot_dist_ar, type = "percentile")
print(ci_boot_ar)

# Visualize bootstrap distribution with confidence interval
visualize(boot_dist_ar) +
  shade_confidence_interval(ci_boot_ar) +
  labs(title = "Bootstrap Distribution of Age-Based Differences in Requests")

# =============================================================================
# Income-Based Analysis with Interactions
# =============================================================================

# Examine how income level moderates grant allocation
lm_income <- lm(Amount_granted ~ Amount_requested * Income_cat, data = Claires)
summary(lm_income)

# Visualize income-based differences in grant allocation
Claires %>%
  filter(!is.na(Income_cat)) %>%
  ggplot(aes(x = Amount_requested, y = Amount_granted, color = Income_cat)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~Income_cat) +
  labs(x = "Amount Requested ($)", 
       y = "Amount Granted ($)", 
       title = "Grant Allocation Patterns by Income Level")

# =============================================================================
# Multivariate Analysis and Model Diagnostics
# =============================================================================

# Comprehensive model including multiple predictors
lm_multi <- lm(Amount_granted ~ Amount_requested + Household_size + State, 
               data = Claires)
summary(lm_multi)

# Generate diagnostic information
residuals_multi <- augment(lm_multi)

# Create diagnostic plots
residuals_multi %>%
  ggplot(aes(.fitted, .resid)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  labs(
    x = "Fitted Values",
    y = "Residuals",
    title = "Model Diagnostics: Residuals vs Fitted Values"
  ) +
  theme_minimal()

# =============================================================================
# Time Series Analysis of Grant Allocation
# =============================================================================

# Calculate monthly grant totals
grants_over_time <- Claires %>%
  group_by(Month) %>%
  summarize(total_grants = sum(Amount_granted, na.rm = TRUE))

# Visualize temporal patterns in grant allocation
grants_over_time %>%
  ggplot(aes(x = Month, y = total_grants)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red") +
  labs(x = "Month", 
       y = "Total Grants ($)", 
       title = "Temporal Trends in Grant Allocation")

# =============================================================================
# Category-Based Impact Analysis
# =============================================================================

# Analyze distribution of grants across top categories
top_categories <- Claires %>%
  filter(Category %in% c("Rent", "Mortgage", "Electric", "Auto", "Phone")) %>%
  group_by(Category) %>%
  summarize(total_grants = sum(Amount_granted, na.rm = TRUE))

# Create pie chart of category distribution
top_categories %>%
  ggplot(aes(x = "", y = total_grants, fill = Category)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(title = "Distribution of Grants by Category", 
       fill = "Category") +
  theme_void()

# =============================================================================
# Cluster Analysis: Identifying Grant Patterns
# =============================================================================

library(cluster)

# Prepare data for clustering analysis
cluster_data <- Claires %>%
  filter(!is.na(Household_size) & !is.na(Amount_granted)) %>%
  select(Household_size, Amount_granted)

# Perform k-means clustering to identify patterns
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(cluster_data, centers = 3)

# Add cluster assignments to data
cluster_data <- cluster_data %>%
  mutate(Cluster = as.factor(kmeans_result$cluster))

# Visualize clustering results
k_means <- cluster_data %>%
  ggplot(aes(x = Household_size, y = Amount_granted, color = Cluster)) +
  geom_point(size = 2) +
  labs(title = "Grant Pattern Clusters by Household Size", 
       x = "Household Size", 
       y = "Amount Granted ($)")

k_means
