library(stringr)
library(knitr)
library(dplyr)
library(ggplot2)

#get the data from my 
Raw_text <- read.csv("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/tournamentinfo.txt", header = FALSE)
head(Raw_text)
tail(Raw_text)

#Raw_text1 is just a list version of Raw_text
Raw_text1<- Raw_text[-c(1:4),]
head(Raw_text1)
Raw_text1%>% head()
#both of the statements above do the same thing one just uses the pipe operator to pass the arguement into the function

class(Raw_text1)
#we are taking subsets of the list in these next two variables
name<- Raw_text1[seq(from = 1, to = length(Raw_text1), by = 3)]
#we are grabbing every third row
rating<- Raw_text1[seq(from = 2, to = length(Raw_text1), by = 3)]
#we are not grabbing the ranking rows of the dataset
dashes<- Raw_text1[seq(from = 3, to = length(Raw_text1), by = 3)]
#this is just a throw away subset to check that I'm getting rid of what I think I am

##Extracting Data for different criteria

player_id<- as.integer(str_extract(name,"\\d+"))
#extracting the player id out of the text file 
player_name <- str_trim(str_extract(name, "(\\w+\\s){2,3}"))
#extracts word characters to space character 2 or 3 times depending on the number of names and then removes the spaces with the trim function
p_point<- as.numeric(str_extract(name, "\\d.\\d"))
p_rating<- as.integer(str_extract(str_extract(rating, "\\D\\d{3,4}\\D"),"\\d+"))
post_rating <- as.integer(str_extract_all(str_extract_all(str_extract_all(rating, "\\D\\d{3,4}\\D"),"[>]\\d+"),"\\d+"))
#this extracts out their rating specifically 
state <- str_extract(rating, "\\w{2,2}")
#extracts the state out of the rating strings
opponent_id1 <- str_extract_all(name,"\\d+\\|")
opponent_id <-str_extract_all(opponent_id1,"\\d+")


##Turning list into Dataset
obs<- sapply(opponent_id,length)
matches_played<-seq_len(max(obs))
#Using the matches played vector to collect each opponent from each player
mat<-t(sapply(opponent_id, "[", i =matches_played))
#transposing each column vector into a row to give us a list of who every player played
df2<-as.data.frame(mat)


##Replacing Id with rankings
key <- data.frame(player_id, p_rating)
df3<-df2
#reference table to match player ids to player ratings
df3[]<-key$p_rating[match(unlist(df3), key$player_id)]
kable(head(df3))

#Calculating the average opponent rating 
df3$oppAvg <- round(apply(df3, 1, mean, na.rm=TRUE))
kable(head(df3))


df<-data.frame(player_id, player_name, state,p_point, p_rating,post_rating, df3$oppAvg)
colnames(df)<-c("ID","name", "State", "Point", "Pre_Match_Rating","Post_Rating", "Opponent_Average")

kable(head(df,10))

## A bit of variable analysis
cor(x=df$Pre_Match_Rating, y =df$Opponent_Average)

cor(x=df$Pre_Match_Rating, y=df$Point)
#having a higher Pre_Match Ranking infers that you will score more points 

df$Rating_Change <- df$Post_Rating - df$Pre_Match_Rating
cor(x=df$Rating_Change, y = df$Point)

write.csv(df, file = "C:/Temp/Chess.csv", row.names= FALSE)


