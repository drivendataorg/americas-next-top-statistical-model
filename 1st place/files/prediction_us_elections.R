library(proxy)
library(plyr)
library(questionr)
library(MASS)
library(car)
library(xlsx)
library(data.table)

setwd("C:/Users/Tall/Documents/R/kaggle/usa_verkiezingen")  ##put all files in this working directory

#######data files

####results 2012
uitslag_2012 <- read.csv("~/R/kaggle/usa_verkiezingen/2012-actual-returns.csv")

###greens and other thirdparties old results (2004,2008, 2012, mean (=gem) and max )
greens <- read.delim2("~/R/kaggle/usa_verkiezingen/greens.txt")
extra_partijen <- read.csv2("~/R/kaggle/usa_verkiezingen/extra_partijen.csv")

####state data 2012
stateData_2012 <- read.csv("~/R/kaggle/usa_verkiezingen/stateData_2012.csv")
stateData_2012_B <- read.csv("~/R/kaggle/usa_verkiezingen/census_demographics.csv")

####state abreviarion
state_abr2 <- read.csv("~/R/kaggle/usa_verkiezingen/state_abr2.csv", sep=";")
uitslag_2012<- merge(uitslag_2012,state_abr2, by.x="STATE.ABBREVIATION", by.y="STATE.ABREVIATION")

####state date 2016
state_data_2016_rest <- read.csv2("~/R/kaggle/usa_verkiezingen/data_staat.csv")

#####state data 2016 demography
statedata_2016 <- read.csv("~/R/kaggle/usa_verkiezingen/SC-EST2015-ALLDATA6.csv")
statedata_2016 <- subset(statedata_2016, AGE>17 & SEX>0 & ORIGIN>0)

