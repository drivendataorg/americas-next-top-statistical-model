![Banner Image](https://s3.amazonaws.com/drivendata/comp_images/electoral_map_1.jpg)

# America's Next Top (Statistical) Model - 2nd Place
<br><br>
# Entrant Background and Submission Overview

### High Level Summary of Submission

First, we pulled together historical election results by state from the federal election campaign.  We then built a model for predicting the 2012 election using a simple weighted average approach.  The root mean squared error of 1.76 performed better than the Poll Benchmark, and would have outperformed top election modelers (1.86 from Nate Silver in 2012).

[Rationality's Top Election Modelers](http://rationality.org/2012/11/09/was-nate-silver-the-most-accurate-2012-election-pundit/)

This was the validation we needed to move away from a poll specific model and incorporate more domain knowledge into the model building process.

Second, we categorized states into the following scenarios;
* Time for Change
* Partial Time for Change
* No Time for Change
* Mormon Corridor Pattern
* Trend

These categories were assigned to each state using critical and extensive domain knowledge, and modeling expertise.  It was an iterative process.  Domain knowledge would be researched and tested before assigning the scenario (e.g. education levels, ethnicity, religion demographics, GDP, presidential approval ratings, etc.).

After the scenarios were assigned to each state, a modeling method was applied to produce the prediction (weighted average, average trend, etc.).

### Omitted Work

We used the polls only in unique cases where we thought the state would not perform similar to any period in the past.  The two extreme cases were Utah and Idaho (large Mormon population).  

We didn’t use polls in other cases because there appeared to be too much error at the state level.  In some cases, the polls were vastly different from historical trends (Oklahoma).

### Tools Used

The Microsoft Excel file that was submitted is the only tool used for data preparation, visualization, and modeling.

### Model Evaluation
A simple weighted average was used for predicting the 2012 election.  Our score of 1.76 on the leaderboard beat the Benchmark: Poll Baseline Model, and all of the top election modelers in this article below.

[Rationality's Top Election Modelers](http://rationality.org/2012/11/09/was-nate-silver-the-most-accurate-2012-election-pundit/)

We also experimented with the scenarios (time for change, partial time for change, no change, and trend) for 2012, and performance improved.  That was the validation we needed to continue with our approach for 2016.

### Future Steps

If we were to continue to work on this problem, we would identify the actual results by state for 2016 that fit into the scenarios we outlined (time for change, partial time for change, trend, etc.).  That would be the target/dependent variable.  All the pieces of information we used would be the independent variables (GDP, presidential approval ratings, demographic variables, education levels, etc.).  We would then build a statistical model to see how accurate it would be for classifying states into the scenarios.  That way, we could see if the model would do better than our domain knowledge approach for classifying the states.
