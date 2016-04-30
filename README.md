# Subscription Upselling Project
<b>CONTEXT</b><br>
An anonymized magazine publisher's marketing team is looking for ways to see if they can upsell to their existing customer. From Customer Relationship Management perspective, <i>"Finding a new customer costs 5x as much as keeping an old customer."</i> Thus, it is important that they understand the characteristics of their targeted customers. 
<br><br>
<b>OBJECTIVE</b><br>
To understand the characteristics of customers who subscribe more than one magazine compared to customers only subscribing to one magazine. Identify customers who currently describe to only one magazine, but display some characteristics with customers subscribing more than one magazine, as potential upsell lead. 
<br><br>
<b>DATA DESCRIPTION</b><br>
The only raw data provided is in CustSubscriptions.csv file. This file consists of data of 16,020 customers and various characteristics describing their demographic or behavior such as: age, gender, household income, years as customer, number of subscriptions, and total revenue. This data set does not specify over what time period is total revenue earned, so it is assumed that total revenue is the figure of yearly total revenue collected based on the year prior to when analysis is made.
<br><br>
<b>ANALYSIS PROCESSS</b><br>
analysis.R shows the analysis process, written in R programming language. <br>
4 main steps in this analysis: initial setup, data reformat, data exploration, data modeling. <br> 
1. In data reformat, household income and customer revenue variables data type are converted from categorical to numerical. New variable of Average Price Per Magazine is created. Interestingly, I find that the unique values of APPM in customers subscibing only one and more than one magazine is pretty much the same, except for the $80 APPM. So, I explore this aspect further using basic R commands such as table() and summary(). The finding from this group is that men around 40 years old subscribing 9-19 magazines for 10-11 years tend to subscribe to more expensive magazine. <br>
2. In data modeling, I use random forest to understand which variables are most likely to influence customer subscription count. Model output shows that APPM and household income to be the most important features. <br>
3. More data exploration especially on household income is done, through understanding of its descriptive statistics and boxplot visualization. <br>
4. Years as customer variable is of medium importance, so I only obtain boxplot visualization and summary() to understand its implication on customer subscription count.
5. According to random forest feature importance model, gender is the least influencing factor on customer subscription count. To confirm this finding, I apply chi-square test. p-value > 0.05 which confirms finding. 
6. Another modeling I did for this project is a linear regression model. p-value < 0.05 and adjusted R-squared is 0.2204. <br><br>
Note that analysis was also done in SAS analytical software, but not displayed here. Both analysis show similar result. 
<br><br>
<b>RESULT/CONCLUSION</b><br>
1. Customers, reporting higher household income, tend to buy more expensive magazine (as indicated with higher average price per magazine AAPM).<br>
2. Customers, reporting higher household income, also tend to buy more magazine. <br>
3. Newer customer tend to subscribe to more magazines. 
<br><br>
<b>LESSON(S) LEARNED</b><br>