#data processing state 2016 demography (census data)
statedata_2016$White_male_18_30 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_male_30_45 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_male_45_65 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_male_65_eo <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_female_18_30 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_female_30_45 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_female_45_65 <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$White_female_65_eo <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_male_18_30 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_male_30_45 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_male_45_65 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_male_65_eo <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_female_18_30 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_female_30_45 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_female_45_65 <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black_female_65_eo <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_male_18_30 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_male_30_45 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_male_45_65 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_male_65_eo <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==1 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_female_18_30 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_female_30_45 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_female_45_65 <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian_female_65_eo <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 & statedata_2016$SEX==2 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_male_18_30 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==1 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_male_30_45 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==1 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_male_45_65 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==1 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_male_65_eo <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==1 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_female_18_30 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==2 & statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_female_30_45 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==2 & statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_female_45_65 <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==2 & statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp_female_65_eo <- ifelse(statedata_2016$ORIGIN==2 & statedata_2016$SEX==2 & statedata_2016$AGE>64 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$White <- ifelse(statedata_2016$RACE==1 & statedata_2016$ORIGIN==1 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Black <- ifelse(statedata_2016$RACE==2 & statedata_2016$ORIGIN==1 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Asian <- ifelse(statedata_2016$RACE==4 & statedata_2016$ORIGIN==1 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$Hisp <- ifelse(statedata_2016$ORIGIN==2 , statedata_2016$POPESTIMATE2015,0)
statedata_2016$age_18_30 <- ifelse(statedata_2016$AGE>17 & statedata_2016$AGE<30, statedata_2016$POPESTIMATE2015,0)
statedata_2016$age_30_45 <- ifelse(statedata_2016$AGE>29 & statedata_2016$AGE<45, statedata_2016$POPESTIMATE2015,0)
statedata_2016$age_45_65 <- ifelse(statedata_2016$AGE>44 & statedata_2016$AGE<65, statedata_2016$POPESTIMATE2015,0)
statedata_2016$age_65_eo <- ifelse(statedata_2016$AGE>64, statedata_2016$POPESTIMATE2015,0)

#aggrege tot state level
statedata_2016_agr <- ddply(statedata_2016, "NAME", summarize,
                            White_male_18_30=sum(White_male_18_30),
                            White_male_30_45=sum(White_male_30_45),
                            White_male_45_65=sum(White_male_45_65),
                            White_male_65_eo=sum(White_male_65_eo),
                            White_female_18_30=sum(White_female_18_30),
                            White_female_30_45=sum(White_female_30_45),
                            White_female_45_65=sum(White_female_45_65),
                            White_female_65_eo=sum(White_female_65_eo),
                            Black_male_18_30=sum(Black_male_18_30),
                            Black_male_30_45=sum(Black_male_30_45),
                            Black_male_45_65=sum(Black_male_45_65),
                            Black_male_65_eo=sum(Black_male_65_eo),
                            Black_female_18_30=sum(Black_female_18_30),
                            Black_female_30_45=sum(Black_female_30_45),
                            Black_female_45_65=sum(Black_female_45_65),
                            Black_female_65_eo=sum(Black_female_65_eo),
                            Asian_male_18_30=sum(Asian_male_18_30),
                            Asian_male_30_45=sum(Asian_male_30_45),
                            Asian_male_45_65=sum(Asian_male_45_65),
                            Asian_male_65_eo=sum(Asian_male_65_eo),
                            Asian_female_18_30=sum(Asian_female_18_30),
                            Asian_female_30_45=sum(Asian_female_30_45),
                            Asian_female_45_65=sum(Asian_female_45_65),
                            Asian_female_65_eo=sum(Asian_female_65_eo),
                            Hisp_male_18_30=sum(Hisp_male_18_30),
                            Hisp_male_30_45=sum(Hisp_male_30_45),
                            Hisp_male_45_65=sum(Hisp_male_45_65),
                            Hisp_male_65_eo=sum(Hisp_male_65_eo),
                            Hisp_female_18_30=sum(Hisp_female_18_30),
                            Hisp_female_30_45=sum(Hisp_female_30_45),
                            Hisp_female_45_65=sum(Hisp_female_45_65),
                            Hisp_female_65_eo=sum(Hisp_female_65_eo),
                            White=sum(White),
                            Black=sum(Black),
                            Asian=sum(Asian),
                            Hisp=sum(Hisp),
                            age_18_30=sum(age_18_30),
                            age_30_45=sum(age_30_45),
                            age_45_65=sum(age_45_65),
                            age_65_eo=sum(age_65_eo),
                            Populatie=sum(POPESTIMATE2015))

#calculate proportions
statedata_2016_agr$White_male_18_30_per <- statedata_2016_agr$White_male_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$White_male_30_45_per <- statedata_2016_agr$White_male_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$White_male_45_65_per <- statedata_2016_agr$White_male_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$White_male_65_eo_per <- statedata_2016_agr$White_male_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$White_female_18_30_per <- statedata_2016_agr$White_female_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$White_female_30_45_per <- statedata_2016_agr$White_female_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$White_female_45_65_per <- statedata_2016_agr$White_female_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$White_female_65_eo_per <- statedata_2016_agr$White_female_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Black_male_18_30_per <- statedata_2016_agr$Black_male_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Black_male_30_45_per <- statedata_2016_agr$Black_male_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Black_male_45_65_per <- statedata_2016_agr$Black_male_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Black_male_65_eo_per <- statedata_2016_agr$Black_male_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Black_female_18_30_per <- statedata_2016_agr$Black_female_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Black_female_30_45_per <- statedata_2016_agr$Black_female_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Black_female_45_65_per <- statedata_2016_agr$Black_female_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Black_female_65_eo_per <- statedata_2016_agr$Black_female_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_male_18_30_per <- statedata_2016_agr$Asian_male_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_male_30_45_per <- statedata_2016_agr$Asian_male_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_male_45_65_per <- statedata_2016_agr$Asian_male_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_male_65_eo_per <- statedata_2016_agr$Asian_male_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_female_18_30_per <- statedata_2016_agr$Asian_female_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_female_30_45_per <- statedata_2016_agr$Asian_female_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_female_45_65_per <- statedata_2016_agr$Asian_female_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_female_65_eo_per <- statedata_2016_agr$Asian_female_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_male_18_30_per <- statedata_2016_agr$Hisp_male_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_male_30_45_per <- statedata_2016_agr$Hisp_male_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_male_45_65_per <- statedata_2016_agr$Hisp_male_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_male_65_eo_per <- statedata_2016_agr$Hisp_male_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_female_18_30_per <- statedata_2016_agr$Hisp_female_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_female_30_45_per <- statedata_2016_agr$Hisp_female_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_female_45_65_per <- statedata_2016_agr$Hisp_female_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_female_65_eo_per <- statedata_2016_agr$Hisp_female_65_eo/statedata_2016_agr$Populatie
statedata_2016_agr$White_per <- statedata_2016_agr$White/statedata_2016_agr$Populatie
statedata_2016_agr$Black_per <- statedata_2016_agr$Black/statedata_2016_agr$Populatie
statedata_2016_agr$Asian_per <- statedata_2016_agr$Asian/statedata_2016_agr$Populatie
statedata_2016_agr$Hisp_per <- statedata_2016_agr$Hisp/statedata_2016_agr$Populatie
statedata_2016_agr$age_18_30_per <- statedata_2016_agr$age_18_30/statedata_2016_agr$Populatie
statedata_2016_agr$age_30_45_per <- statedata_2016_agr$age_30_45/statedata_2016_agr$Populatie
statedata_2016_agr$age_45_65_per <- statedata_2016_agr$age_45_65/statedata_2016_agr$Populatie
statedata_2016_agr$age_65_eo_per <- statedata_2016_agr$age_65_eo/statedata_2016_agr$Populatie

####merge state data
state_data <- merge(state_data_2016_rest,statedata_2016_agr, by.x="State", by.y="NAME")
state_data <- merge(state_data,stateData_2012, by.x="State", by.y="state")
state_data <- state_data[c(1:40,81:135)]
state_data <- merge(state_data,greens, by="State", all.x = TRUE)
state_data <- merge(state_data,extra_partijen, by="State", all.x = TRUE)
state_data$mean_green <- ifelse(state_data$State=="Oklahoma",0,state_data$mean_green)

####merge to results 2012
uitslag_2012_plus <- merge(uitslag_2012, state_data, by="State")


####predict share of vote Green Party (based on mean of 2004/2008/2012 results, but adjusted to national poll(=peiling greens), which was 1,9%)

#adjust for national polls
peiling_greens <- 0.019
stemmen_green_verleden <- sum(uitslag_2012_plus$mean_green*(uitslag_2012_plus$turnout.acs.cvap*uitslag_2012_plus$Populatie))
stemmen_green_2016 <- peiling_greens*sum(uitslag_2012_plus$turnout.acs.cvap*uitslag_2012_plus$Populatie)
uitslag_2012_plus$Stein_2016 <- ((uitslag_2012_plus$mean_green*(uitslag_2012_plus$turnout.acs.cvap*uitslag_2012_plus$Populatie))/
                                   stemmen_green_verleden*stemmen_green_2016)/(uitslag_2012_plus$turnout.acs.cvap*uitslag_2012_plus$Populatie)
uitslag_2012_plus$green_2012[is.na(uitslag_2012_plus$green_2012)] <- 0

#greens don't participate in nevada, South Dakota and Oklahoma
uitslag_2012_plus$Stein_2016 <- ifelse(uitslag_2012_plus$State=="Nevada"|uitslag_2012_plus$State=="South Dakota"|
                                         uitslag_2012_plus$State=="Oklahoma",0,uitslag_2012_plus$Stein_2016)

######missing values in state date (approval ratings obama (obama_balance=obama_approbal-obama_disapproval), "no religion")
missing_approval <- lm(Obama_balance~PVI+Black_per+Hisp_per+mediaan_inkomen, data=uitslag_2012_plus)
summary(missing_approval)
uitslag_2012_plus$Obama_approval_impute <- predict(missing_approval, uitslag_2012_plus)
uitslag_2012_plus$Obama_balance[9] <- uitslag_2012_plus$Obama_approval_impute[9]

missing_none <- lm(None~PVI+White_per+mediaan_inkomen+alt.region, data=uitslag_2012_plus)
summary(missing_none)
uitslag_2012_plus$None_impute <- predict(missing_none, uitslag_2012_plus)
uitslag_2012_plus$None[is.na(uitslag_2012_plus$None)] <- uitslag_2012_plus$None_impute[is.na(uitslag_2012_plus$None)]

#adjuments and dummy variables jewish and mormon states and DC
uitslag_2012_plus$Jewish[2] <- 0.8
uitslag_2012_plus$Jewish[12] <- 0.5
uitslag_2012_plus$Mormon[2] <- 0.8
uitslag_2012_plus$Mormon[12] <- 0.5
uitslag_2012_plus$Mormon_state <- ifelse(uitslag_2012_plus$Mormon>50,1,0)
uitslag_2012_plus$DC_Dummy <- ifelse(uitslag_2012_plus$State=="District of Columbia",1,0)
uitslag_2012_plus$Obama_balance_dc <-  ifelse(uitslag_2012_plus$State=="District of Columbia",0,uitslag_2012_plus$Obama_balance)


#######clusteranalyses: find groups (5) of comparable states (based on Partisan Vote Index (PVI, %black and %poverty) Tried lots and lots more variables, combinations and weights, but these 3 worked best (with PVI weigthed double))

#data (based on early weighted polls, combined with state data)
cluster_data <- read.csv("~/R/kaggle/usa_verkiezingen/cluster_data.csv")
cluster_data <- cluster_data[-1]
cluster_data$PVI_scale <- scale(cluster_data$PVI)*2
cluster_data$Black_per_scale <- scale(cluster_data$Black_per)
cluster_data$armoede_scale <- scale(cluster_data$armoede)

dist_matrix <- dist(cluster_data[c(17,18,19)], method = "euclidean")
hier_clus <- hclust(dist_matrix, method="ward.D")
plot(hier_clus, labels=cluster_data$state)
uitslag_2012_plus$groep <- cutree(hier_clus, k=6)
uitslag_2012_plus$groep[9] <- 3 #put DC in other democratic cluster

#######similarity index (based on 2004, 2008 and 2012 results). This is used to find within the clusters of comparable states a measure of how much states vote the same.
oud_uitslagen <- read.csv2("~/R/kaggle/usa_verkiezingen/oud_uitslagen.csv")
sim_index <- simil(oud_uitslagen[c(2:4)], method = "euclidean", diag=NA)
sim_index <- data.matrix(sim_index)

##cleaned in excel a bit up. so load this one. But basically the same as the sim_index.
weeg_staten <- read.csv2("~/R/kaggle/usa_verkiezingen/weeg_staten.csv")



###########demographics, cluster analyses and similarity index are used later on the adjust for the polls


################################get polls (the adjusted polls by 538) and work with those to in the second part of this script to make predictions

######poll file 538
peilingen_2016_538 <- read.csv("~/R/kaggle/usa_verkiezingen/president_general_polls_2016.csv")
peilingen_2016_538_polls_only <- subset(peilingen_2016_538, type=="polls-only")
peilingen_2016_538_polls_only <- subset(peilingen_2016_538_polls_only , samplesize>200)
peilingen_2016_538_polls_only$adjpoll_johnson <- ifelse(peilingen_2016_538_polls_only$state=="District of Columbia",
                                                        peilingen_2016_538_polls_only$rawpoll_johnson, peilingen_2016_538_polls_only$adjpoll_johnson)

#add date of the poll
peilingen_2016_538_polls_only$datum <-as.Date(peilingen_2016_538_polls_only$enddate, format = "%m/%d/%Y")

#adjust weight for average poll results (recent polls more weight, polls of unreliable polling institutes less weight)
peilingen_2016_538_polls_only$dagen_tot_verkiezing <- as.numeric(difftime(max(peilingen_2016_538_polls_only$datum),peilingen_2016_538_polls_only$datum, units= "days"))+1
peilingen_2016_538_polls_only$nieuwe_weging <- (peilingen_2016_538_polls_only$dagen_tot_verkiezing^(-0.109))*1.5249
peilingen_2016_538_polls_only$factor <- (peilingen_2016_538_polls_only$dagen_tot_verkiezing^(-0.109))*1.5249
peilingen_2016_538_polls_only$poll_wt <- peilingen_2016_538_polls_only$poll_wt*peilingen_2016_538_polls_only$nieuwe_weging
peilingen_2016_538_polls_only$poll_wt <- ifelse((peilingen_2016_538_polls_only$grade=="C"|peilingen_2016_538_polls_only$grade=="C-"|
                                                   peilingen_2016_538_polls_only$grade=="C+"|peilingen_2016_538_polls_only$grade=="D")&peilingen_2016_538_polls_only$poll_wt>0.3,
                                                ((-0.0351*peilingen_2016_538_polls_only$poll_wt)^2)+(0.6217*peilingen_2016_538_polls_only$poll_wt)+0.1098,peilingen_2016_538_polls_only$poll_wt)

#merge with met state data (for demographics)
peilingen_2016_538_polls_only_state <- merge(peilingen_2016_538_polls_only, uitslag_2012_plus, by.x="state", by.y="State", all.x=TRUE, sort=FALSE)

#clinton vs trump
peilingen_2016_538_polls_only_state$Clinto_trump <- peilingen_2016_538_polls_only_state$adjpoll_clinton - peilingen_2016_538_polls_only_state$adjpoll_trump

#adjust weight for demographic prediction (adjust for difference in number of polls between states)
input <- data.table(peilingen_2016_538_polls_only_state)
input[, peilingen_staat_totaal:=poll_wt/sum(poll_wt), by= state]
peilingen_2016_538_polls_only_state <- as.data.frame(input)


######predicitons bases on demographics

####regression demography CLinton vs Trump (tried lotst and lots of regression, this one worked best)
regressie_demografie <- lm(Clinto_trump ~ Obama_balance_dc + White_per+ Hisp_per + 
                             age_30_45_per + age_45_65_per + advanced_degree + high_school +  Mormon_state +
                             mediaan_inkomen + economy + mid_clas_dev + alt.region +DC_Dummy + green_2012 + Johnson,
                           data=peilingen_2016_538_polls_only_state, weights=peilingen_staat_totaal)
summary(regressie_demografie)
peilingen_2016_538_polls_only_state$demografie <- predict(regressie_demografie,peilingen_2016_538_polls_only_state)
demografie_staat <- aggregate(demografie~state, data=peilingen_2016_538_polls_only_state, FUN=mean)


###regression demography Johhnson (same note)
regressie_demografie_Johnson <- lm(adjpoll_johnson ~ Obama_balance_dc + White_per + Black_per + 
                                     Hisp_per + age_18_30_per + age_30_45_per + age_45_65_per + 
                                     high_school + bachelor + advanced_degree + Jewish + None + 
                                     mediaan_inkomen + economy + ink10_jaar + 
                                     ontw_white + DC_Dummy + green_2012 + Johnson,
                                   data=peilingen_2016_538_polls_only_state, weights=peilingen_staat_totaal)
summary(regressie_demografie_Johnson)
peilingen_2016_538_polls_only_state$demografie_Johnson <- predict(regressie_demografie_Johnson,peilingen_2016_538_polls_only_state)

###aggregate polls and demographic prediction
peilingen_2016_538_polls_only_state$Clinto_trump_verschil_demo <- peilingen_2016_538_polls_only_state$Clinto_trump - peilingen_2016_538_polls_only_state$demografie
peilingen_2016_538_polls_only_state$adjpoll_johnson_verschil_demo <-   peilingen_2016_538_polls_only_state$adjpoll_johnson - peilingen_2016_538_polls_only_state$demografie_Johnson


gemiddelden_staat <- ddply(peilingen_2016_538_polls_only_state, "state", summarize,
                           clinton=weighted.mean(adjpoll_clinton, poll_wt, na.rm = TRUE),
                           trump=weighted.mean(adjpoll_trump, poll_wt, na.rm = TRUE),
                           johnson=weighted.mean(adjpoll_johnson, poll_wt, na.rm = TRUE),                            
                           mcmullin=weighted.mean(adjpoll_mcmullin, poll_wt, na.rm = TRUE),
                           stein=weighted.mean(Stein_2016, poll_wt, na.rm = TRUE),
                           extra_partijen=weighted.mean(extra_partijen_gem,poll_wt, na.rm = TRUE),
                           clinton_trump=weighted.mean(Clinto_trump, poll_wt, na.rm = TRUE),
                           clinton_trump_demografie=mean(demografie,na.rm = TRUE),
                           johnson_demografie=mean(demografie_Johnson,na.rm = TRUE),
                           clinton_trump_verschil_demo=weighted.mean(Clinto_trump_verschil_demo,poll_wt, na.rm = TRUE),
                           johnson_verschil_demo=weighted.mean(adjpoll_johnson_verschil_demo,poll_wt, na.rm = TRUE),                           
                           som_weeg=sum(poll_wt, na.rm=TRUE),
                           som_weeg_staat=sum(peilingen_staat_totaal, na.rm=TRUE))
gemiddelden_staat <- gemiddelden_staat[-c(21,22,31:33,50),]



########predictions based on comparable states (cluster analyses and similarity index are used)
peilingen_2016_538_polls_only_state <- merge(peilingen_2016_538_polls_only_state,weeg_staten, by.x="state", by.y="State")

#determine weights (simalarity * "normal weight")
peilingen_2016_538_polls_only_state$weeg_Alabama	<-	peilingen_2016_538_polls_only_state$cor_Alabama	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Arkansas	<-	peilingen_2016_538_polls_only_state$cor_Arkansas	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Georgia	<-	peilingen_2016_538_polls_only_state$cor_Georgia	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Kentucky	<-	peilingen_2016_538_polls_only_state$cor_Kentucky	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Louisiana	<-	peilingen_2016_538_polls_only_state$cor_Louisiana	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Mississippi	<-	peilingen_2016_538_polls_only_state$cor_Mississippi	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_SouthCarolina	<-	peilingen_2016_538_polls_only_state$cor_SouthCarolina	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Tennessee	<-	peilingen_2016_538_polls_only_state$cor_Tennessee	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Texas	<-	peilingen_2016_538_polls_only_state$cor_Texas	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_WestVirginia	<-	peilingen_2016_538_polls_only_state$cor_WestVirginia	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Alaska	<-	peilingen_2016_538_polls_only_state$cor_Alaska	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Arizona	<-	peilingen_2016_538_polls_only_state$cor_Arizona	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Idaho	<-	peilingen_2016_538_polls_only_state$cor_Idaho	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Kansas	<-	peilingen_2016_538_polls_only_state$cor_Kansas	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Montana	<-	peilingen_2016_538_polls_only_state$cor_Montana	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Nebraska	<-	peilingen_2016_538_polls_only_state$cor_Nebraska	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NorthDakota	<-	peilingen_2016_538_polls_only_state$cor_NorthDakota	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Oklahoma	<-	peilingen_2016_538_polls_only_state$cor_Oklahoma	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_SouthDakota	<-	peilingen_2016_538_polls_only_state$cor_SouthDakota	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Utah	<-	peilingen_2016_538_polls_only_state$cor_Utah	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Wyoming	<-	peilingen_2016_538_polls_only_state$cor_Wyoming	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_California	<-	peilingen_2016_538_polls_only_state$cor_California	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Connecticut	<-	peilingen_2016_538_polls_only_state$cor_Connecticut	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Delaware	<-	peilingen_2016_538_polls_only_state$cor_Delaware	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_DC	<-	peilingen_2016_538_polls_only_state$cor_DC	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Hawaii	<-	peilingen_2016_538_polls_only_state$cor_Hawaii	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Illinois	<-	peilingen_2016_538_polls_only_state$cor_Illinois	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Maine	<-	peilingen_2016_538_polls_only_state$cor_Maine	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Maryland	<-	peilingen_2016_538_polls_only_state$cor_Maryland	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Massachusetts	<-	peilingen_2016_538_polls_only_state$cor_Massachusetts	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NewJersey	<-	peilingen_2016_538_polls_only_state$cor_NewJersey	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NewMexico	<-	peilingen_2016_538_polls_only_state$cor_NewMexico	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NewYork	<-	peilingen_2016_538_polls_only_state$cor_NewYork	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Oregon	<-	peilingen_2016_538_polls_only_state$cor_Oregon	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_RhodeIsland	<-	peilingen_2016_538_polls_only_state$cor_RhodeIsland	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Vermont	<-	peilingen_2016_538_polls_only_state$cor_Vermont	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Washington	<-	peilingen_2016_538_polls_only_state$cor_Washington	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Colorado	<-	peilingen_2016_538_polls_only_state$cor_Colorado	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Iowa	<-	peilingen_2016_538_polls_only_state$cor_Iowa	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Minnesota	<-	peilingen_2016_538_polls_only_state$cor_Minnesota	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NewHampshire	<-	peilingen_2016_538_polls_only_state$cor_NewHampshire	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Wisconsin	<-	peilingen_2016_538_polls_only_state$cor_Wisconsin	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Florida	<-	peilingen_2016_538_polls_only_state$cor_Florida	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Indiana	<-	peilingen_2016_538_polls_only_state$cor_Indiana	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Michigan	<-	peilingen_2016_538_polls_only_state$cor_Michigan	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Missouri	<-	peilingen_2016_538_polls_only_state$cor_Missouri	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Nevada	<-	peilingen_2016_538_polls_only_state$cor_Nevada	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_NorthCarolina	<-	peilingen_2016_538_polls_only_state$cor_NorthCarolina	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Ohio	<-	peilingen_2016_538_polls_only_state$cor_Ohio	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Pennsylvania	<-	peilingen_2016_538_polls_only_state$cor_Pennsylvania	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Virginia	<-	peilingen_2016_538_polls_only_state$cor_Virginia	*	peilingen_2016_538_polls_only_state$poll_wt
peilingen_2016_538_polls_only_state$weeg_Alabama	[is.na(	peilingen_2016_538_polls_only_state$weeg_Alabama	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Arkansas	[is.na(	peilingen_2016_538_polls_only_state$weeg_Arkansas	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Georgia	[is.na(	peilingen_2016_538_polls_only_state$weeg_Georgia	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Kentucky	[is.na(	peilingen_2016_538_polls_only_state$weeg_Kentucky	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Louisiana	[is.na(	peilingen_2016_538_polls_only_state$weeg_Louisiana	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Mississippi	[is.na(	peilingen_2016_538_polls_only_state$weeg_Mississippi	)] <- 0
peilingen_2016_538_polls_only_state$weeg_SouthCarolina	[is.na(	peilingen_2016_538_polls_only_state$weeg_SouthCarolina	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Tennessee	[is.na(	peilingen_2016_538_polls_only_state$weeg_Tennessee	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Texas	[is.na(	peilingen_2016_538_polls_only_state$weeg_Texas	)] <- 0
peilingen_2016_538_polls_only_state$weeg_WestVirginia	[is.na(	peilingen_2016_538_polls_only_state$weeg_WestVirginia	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Alaska	[is.na(	peilingen_2016_538_polls_only_state$weeg_Alaska	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Arizona	[is.na(	peilingen_2016_538_polls_only_state$weeg_Arizona	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Idaho	[is.na(	peilingen_2016_538_polls_only_state$weeg_Idaho	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Kansas	[is.na(	peilingen_2016_538_polls_only_state$weeg_Kansas	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Montana	[is.na(	peilingen_2016_538_polls_only_state$weeg_Montana	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Nebraska	[is.na(	peilingen_2016_538_polls_only_state$weeg_Nebraska	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NorthDakota	[is.na(	peilingen_2016_538_polls_only_state$weeg_NorthDakota	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Oklahoma	[is.na(	peilingen_2016_538_polls_only_state$weeg_Oklahoma	)] <- 0
peilingen_2016_538_polls_only_state$weeg_SouthDakota	[is.na(	peilingen_2016_538_polls_only_state$weeg_SouthDakota	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Utah	[is.na(	peilingen_2016_538_polls_only_state$weeg_Utah	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Wyoming	[is.na(	peilingen_2016_538_polls_only_state$weeg_Wyoming	)] <- 0
peilingen_2016_538_polls_only_state$weeg_California	[is.na(	peilingen_2016_538_polls_only_state$weeg_California	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Connecticut	[is.na(	peilingen_2016_538_polls_only_state$weeg_Connecticut	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Delaware	[is.na(	peilingen_2016_538_polls_only_state$weeg_Delaware	)] <- 0
peilingen_2016_538_polls_only_state$weeg_DC	[is.na(	peilingen_2016_538_polls_only_state$weeg_DC	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Hawaii	[is.na(	peilingen_2016_538_polls_only_state$weeg_Hawaii	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Illinois	[is.na(	peilingen_2016_538_polls_only_state$weeg_Illinois	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Maine	[is.na(	peilingen_2016_538_polls_only_state$weeg_Maine	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Maryland	[is.na(	peilingen_2016_538_polls_only_state$weeg_Maryland	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Massachusetts	[is.na(	peilingen_2016_538_polls_only_state$weeg_Massachusetts	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NewJersey	[is.na(	peilingen_2016_538_polls_only_state$weeg_NewJersey	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NewMexico	[is.na(	peilingen_2016_538_polls_only_state$weeg_NewMexico	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NewYork	[is.na(	peilingen_2016_538_polls_only_state$weeg_NewYork	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Oregon	[is.na(	peilingen_2016_538_polls_only_state$weeg_Oregon	)] <- 0
peilingen_2016_538_polls_only_state$weeg_RhodeIsland	[is.na(	peilingen_2016_538_polls_only_state$weeg_RhodeIsland	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Vermont	[is.na(	peilingen_2016_538_polls_only_state$weeg_Vermont	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Washington	[is.na(	peilingen_2016_538_polls_only_state$weeg_Washington	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Colorado	[is.na(	peilingen_2016_538_polls_only_state$weeg_Colorado	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Iowa	[is.na(	peilingen_2016_538_polls_only_state$weeg_Iowa	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Minnesota	[is.na(	peilingen_2016_538_polls_only_state$weeg_Minnesota	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NewHampshire	[is.na(	peilingen_2016_538_polls_only_state$weeg_NewHampshire	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Wisconsin	[is.na(	peilingen_2016_538_polls_only_state$weeg_Wisconsin	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Florida	[is.na(	peilingen_2016_538_polls_only_state$weeg_Florida	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Indiana	[is.na(	peilingen_2016_538_polls_only_state$weeg_Indiana	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Michigan	[is.na(	peilingen_2016_538_polls_only_state$weeg_Michigan	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Missouri	[is.na(	peilingen_2016_538_polls_only_state$weeg_Missouri	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Nevada	[is.na(	peilingen_2016_538_polls_only_state$weeg_Nevada	)] <- 0
peilingen_2016_538_polls_only_state$weeg_NorthCarolina	[is.na(	peilingen_2016_538_polls_only_state$weeg_NorthCarolina	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Ohio	[is.na(	peilingen_2016_538_polls_only_state$weeg_Ohio	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Pennsylvania	[is.na(	peilingen_2016_538_polls_only_state$weeg_Pennsylvania	)] <- 0
peilingen_2016_538_polls_only_state$weeg_Virginia	[is.na(	peilingen_2016_538_polls_only_state$weeg_Virginia	)] <- 0

#aggregate
verschil_demografie_staat <- t(summarise(peilingen_2016_538_polls_only_state,
                                         Alabama_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Alabama	, na.rm=TRUE),	
                                         Alaska_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Alaska	, na.rm=TRUE),	
                                         Arizona_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Arizona	, na.rm=TRUE),	
                                         Arkansas_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Arkansas	, na.rm=TRUE),	
                                         California_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_California	, na.rm=TRUE),	
                                         Colorado_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Colorado	, na.rm=TRUE),	
                                         Connecticut_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Connecticut	, na.rm=TRUE),	
                                         Delaware_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Delaware	, na.rm=TRUE),	
                                         DC_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_DC	, na.rm=TRUE),	
                                         Florida_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Florida	, na.rm=TRUE),	
                                         Georgia_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Georgia	, na.rm=TRUE),	
                                         Hawaii_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Hawaii	, na.rm=TRUE),	
                                         Idaho_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Idaho	, na.rm=TRUE),	
                                         Illinois_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Illinois	, na.rm=TRUE),	
                                         Indiana_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Indiana	, na.rm=TRUE),	
                                         Iowa_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Iowa	, na.rm=TRUE),	
                                         Kansas_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Kansas	, na.rm=TRUE),	
                                         Kentucky_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Kentucky	, na.rm=TRUE),	
                                         Louisiana_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Louisiana	, na.rm=TRUE),	
                                         Maine_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Maine	, na.rm=TRUE),	
                                         Maryland_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Maryland	, na.rm=TRUE),	
                                         Massachusetts_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Massachusetts	, na.rm=TRUE),	
                                         Michigan_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Michigan	, na.rm=TRUE),	
                                         Minnesota_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Minnesota	, na.rm=TRUE),	
                                         Mississippi_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Mississippi	, na.rm=TRUE),	
                                         Missouri_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Missouri	, na.rm=TRUE),	
                                         Montana_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Montana	, na.rm=TRUE),	
                                         Nebraska_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Nebraska	, na.rm=TRUE),	
                                         Nevada_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Nevada	, na.rm=TRUE),	
                                         NewHampshire_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NewHampshire	, na.rm=TRUE),	
                                         NewJersey_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NewJersey	, na.rm=TRUE),	
                                         NewMexico_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NewMexico	, na.rm=TRUE),	
                                         NewYork_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NewYork	, na.rm=TRUE),	
                                         NorthCarolina_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NorthCarolina	, na.rm=TRUE),	
                                         NorthDakota_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_NorthDakota	, na.rm=TRUE),	
                                         Ohio_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Ohio	, na.rm=TRUE),	
                                         Oklahoma_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Oklahoma	, na.rm=TRUE),	
                                         Oregon_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Oregon	, na.rm=TRUE),	
                                         Pennsylvania_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Pennsylvania	, na.rm=TRUE),	
                                         RhodeIsland_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_RhodeIsland	, na.rm=TRUE),	
                                         SouthCarolina_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_SouthCarolina	, na.rm=TRUE),	
                                         SouthDakota_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_SouthDakota	, na.rm=TRUE),	
                                         Tennessee_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Tennessee	, na.rm=TRUE),	
                                         Texas_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Texas	, na.rm=TRUE),	
                                         Utah_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Utah	, na.rm=TRUE),	
                                         Vermont_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Vermont	, na.rm=TRUE),	
                                         Virginia_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Virginia	, na.rm=TRUE),	
                                         Washington_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Washington	, na.rm=TRUE),	
                                         WestVirginia_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_WestVirginia	, na.rm=TRUE),	
                                         Wisconsin_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Wisconsin	, na.rm=TRUE),	
                                         Wyoming_verschil_demo_overig	=weighted.mean(Clinto_trump_verschil_demo,	weeg_Wyoming	, na.rm=TRUE)))
colnames(verschil_demografie_staat)[1] <- "verschil_demografie_clinton_trump_staat"

verschil_demografie_john_staat <- t(summarise(peilingen_2016_538_polls_only_state,
                                              Alabama_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Alabama	, na.rm=TRUE),	
                                              Alaska_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Alaska	, na.rm=TRUE),	
                                              Arizona_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Arizona	, na.rm=TRUE),	
                                              Arkansas_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Arkansas	, na.rm=TRUE),	
                                              California_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_California	, na.rm=TRUE),	
                                              Colorado_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Colorado	, na.rm=TRUE),	
                                              Connecticut_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Connecticut	, na.rm=TRUE),	
                                              Delaware_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Delaware	, na.rm=TRUE),	
                                              DC_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_DC	, na.rm=TRUE),	
                                              Florida_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Florida	, na.rm=TRUE),	
                                              Georgia_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Georgia	, na.rm=TRUE),	
                                              Hawaii_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Hawaii	, na.rm=TRUE),	
                                              Idaho_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Idaho	, na.rm=TRUE),	
                                              Illinois_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Illinois	, na.rm=TRUE),	
                                              Indiana_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Indiana	, na.rm=TRUE),	
                                              Iowa_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Iowa	, na.rm=TRUE),	
                                              Kansas_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Kansas	, na.rm=TRUE),	
                                              Kentucky_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Kentucky	, na.rm=TRUE),	
                                              Louisiana_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Louisiana	, na.rm=TRUE),	
                                              Maine_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Maine	, na.rm=TRUE),	
                                              Maryland_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Maryland	, na.rm=TRUE),	
                                              Massachusetts_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Massachusetts	, na.rm=TRUE),	
                                              Michigan_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Michigan	, na.rm=TRUE),	
                                              Minnesota_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Minnesota	, na.rm=TRUE),	
                                              Mississippi_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Mississippi	, na.rm=TRUE),	
                                              Missouri_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Missouri	, na.rm=TRUE),	
                                              Montana_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Montana	, na.rm=TRUE),	
                                              Nebraska_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Nebraska	, na.rm=TRUE),	
                                              Nevada_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Nevada	, na.rm=TRUE),	
                                              NewHampshire_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NewHampshire	, na.rm=TRUE),	
                                              NewJersey_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NewJersey	, na.rm=TRUE),	
                                              NewMexico_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NewMexico	, na.rm=TRUE),	
                                              NewYork_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NewYork	, na.rm=TRUE),	
                                              NorthCarolina_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NorthCarolina	, na.rm=TRUE),	
                                              NorthDakota_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_NorthDakota	, na.rm=TRUE),	
                                              Ohio_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Ohio	, na.rm=TRUE),	
                                              Oklahoma_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Oklahoma	, na.rm=TRUE),	
                                              Oregon_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Oregon	, na.rm=TRUE),	
                                              Pennsylvania_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Pennsylvania	, na.rm=TRUE),	
                                              RhodeIsland_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_RhodeIsland	, na.rm=TRUE),	
                                              SouthCarolina_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_SouthCarolina	, na.rm=TRUE),	
                                              SouthDakota_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_SouthDakota	, na.rm=TRUE),	
                                              Tennessee_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Tennessee	, na.rm=TRUE),	
                                              Texas_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Texas	, na.rm=TRUE),	
                                              Utah_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Utah	, na.rm=TRUE),	
                                              Vermont_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Vermont	, na.rm=TRUE),	
                                              Virginia_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Virginia	, na.rm=TRUE),	
                                              Washington_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Washington	, na.rm=TRUE),	
                                              WestVirginia_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_WestVirginia	, na.rm=TRUE),	
                                              Wisconsin_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Wisconsin	, na.rm=TRUE),	
                                              Wyoming_verschil_demo_Johns_overig	=weighted.mean(adjpoll_johnson_verschil_demo,	weeg_Wyoming	, na.rm=TRUE)))
