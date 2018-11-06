library(RTextTools)
library(tm)
library(wordcloud)
library(e1071)
library(RColorBrewer)	
library(ggplot2)
library(caret)


# Create Ham Dataframe
ham_dir="U:/spamham/easy_ham"
hamFileNames = list.files(ham_dir)

# List of docs
ham_docs_list <- NA
for(i in 1:length(hamFileNames))
{
  filepath<-paste0(ham_dir, "/", hamFileNames[1])  
  text <-readLines(filepath)
  list1<- list(paste(text, collapse="\n"))
  ham_docs_list = c(ham_docs_list,list1)
  
}

# ham data frame
hamDF <-as.data.frame(unlist(ham_docs_list),stringsAsFactors = FALSE)
hamDF$type <- "ham"
colnames(hamDF) <- c("text","type")

# Create Spam Dataframe
spam_dir="U:/spamham/spam_2"
spamFileNames = list.files(spam_dir)

spam_docs_list <- NA
for(i in 1:length(spamFileNames))
{
  filepath<-paste0(spam_dir, "/", spamFileNames[1])  
  text <-readLines(filepath)
  list1<- list(paste(text, collapse="\n"))
  spam_docs_list = c(spam_docs_list,list1)
  
}

spamDF <-as.data.frame(unlist(spam_docs_list),stringsAsFactors = FALSE)
spamDF$type <- "spam"
colnames(spamDF) <- c("text","type")


# creating combined data frame of spam and ham
spam_ham_df <- rbind(hamDF, spamDF)

#Look at the length of the different messages
spam_ham_df$Text_Length <- nchar(spam_ham_df$text)
summary(spam_ham_df$Text_Length)

#gives us an idea of the relationship between text length and whether or not something is spam
ggplot(spam_ham_df, aes(x = Text_Length, fill = type)) +theme_bw()+
  geom_histogram(binwidth = 5)+
  labs(y = "Text Count", x = "Length of Text", title = "Text Length by Label")

# Build a General Word Cloud
set.seed(1234)
wordcloud(words = spam_ham_df$text, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# spam word cloud
set.seed(1234)
wordcloud(words = spamDF$text, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# ham word cloud
set.seed(1234)
wordcloud(words = hamDF$text, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


# Model to assess spam and ham
#use the caret package to create a 70/30 stratified split #classification and regression training 
set.seed(32984)
indexes <- createDataPartition(spam_ham_df$type, times = 1, p =0.7, list = FALSE) #gives back the index of the row numbers for the train set

#assign the training and the test data
train_spam_ham  <- spam_ham_df[indexes,]
test_spam_ham <- spam_ham_df[-indexes,]

#Verify Proportions of data
prop.table(table(train_spam_ham$type))
prop.table(table(test_spam_ham$type))


# Create corpus for training and test data
train_email_corpus <- Corpus(VectorSource(train_spam_ham$text))
test_email_corpus <- Corpus(VectorSource(test_spam_ham$text))

train_clean_corpus <- tm_map(train_email_corpus ,removeNumbers)
test_clean_corpus <- tm_map(test_email_corpus, removeNumbers)

train_clean_corpus <- tm_map(train_clean_corpus, removePunctuation)
test_clean_corpus <- tm_map(test_clean_corpus, removePunctuation)

train_clean_corpus <- tm_map(train_clean_corpus, removeWords, stopwords())
test_clean_corpus  <- tm_map(test_clean_corpus, removeWords, stopwords())

train_clean_corpus<- tm_map(train_clean_corpus, stripWhitespace)
test_clean_corpus<- tm_map(test_clean_corpus, stripWhitespace)

train_email_dtm <- DocumentTermMatrix(train_clean_corpus)
test_email_dtm <- DocumentTermMatrix(test_clean_corpus)

# count function
convert_count <- function(x) {
  y <- ifelse(x > 0, 1,0)
  y <- factor(y, levels=c(0,1), labels=c("No", "Yes"))
  y
}

train_set <- apply(train_email_dtm, 2, convert_count)
test_set <- apply(test_email_dtm, 2, convert_count)

# classification of email
classifier <- naiveBayes(train_set, factor(train_spam_ham$type))

#Predict using the test data
test_pred <- predict(classifier, newdata=test_set)

table(test_pred, test_spam_ham$type)
