#########################################
# Setting up SiMMMulator
#########################################

# If you don't have remotes installed yet, first run this line: 
install.packages("remotes") 

# install siMMMulator 
remotes::install_github(
  repo = "facebookexperimental/siMMMulator"
)

library(siMMMulator)

#########################################
# Define basic params
#########################################

# Currency in Rupiahs
options(scipen=999)

my_variables <- step_0_define_basic_parameters(years = 3,
                                               channels_impressions = c("Instagram", 'TikTok'),
                                               channels_clicks = c("Search"),
                                               frequency_of_campaigns = 2,
                                               true_cvr = c(0.003, 0.001, 0.003),
                                               revenue_per_conv = 20000, 
                                               start_date = "2022/1/1"
)

df_baseline <- step_1_create_baseline(
  my_variables = my_variables,
  base_p = 5000000,
  trend_p = 2,
  temp_var = 8,
  temp_coef_mean = 300000,
  temp_coef_sd = 50000,
  error_std = 1000000)

optional_step_1.5_plot_baseline_sales(df_baseline = df_baseline)

#Generate ad spend
df_ads_step2 <- step_2_ads_spend(
  my_variables = my_variables,
  campaign_spend_mean = 500000,
  campaign_spend_std = 100000,
  max_min_proportion_on_each_channel <- c(0.45, 0.50,  # 45-50% of campaign spend to ch 1 (ig), 
                                          0.30, 0.35)  # 30-35% to ch 2 (tt), 
                                          #0.05, 0.20) #  the rest to ch 3
)

optional_step_2.5_plot_ad_spend(df_ads_step2 = df_ads_step2)

# Generate media
df_ads_step3 <- step_3_generate_media(
  my_variables = my_variables,
  df_ads_step2 = df_ads_step2,
  true_cpm = c(50000, 30000, NA),
  true_cpc = c(NA, NA, 5000),
  mean_noisy_cpm_cpc = c(0.02, 0.02, 0.01),
  std_noisy_cpm_cpc = c(0.01, 0.02, 0.01)
)

df_ads_step4 <- step_4_generate_cvr(
  my_variables = my_variables,
  df_ads_step3 = df_ads_step3,
  mean_noisy_cvr = c(0.0001, 0.0001, 0.0002), 
  std_noisy_cvr = c(0.001, 0.002, 0.003)
)

# Transforming Media Variables
df_ads_step5a_before_mmm <- step_5a_pivot_to_mmm_format(
  my_variables = my_variables,
  df_ads_step4 = df_ads_step4
)

# Apply adstock
df_ads_step5b <- step_5b_decay(
  my_variables = my_variables,
  df_ads_step5a_before_mmm = df_ads_step5a_before_mmm,
  true_lambda_decay = c(0.35, 0.3, 0.15)
)

# Apply diminishing returns to media variables
df_ads_step5c <- step_5c_diminishing_returns(
  my_variables = my_variables,
  df_ads_step5b = df_ads_step5b,
  alpha_saturation = c(0.8, 0.7, 0.9),
  gamma_saturation = c(0.35, 0.28, 0.3)
# x_marginal = NULL # When provided, the function returns the Hill-transformed value of the x_marginal input. Warnings not harmful. 
  
)

# Calculate conversions
df_ads_step6 <- step_6_calculating_conversions(
  my_variables = my_variables,
  df_ads_step5c = df_ads_step5c
)

# Expand df
df_ads_step7 <- step_7_expanded_df(
  my_variables = my_variables,
  df_ads_step6 = df_ads_step6,
  df_baseline = df_baseline
)

# Calculate ROI
step_8_calculate_roi(
  my_variables = my_variables,
  df_ads_step7 = df_ads_step7
)

# Get final dfs
list_of_df_final <- step_9_final_df(
  my_variables = my_variables,
  df_ads_step7 = df_ads_step7
)

daily_df <- list_of_df_final[[1]]
weekly_df <- list_of_df_final[[2]]

getwd()
setwd("")
write.csv(daily_df, file = "./daily_df.csv", row.names = FALSE)
write.csv(weekly_df, file = "./weekly_df.csv", row.names = FALSE)

optional_step_9.5_plot_final_df(df_final = list_of_df_final[[1]]) # for daily data
optional_step_9.5_plot_final_df(df_final = list_of_df_final[[2]]) # for weekly data