colnames(verschil_demografie_john_staat)[1] <- "verschil_demografie_john_staat"

demografie_weeg <- t(summarise(peilingen_2016_538_polls_only_state,
                               Alabama_weeg	=sum(	weeg_Alabama	),
                               Alaska_weeg	=sum(	weeg_Alaska	),
                               Arizona_weeg	=sum(	weeg_Arizona	),
                               Arkansas_weeg	=sum(	weeg_Arkansas	),
                               California_weeg	=sum(	weeg_California	),
                               Colorado_weeg	=sum(	weeg_Colorado	),
                               Connecticut_weeg	=sum(	weeg_Connecticut	),
                               DC_weeg	=sum(	weeg_DC	),
                               Delaware_weeg	=sum(	weeg_Delaware	),
                               Florida_weeg	=sum(	weeg_Florida	),
                               Georgia_weeg	=sum(	weeg_Georgia	),
                               Hawaii_weeg	=sum(	weeg_Hawaii	),
                               Idaho_weeg	=sum(	weeg_Idaho	),
                               Illinois_weeg	=sum(	weeg_Illinois	),
                               Indiana_weeg	=sum(	weeg_Indiana	),
                               Iowa_weeg	=sum(	weeg_Iowa	),
                               Kansas_weeg	=sum(	weeg_Kansas	),
                               Kentucky_weeg	=sum(	weeg_Kentucky	),
                               Louisiana_weeg	=sum(	weeg_Louisiana	),
                               Maine_weeg	=sum(	weeg_Maine	),
                               Maryland_weeg	=sum(	weeg_Maryland	),
                               Massachusetts_weeg	=sum(	weeg_Massachusetts	),
                               Michigan_weeg	=sum(	weeg_Michigan	),
                               Minnesota_weeg	=sum(	weeg_Minnesota	),
                               Mississippi_weeg	=sum(	weeg_Mississippi	),
                               Missouri_weeg	=sum(	weeg_Missouri	),
                               Montana_weeg	=sum(	weeg_Montana	),
                               Nebraska_weeg	=sum(	weeg_Nebraska	),
                               Nevada_weeg	=sum(	weeg_Nevada	),
                               NewHampshire_weeg	=sum(	weeg_NewHampshire	),
                               NewJersey_weeg	=sum(	weeg_NewJersey	),
                               NewMexico_weeg	=sum(	weeg_NewMexico	),
                               NewYork_weeg	=sum(	weeg_NewYork	),
                               NorthCarolina_weeg	=sum(	weeg_NorthCarolina	),
                               NorthDakota_weeg	=sum(	weeg_NorthDakota	),
                               Ohio_weeg	=sum(	weeg_Ohio	),
                               Oklahoma_weeg	=sum(	weeg_Oklahoma	),
                               Oregon_weeg	=sum(	weeg_Oregon	),
                               Pennsylvania_weeg	=sum(	weeg_Pennsylvania	),
                               RhodeIsland_weeg	=sum(	weeg_RhodeIsland	),
                               SouthCarolina_weeg	=sum(	weeg_SouthCarolina	),
                               SouthDakota_weeg	=sum(	weeg_SouthDakota	),
                               Tennessee_weeg	=sum(	weeg_Tennessee	),
                               Texas_weeg	=sum(	weeg_Texas	),
                               Utah_weeg	=sum(	weeg_Utah	),
                               Vermont_weeg	=sum(	weeg_Vermont	),
                               Virginia_weeg	=sum(	weeg_Virginia	),
                               Washington_weeg	=sum(	weeg_Washington	),
                               WestVirginia_weeg	=sum(	weeg_WestVirginia	),
                               Wisconsin_weeg	=sum(	weeg_Wisconsin	),
                               Wyoming_weeg	=sum(	weeg_Wyoming	)))
