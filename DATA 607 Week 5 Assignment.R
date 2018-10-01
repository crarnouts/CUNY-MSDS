library(stringr)
library(knitr)
library(dplyr)
library(ggplot2)
library(tidyr)

#get the data from my 
Raw_text <- read.csv("https://raw.githubusercontent.com/crarnouts/CUNY-MSDS/master/Arrival_times_2.csv", header = TRUE)
head(Raw_text)
tail(Raw_text)


is.na(Raw_text) <- Raw_text==''
flights<-Raw_text
colnames(flights)[1:2] = c("Airline", "Status")


flights <- flights %>% fill(Airline)

flights.tidy <- gather(flights,"City","FlightCount",-Airline,-Status)

flights.total <- flights.tidy %>% 
  group_by(Airline) %>% 
  summarise(flights = sum(FlightCount))

flights.time <- flights.tidy %>% 
  group_by(Status) %>% 
  summarise(flights = sum(FlightCount))

flights.time$proportion <- flights.total$flights / sum(flights.total$flights)
flights.total$proportion <- flights.total$flights / sum(flights.total$flights)


ggplot(flights.total,aes(x=Airline,y=flights)) + 
  geom_bar(stat="identity",color = "Blue", fill = "Blue") +
  ggtitle("Flight Count by Airline") +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(flights.time,aes(x=Status,y=flights)) + 
  geom_bar(stat="identity",color = "Blue", fill = "Blue") +
  ggtitle("Flight Count by Airline") +
  theme(plot.title = element_text(hjust = 0.5))

flights.delayed <- flights.tidy %>% 
  group_by(Airline,Status) %>% 
summarise(flights = sum(FlightCount)) %>% 
filter(Status == "delayed ")

flights.total$delayed <- flights.delayed$flights

flights.total$delayed_proportion <- flights.total$delayed / flights.total$flights
flights.total$ontime_proportion <- 1 - flights.total$delayed_proportion

ggplot(flights.total,aes(x=Airline,y=ontime_proportion)) + 
  geom_bar(stat="identity",fill="Blue") +
  ggtitle("Proportion of On Time Flights by Airline ") +
  ylab("proportion") +
  theme(plot.title = element_text(hjust = 0.5))
