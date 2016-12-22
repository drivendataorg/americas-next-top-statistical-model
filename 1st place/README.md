![Banner Image](https://s3.amazonaws.com/drivendata/comp_images/electoral_map_1.jpg)

# America's Next Top (Statistical) Model - 1st Place

# Entrant Background and Submission Overview

### Mini-bio
I am a (quantitative) policy researcher. First I worked for ten years in a policy research institute where I did research on the livability and housing market in the Netherlands. And since 6 months I work for the XXXXXX as a researcher on income policy, employment en (income) inequality. My research is mostly quantitative and (socio)-geographic. I studied political science and economics.

### High Level Summary of Submission
I used the polls as published by 538. These are already adjusted for some basic trends. I used these polls to make 3 predictions. The first is just an average prediction based on the state polls. The second is a prediction based on demographics. I used regression analyses to predict state results based on demographic variables. And the third prediction is based on polls of comparable states. I used a cluster analysis to find 5 groups of comparable states and within those groups a similarity index is used to create weights which polls are more important. The final prediction is based on a mixture of the three partial predictions. The more polls a state has, the more the final prediction is based on its own polls and less with demographics and polls from other states. Also recent polls have a much higher weight.

### Omitted Work
Spent the most time making a good demographic prediction. So tried a lot of different demographic variables. Especially paid attention to the 'angry white voter', by looking at changes in white demographics and median income and more. But those things didn't correlate with the polls. So, they didn't make it in the prediction. But by now we know all polls and models (including mine) missed some of these votes.

### Tools Used
All analyses are done in R. But did some data preparation in excel. But only putting files from different sources together and some cleaning (especially the similarity index). All final files are in the code.

### Model Evaluation
Mostly followed my gut feeling and compared with other predictions like 538, the upshot, huffington post and realclearpolitics.

### Future Steps
The demographic prediction was done on a state level. But states can be huge and have large differences within them. The differences between city and the country side for example. And old and young. But lots of these differences are averaged out on a state level. In my research career I did lots of predictions on much lower levels (for instance zip codes in the Netherlands, who are on average 20 houses big), and those work out much better for analyses and predications like these.

# Replicating the Submission

* I used R/R-studio for the analyses. Some data wrangling was done in excel. But only to order data and combine data from different sources and clean some small things up. All data files that resulted from this are in the "Files" folder.

* I used several r-libraries. Those are in top of the r-script "prediction_us_elections.R". So install those.

* Create a folder and put all csv/txt- files in that folder. And set that folder as the working directory in line 9 of the r-script (with setwd).

* Just run the entire script. In the end of it, it creates an csv-file with the prediction for each state.

### Set up r-script:
1. Load state data (for instance from the census bureau, PEW Research and Gallup)

2.	Create demographic data by ethnicity and age

3.	Predict Green party in 2016-election. This is based on the average results of the green party during the previous 3 presidential elections. There were hardly any (reliable) polls on a state level to predict green party votes on that state level. So I used the old results to find in which states they gain more votes on average. The final national polls put the green party on average at 1.9%. The average green vote in the previous 3 general elections is adjusted for this average polling results. So in states (like Alaska and Maine) where the green party gained on average the most votes in the past, they get the most votes in this prediction as well, but (a lot) more because polling indicated a higher national number compared to the previous elections. More or less the same is done for other third party votes (not being Stein, Johnson or McMullen), but without the adjustment for the average national polls (these aren't in the polls).

4.	Cluster analyses and similarity index. The cluster analyses (based on Partisan Vote Index, % black population and % poverty) was done to find states (5 groups) which are comparable. The similarity index (based on the previous 3 presidential elections) was done to find within those 5 groups a measure of how similar states are. These are later used to adjust for the state polls.

5.	Get the file created by 538 with all the polls. I used the adjusted polls, which are already adjusted for some general trends. Made some changes in the weights and stuff like that. After the next step the script aggregates the polls by state to get an average polling result (for the difference between Clinton and Trump and for Johnson). This is the first prediction by state.

6.	Prediction based on demographics. The script runs two regressions to make a prediction based on demographics. The dependent variable is the polls by state and the independent variables are demographic data (tried a lot of different variables and techniques (not only regression), the two in the script are the final ones). The first regression predicts the difference between Clinton and Trump, the second the percentage Johnson will gain. This part of the script also creates variables which show if a poll indicates a states does better than the demographic prediction or worse. This is used in the third prediction.

7.	The script then aggregates the polling results and the demographic predictions. This is the second prediction by state.

8.	Finally the script makes a prediction based on polls from comparable states. First it only looks to polls from states within the same group (each state is only in one group). And secondly it adjusts the weights within those groups based on the similarity index. So the weights of the polls of highly similar states are higher than that of those of less similar states (within the same group). This part of the script creates weights based on this idea. It uses the variables which shows if a state does better or worse (and how much) than the demographic prediction. This is done for the difference between Clinton and Trump and for Johnson. Finally it aggregates for a prediction by state based on polls of similar states. This is the third prediction by state.

9.	The three predictions by state are put together. States with lots of polls are mostly based on their on polls. States with few polls are more based on demographics and polls from other states.

10.	Finally some adjustments are made to get to 100%. And of course the difference Clinton-Trump is now split into a percentage Clinton and a percentage Trump. And an output-file is created.