colnames(demografie_weeg)[1] <- "demografie_weeg"


##############mix polling results, demographic predictions and polls from comparable states together

#merge
gemiddelden_staat_extra <- cbind(gemiddelden_staat,verschil_demografie_staat,verschil_demografie_john_staat,demografie_weeg)

###determine weight of demographic prediciton (states (like florida) with lots of polls are more based on their own polls and less on the demographic prediction)
min_weeg_demo <- 5
max_weeg_demo <- 25

gemiddelden_staat_extra$weeg_demo <- (((max(scale(log(gemiddelden_staat_extra$som_weeg)))-scale(log(gemiddelden_staat_extra$som_weeg)))/
                                         (max(scale(log(gemiddelden_staat_extra$som_weeg)))-min(scale(log(gemiddelden_staat_extra$som_weeg)))))*(max_weeg_demo-min_weeg_demo))+min_weeg_demo

###deteremine weight of polls from othee states (states (like florida) with lots of polls are more based on their own polls and less on the polls from other states)
min_weeg_andere_peiling <- 5
max_weeg_andere_peiling <- 25

gemiddelden_staat_extra$weeg_andere_peiling <- (((max(scale(log(gemiddelden_staat_extra$som_weeg)))-scale(log(gemiddelden_staat_extra$som_weeg)))/
                                                   (max(scale(log(gemiddelden_staat_extra$som_weeg)))-min(scale(log(gemiddelden_staat_extra$som_weeg)))))*(max_weeg_andere_peiling-min_weeg_andere_peiling))+min_weeg_andere_peiling
