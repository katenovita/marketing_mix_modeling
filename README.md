# Marketing Mix Modelling using Meta's Robyn

## Executive Summary
Marketing Mix Modeling (MMM) analysis for a new bakery business that my sister just launched to optimize marketing budget allocation across digital channels that my sister planned to use (*Intagram*, *TikTok*, *Search*).\
Using Meta's `Robyn` framework with 2 years of simulated data (Jan 2022 - Dec 2024, simulated using Meta's `SiMMMulator` package in R), 
this project aims to identify the most effective channels and optimal spend distribution to maximize the bakery's revenue.

Key Findings:

- Model Performance: R² = 73.4% (decent but obviously need to improve as it excludes many external factors)
- Best overall channel by mean ROAS: *TikTok* (7) - highest overall return, where allocating more to TikTok may drive a little bit more uptake
- Budget optimization opportunity: Cut spending 30% across all channels to improve overall ROAS from 5.98 to 8.07; less spending yields better efficiency without significantly hurting revenue

## Business Problem

My sister is launching a new bakery business and needs to allocate limited marketing budget efficiently across digital channels.

Challenge:
- Which channels (Instagram, TikTok, Search) deliver best ROI?
- How much should we spend on each channel?

Goal:
Build data-driven marketing strategy to maximize sales with optimized channel allocation.

## Methodology
### 1. Data Simulation
Framework: [SiMMMulator](https://facebookexperimental.github.io/siMMMulator/) (open-source package in R by Meta)\
This is a new business with no historical data, so I used Meta's `SiMMMulator` to create realistic marketing scenarios.

Simulation Parameters:

Time Period: Jan 2022 - Dec 2024 (156 weeks)\
Channels: Instagram, TikTok, Search (Google Ads)\
Granularity: Weekly data\
Variables Included:
- Marketing budget and allocation ranges by channel (weekly)
- Revenue/sales (dependent variable)
- Seasonality patterns is assumed to be pretty fluctuative (given a lot of ups and downs in F&B business, preference trends, etc.)


### 2. MMM Analysis
Framework: [Robyn](https://facebookexperimental.github.io/Robyn/) (open-source MMM package in R by Meta)\
Key Features:
- Ridge regression with automated hyperparameter tuning
- Adstock modeling: Captures lagged effects (ad exposure → purchase delay)
- Saturation curves: Models diminishing returns at high spend
- Multi-objective optimization: Balances model fit vs business KPIs

Model configuration:
- Dependent Variable: Weekly revenue/sales
- Independent Variables: IG spend, TikTok spend, Search spend
- Control Variables: Seasonality, holidays, weekday patterns
- Date Range: 156 weeks (Jan 2022 - Dec 2024)
- Iterations: 5000 trials to find optimal hyperparameters

## Key Results
### Model quality:

Validation metrics:
- Adjusted R² = 73.4% - the model explains 73% of revenue variance using only 3 marketing channels
- NRMSE (train): 0.1372 (pretty good prediction accuracy)
- NRMSE (validation): 0.2116 (validation holds up well)
- DECOMP.RSSD: 0.0035 (excellent decomposition quality)
  - Low NRMSE and DECOMP.RSSD - pretty reliable prediction, directionally aligned despite some lagging to actual response (can be attributed to lack of external independent variables)

### Robyn's decomposition results:
- Trend dominates revenue contribution, meaning that sales are still mainly grown organically
- *Instagram* contributes most among paid channels (5.9% of sales), followed by *TikTok* (4%)
- Despite so, *TikTok* and *Search* could potentially be pushed more, given that they have ROAS almost on par with *Instagram*, despite less spending share on them
- As can be seen from the Response Curves by Channel, *Search* saturates the quickest, followed by *Instagram*, then *TikTok* with the slowest saturation rate among all channels we tested. This could mean there is room to spend more on *TikTok* to boost our revenue.
- The model tested only 3 paid media channels as independent variables and doesn't include non-media marketing activities like promotion, macroeconomic or competitive effects, so there are possibly more explanatory variables that contributes to the revenue (as now it's represented by large intercept - to be included for future exercises!)
- On adstock: *Instagram* is seen to have a strong immediate effect when the ad starts, but faster decay than *Search* (where by week 5 the effect has gone down to practically 0). For *TikTok*, effect picks up slowly in the beginning and peaks at week 5, but decays immediately afterwards. This could probably so due to faster rate of content refresh on *Instagram and TikTok* algorithm side.
<img width="6800" height="7600" alt="image" src="https://github.com/user-attachments/assets/d6b3ed45-f594-45fc-9d89-fef2e88c6c93" />


### Channel performance & ROAS
- If the bakery intends to maintain the total paid media budget for the month, there is still a small room to improve revenue, by reallocating the budget.
  - During simulation of the data, we expected our budget allocation to be ordered as follows: *Instagram* > *TikTok* > *Search*. And with ~Rp 1.7M budget per week, we could gain Rp 39.9M in a month
  - But, within the same budget, the allocation supposed to be *TikTok* (48%) > *Instagram* (33%) > *Search* (18%) in order for us to realize more revenue (at Rp 40.2M).
<img width="4200" height="4200" alt="image" src="https://github.com/user-attachments/assets/ba5f911a-8e34-4470-b62c-84991fd9672d" />

- It is also simulated that even when the bakery reduce its paid media spend by 30% on each of every channel, given the same allocation strategy (*Instagram* > *TikTok* > *Search*) with the initial plan, the bakery can generate Rp 37.6M of revenue per month, which is only about 6% reduction from the initial one.
- And, if the bakery could only spend Rp 1M per month for ad spend, it should allocate that budget 100% to *TikTok* and expect to get Rp 33.3M of revenue for that month.
<img width="4200" height="4200" alt="image" src="https://github.com/user-attachments/assets/675ed2d0-05bf-4241-90a4-68287519ff81" />

## Future improvements
- Include more independent variables like promotions, discounts, macroeconomic factors, or competitor information in order to build a stronger, more reliable model that reflects closer to the reality
- Simulated data also may not reflect 100% ground truth - real marketers may need to gather data from various sources based on their actual historical media spending and revenue (or other performance KPIs)

***Disclaimer: While we tried our best to simulate and assume the data according to real-life situation, the numbers may not reflect true reality. This exercise is mainly done for the purpose of exploring how MMM can be useful for daily marketing practice, and building understanding of Robyn's MMM output interpretation. Any feedback on this repository is very much welcomed!***


