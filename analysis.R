# Magazines/newspaper subscriptions up-sell project

# ---------------------------------------------------------------------------------
# INITIAL SETUP
# ---------------------------------------------------------------------------------
# set working directory
setwd("~/Desktop/")

# load dataset
dat <- read.csv("CustSubscriptions.csv")


# ---------------------------------------------------------------------------------
# DATA CLEAN-UP/REFORMAT
# ---------------------------------------------------------------------------------
# drop $ sign in HOUSEHOLD_INCOME AND CUSTOMER_REVENUE vars and change them
# from categorical into numeric type
unique(dat$HOUSEHOLD_INCOME)
dat$HOUSEHOLD_INCOME <- gsub("\\$", "", dat$HOUSEHOLD_INCOME)
dat$HOUSEHOLD_INCOME <- as.numeric(gsub(",", "", dat$HOUSEHOLD_INCOME))
dat$CUSTOMER_REVENUE <- gsub("[$]", "", dat$CUSTOMER_REVENUE)
dat$CUSTOMER_REVENUE <- gsub(",", "", dat$CUSTOMER_REVENUE)
dat$CUSTOMER_REVENUE <- as.numeric(gsub(" ", "", dat$CUSTOMER_REVENUE))

# assumption:
# var CUSTOMER_REVENUE is revenue earned from customer the year before.

# new var: APPM (avg price per mag)
dat$APPM <- (dat$CUSTOMER_REVENUE / dat$CUSTOMER_SUBSCRIPTION_COUNT)



# ---------------------------------------------------------------------------------
# DATA EXPLORATION: overall data
# ---------------------------------------------------------------------------------
# percentage of potential lead over whole customer database
prop.table(table(dat$CUSTOMER_SUBSCRIPTION_COUNT == 1)) # 27%

# get summary of years as customer var
summary(dat$YEARS_AS_CUSTOMER)



# ---------------------------------------------------------------------------------
# DATA EXPLORATION: APPM var
# ---------------------------------------------------------------------------------
# note that APPM == 80 is only observed in customers > 1 subs, so let's 
# explore further

# subset new data frame for APPM == 80
APPM80 <- subset(dat, APPM == 80)
# 52 observations

# More male or female?
table(APPM80$GENDER)
# F  M  U 
# 14 36  2 

# Younger or older age?
summary(APPM80$AGE)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 26.00   32.75   40.00   40.08   45.00   64.00 

# Newer or older customer?
summary(APPM80$YEARS_AS_CUSTOMER)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 4.00    7.00   11.00   10.77   13.00   23.00 

# Fewer or More subscription count?
summary(APPM80$CUSTOMER_SUBSCRIPTION_COUNT)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.000   7.000  10.500   9.846  13.000  13.000 

# Finding summary:
# Men around 40 years old; subscribing to 9-10 magazines for 10-11 years
# tend to subscribe to more expensive magazines.



# ---------------------------------------------------------------------------------
# DATA MODELING: RANDOM FOREST
# ---------------------------------------------------------------------------------
# load library
library(randomForest)

# ensure repeatability
set.seed(123)

# build a random forest model
fit <- randomForest(CUSTOMER_SUBSCRIPTION_COUNT ~ AGE + 
                            HOUSEHOLD_INCOME + 
                            YEARS_AS_CUSTOMER +
                            APPM + 
                            GENDER,
                    data = dat,
                    importance = T,
                    ntree = 500)

# plot to see importance of vars
varImpPlot(fit)

# Finding summary:
# APPM and household income show to be most important features.



# ---------------------------------------------------------------------------------
# DATA EXPLORATION: HOUSEHOLD_INCOME var
# ---------------------------------------------------------------------------------
# summary of household income
summary(dat$HOUSEHOLD_INCOME)

# subset data frame: <55000
under55k <- subset(dat, HOUSEHOLD_INCOME < 55000) # 8885 obs

# subset data frame: >= 55000
is55kandAbove <- subset(dat, HOUSEHOLD_INCOME >= 55000) # 7135 obs

# percentage of == 1 subs in under55k
prop.table(table(under55k$CUSTOMER_SUBSCRIPTION_COUNT > 1)) # 62%

# percentage of == 1 subs in is55kandAbove
prop.table(table(is55kandAbove$CUSTOMER_SUBSCRIPTION_COUNT > 1)) # 87%

# boxplot of household income data in relation with cust == 1 sub (0) and > 1 sub (1)
boxplot(dat$HOUSEHOLD_INCOME ~ dat$TARGET)

# Finding summary:
# Customers reporting higher household income tend to subscribe > 1 mag 



# ---------------------------------------------------------------------------------
# DATA VISUALIZATION: YEARS AS CUSTOMER
# ---------------------------------------------------------------------------------
# boxplot
boxplot(dat$YEARS_AS_CUSTOMER ~ dat$TARGET)

# Finding summary:
# cust > 1 sub have a lower median of years as customer



# ---------------------------------------------------------------------------------
# DATA EXPLORATION: GENDER
# ---------------------------------------------------------------------------------
# chi-square test on female and target
femaleTarget = table(dat$TARGET, dat$Female)
chisq.test(femaleTarget)

# return:
# Pearson's Chi-squared test with Yates' continuity correction
# 
# data:  femaleTarget
# X-squared = 2.951, df = 1, p-value = 0.08582

# chi-square test on male and target
maleTarget = table(dat$TARGET, dat$Male)
chisq.test(maleTarget)

# return:
# Pearson's Chi-squared test with Yates' continuity correction
# 
# data:  maleTarget
# X-squared = 3.1593, df = 1, p-value = 0.0755

# note that p-value > 0.05 is consistent with previous findings that
# gender var does not significantly influence how many mag cust will subscribe.



# ---------------------------------------------------------------------------------
# DATA MODELING: LINEAR REGRESSION 
# ---------------------------------------------------------------------------------
# linear regression 
lmfit <- lm(CUSTOMER_SUBSCRIPTION_COUNT ~ HOUSEHOLD_INCOME + 
                    AGE + 
                    GENDER + 
                    APPM,
          data = dat)
summary(lmfit)

# Residuals:
#         Min     1Q Median     3Q    Max 
# -9.330 -1.681 -0.513  1.258 11.625 
#
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# (Intercept)       4.144e+00  8.442e-02  49.084   <2e-16 ***
#         HOUSEHOLD_INCOME  3.087e-05  4.945e-07  62.423   <2e-16 ***
#         AGE              -4.160e-02  1.610e-03 -25.834   <2e-16 ***
#         GENDERM          -3.531e-01  4.139e-02  -8.531   <2e-16 ***
#         GENDERU           2.159e-02  1.159e-01   0.186    0.852    
# APPM             -2.022e-02  2.262e-03  -8.938   <2e-16 ***
#        ---
#         Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Residual standard error: 2.507 on 16014 degrees of freedom
# Multiple R-squared:  0.2207,	Adjusted R-squared:  0.2204 
# F-statistic: 906.8 on 5 and 16014 DF,  p-value: < 2.2e-16



# ---------------------------------------------------------------------------------
# MAIN FINDINGS
# ---------------------------------------------------------------------------------
# 1. Customers, reporting higher income, tend to subscribe to more 
# expensive magazines.
# 2. Customers, reporting higher income, tend to subscribe to more magazines.
# 3. Newer customers, under 4 years, tend to subscribe to more magazines.