gemiddelden_staat_extra$weeg_eigen_peiling <- (100-gemiddelden_staat_extra$weeg_demo)*(100-gemiddelden_staat_extra$weeg_andere_peiling)/100

##mis results
gemiddelden_staat_extra$clinton_trump_overall <- ((((((gemiddelden_staat_extra$clinton_trump_verschil_demo*(100-gemiddelden_staat_extra$weeg_andere_peiling))+
                                                        (gemiddelden_staat_extra$verschil_demografie_clinton_trump_staat*gemiddelden_staat_extra$weeg_andere_peiling))/100)+
                                                      gemiddelden_staat_extra$clinton_trump_demografie)*(100-gemiddelden_staat_extra$weeg_demo))+
                                                    (gemiddelden_staat_extra$weeg_demo*gemiddelden_staat_extra$clinton_trump_demografie))/100
gemiddelden_staat_extra$clinton_aangepast <- gemiddelden_staat_extra$clinton+((gemiddelden_staat_extra$clinton_trump_overall-gemiddelden_staat_extra$clinton_trump)/2)
gemiddelden_staat_extra$trump_aangepast <- gemiddelden_staat_extra$trump+((gemiddelden_staat_extra$clinton_trump_overall-gemiddelden_staat_extra$clinton_trump)/-2)


