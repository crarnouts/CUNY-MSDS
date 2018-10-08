library(stringr)
library(knitr)
library(dplyr)
library(ggplot2)
library(tidyr)

FIFA.df <- read.csv("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/FIFA_RANKING.csv", header = TRUE)
colnames(FIFA.df)[7]<- "Current Year"
colnames(FIFA.df)[9]<- "Last Year"
colnames(FIFA.df)[11]<- "Two Years Ago"
colnames(FIFA.df)[13]<- "Three Years Ago"



#I want to consolidate all of the averages
FIFA_gather<-gather(FIFA.df,Year,Average_Points,7,9,11,13)
FIFA_gather<-gather(FIFA_gather,Year_2,Weighted_Average_Points,7,8,9)
FIFA_gather$Year_2 <- NULL
#This was my initial strategy to consolidate all of the averages and the weighted averages I was able to reduce the
#the number of columns from 18 to 12 but then I discovered there was a better way to do it because of the way the data
#was structed

#since the data was structured in an uneccessary way where each year there was a record of not only the team's
#metrics for that year but also the team's metrics for previous years which is not valuable information because that historical
#data is already contained in previous rows 
#An example would be the entry for germany in 2004 would also have their data for 2003,2002, and 2001 but we already have this
#data in other rows 

#pulling out the year from the rank_date
test_year<-substring(FIFA.df$rank_date,5,10)
test_year_part_one<-str_sub(FIFA.df$rank_date,-2,-1)
test_year_part_two<-str_sub(FIFA.df$rank_date,-4,-3)
Year<-paste(test_year_part_two,test_year_part_one,sep = "")
FIFA.df$Year<-Year

#For every year but the current year I want to use the previous year point columns so that I'm sure that I am encapsulating
#the entire year's worth of data
FIFA.df$Year<-as.numeric(FIFA.df$Year)
FIFA.df$Previous_Year<-FIFA.df$Year-1
FIFA_2<- FIFA.df[c(1,2,3,4,5,6,7,8,9,10,15,17,18)]

FIFA_Previous_Year<-FIFA_2[c(1,2,3,9,12)]
colnames(FIFA_Previous_Year)[4]<-"Points"

FIFA_Historical_Points<-FIFA_Previous_Year
#This is the final dataset that I would run analysis againist

cor(FIFA_Historical_Points$rank,FIFA_Historical_Points$Points)
#There is a negative correlation between a team's rank and the number of points they scored that year which makes sense
#better teams score more and are ranked in the lower numbers

ggplot(FIFA_Historical_Points, aes(x=rank, y=Points))+geom_point()
#I noticed that there were a lot of instances of countries having 0 points
#most likely from back when the rankings weren't kept up as well

FIFA_Historical_2<- filter(FIFA_Historical_Points,Points!= 0)

cor(FIFA_Historical_2$rank,FIFA_Historical_2$Points)
ggplot(FIFA_Historical_2, aes(x=rank, y=Points))+geom_point()
#The correlation between the variables is much stronger once I filter out the zeroes