gemiddelden_staat_extra$Johnson_overall <- ((((((gemiddelden_staat_extra$johnson_verschil_demo*(100-gemiddelden_staat_extra$weeg_andere_peiling))+
                                                  (gemiddelden_staat_extra$verschil_demografie_john_staat*gemiddelden_staat_extra$weeg_andere_peiling))/100)+
                                                gemiddelden_staat_extra$johnson_demografie)*(100-gemiddelden_staat_extra$weeg_demo))+
                                              (gemiddelden_staat_extra$weeg_demo*gemiddelden_staat_extra$johnson_demografie))/100  
gemiddelden_staat_extra$stein <- gemiddelden_staat_extra$stein*100
gemiddelden_staat_extra$extra_partijen <- gemiddelden_staat_extra$extra_partijen*100

###correction to get to 100% by state
gemiddelden_staat_extra$mcmullin[is.na(gemiddelden_staat_extra$mcmullin)] <- 0
gemiddelden_staat_extra$totaal <- 100-(gemiddelden_staat_extra$clinton_aangepast+gemiddelden_staat_extra$trump_aangepast+
                                         gemiddelden_staat_extra$Johnson_overall + gemiddelden_staat_extra$stein +
                                         gemiddelden_staat_extra$extra_partijen + gemiddelden_staat_extra$mcmullin)

gemiddelden_staat_extra$clinton_def <- gemiddelden_staat_extra$clinton_aangepast+(gemiddelden_staat_extra$totaal*
                                                                                    (gemiddelden_staat_extra$clinton_aangepast/(gemiddelden_staat_extra$clinton_aangepast+
                                                                                                                                  gemiddelden_staat_extra$trump_aangepast+ gemiddelden_staat_extra$Johnson_overall+gemiddelden_staat_extra$mcmullin)))
gemiddelden_staat_extra$trump_def <- gemiddelden_staat_extra$trump_aangepast+(gemiddelden_staat_extra$totaal*
                                                                                (gemiddelden_staat_extra$trump_aangepast/(gemiddelden_staat_extra$clinton_aangepast+
                                                                                                                            gemiddelden_staat_extra$trump_aangepast+ gemiddelden_staat_extra$Johnson_overall+gemiddelden_staat_extra$mcmullin)))
gemiddelden_staat_extra$johnson_def <- gemiddelden_staat_extra$Johnson_overall+(gemiddelden_staat_extra$totaal*
                                                                                  (gemiddelden_staat_extra$Johnson_overall/(gemiddelden_staat_extra$clinton_aangepast+
                                                                                                                              gemiddelden_staat_extra$trump_aangepast+ gemiddelden_staat_extra$Johnson_overall+gemiddelden_staat_extra$mcmullin)))
gemiddelden_staat_extra$mcmullin_def <- gemiddelden_staat_extra$mcmullin+(gemiddelden_staat_extra$totaal*
                                                                            (gemiddelden_staat_extra$mcmullin/(gemiddelden_staat_extra$clinton_aangepast+
                                                                                                                 gemiddelden_staat_extra$trump_aangepast+ gemiddelden_staat_extra$Johnson_overall+gemiddelden_staat_extra$mcmullin)))
gemiddelden_staat_extra$clinton_def <- gemiddelden_staat_extra$clinton_def /100
gemiddelden_staat_extra$trump_def <- gemiddelden_staat_extra$trump_def/100
gemiddelden_staat_extra$johnson_def <- gemiddelden_staat_extra$johnson_def/100
gemiddelden_staat_extra$mcmullin_def <- gemiddelden_staat_extra$mcmullin_def/100
gemiddelden_staat_extra$stein_def <- gemiddelden_staat_extra$stein/100
gemiddelden_staat_extra$extra_partijen_def <- gemiddelden_staat_extra$extra_partijen/100

##export file
gemiddelden_staat_extra <- merge(gemiddelden_staat_extra,state_abr2,by.x="state", by.y="State")
export <- gemiddelden_staat_extra[c(32,26,27,30,28)]
export <- export[order(export$STATE.ABREVIATION),] 
colnames(export) <- c("STATE ABBREVIATION","Clinton", "Trump", "Stein", "Johnson")
write.csv(export, "2016-submission-format-2.csv", row.names=FALSE, quote=FALSE)
