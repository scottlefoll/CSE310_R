#download the dataset
destfile="fire.csv"
URL <-'https://data.boston.gov/dataset/ac9e373a-1303-4563-b28e-29070229fdfe/resource/91a38b1f-8439-46df-ba47-a30c48845e06/download/tmpfa4gmbis.csv'
if (!file.exists(destfile)) {
  download.file(URL,destfile,method="auto")
}

# Package names
packages <- c("ggplot2", "dplyr", "plyr", "tidyr", "reshape2", "knitr", "lubridate",
              "car", "datetime", "corrplot", "scales", "stringr",  "ggstatsplot",
               "ROCR", "pivottabler", "lubridate", "caret", "summarytools",  "tidyverse")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# read in the data file
raw1_df <- read.csv("fire.csv")
final_df  <- raw1_df[0,]
raw2_df <- read.csv("fire.csv")

head(raw2_df)

# create a total loss column
raw2_df$loss_sum <- raw2_df$estimated_property_loss + raw2_df$estimated_content_loss
# create a fire column
raw2_df$fire <- ifelse(raw2_df$loss_sum >=500, 1,0)
dataset <- raw2_df[raw2_df$fire ==1,]
sp <- count(dataset,vars = "fire")
a <-raw2_df[ sample( which( raw2_df$fire == 0 ) , sp[[2]][1] ) , ]
dataset <- rbind(dataset,a)
final_df <-rbind(final_df,dataset)

# final_df
write.csv(final_df,"pre_processed.csv")
summary(final_df)

#training data

final_df <- read.csv("pre_processed.csv")
loss_sum <- as.numeric(final_df$loss_sum)

str(final_df)

final_df$loss_sum <- as.numeric(final_df$loss_sum)
final_df$district <- as.factor(final_df$district)
final_df$alarm.date <- as.factor(final_df$alarm_date)
final_df$zip <- as.factor(final_df$zip)
final_df$property_use <- as.factor(final_df$property_use)
final_df$fire <- as.factor(final_df$fire)

# Fire risk: 1 = high, 0 = low

set.seed(123)
train_df.index<-sample(row.names(final_df),0.6*dim(final_df)[1])
valid.index<-setdiff(row.names(final_df),train_df.index)
train_df<-final_df[train_df.index, ]
test_df<-final_df[valid.index, ]
# summary(train)

#Visualize the histogram of Total Loss
hist(loss_sum, col="lightsteelblue")

hist(log(train_df$loss_sum), col="lightsteelblue")

#Matrix plots to check the relation between different predictors with Total losses (run all plots together)
#including ratio false to true alarms#
options(warn=-1, col="lightsteelblue")
par(mfrow=c(2,2))
plot(final_df$property_use,log(loss_sum),main = "Total Losses vs Property use",xlab="Property use",ylab="logarithm of Total losses")
plot(final_df$district,log(loss_sum),main = "Total Losses vs District",xlab="District",ylab="logarithm of Total losses")
plot(final_df$zip,log(loss_sum),main = "Total Losses vs Zip code",xlab="Zip code",ylab="logarithm of Total losses")
plot(final_df$incident_type,log(loss_sum),main = "Total Losses vs Incident type",xlab="Incident Type",ylab="logarithm of Total losses")


data <- cor(final_df[sapply(final_df,is.numeric)])

data1 <- melt(data)
options(repr.plot.width = 12, repr.plot.height =10)
ggplot(data1, aes(x = Var1,
                  y = Var2,
                  fill = value))+
                  geom_tile()+
                  theme(text = element_text(size = 14))

## Run cell for clear visualisation
# install.packages("ggplot2")
options(warn=-1)

ggplot(final_df,aes(x = property_use, y = log(loss_sum))) +
                      geom_point(aes(color=fire)) +
                      scale_color_manual(values=c('Orange','Red')) +
                      ggtitle("Total Losses vs Property use") +
                      xlab("Property use") +
                      ylab("logarithm of Total losses") +
                      theme(plot.title = element_text(hjust = 0.5,size=29))

ggplot(final_df,aes(x = district, y = log(loss_sum)))+
                      geom_point(aes(color=fire)) +
                      scale_color_manual(values=c('Orange','Red')) +
                      ggtitle("Total Losses vs District") +
                      xlab("District") +ylab("logarithm of Total losses") +
                      theme(plot.title = element_text(hjust = 0.5,size=29))

ggplot(final_df,aes(x = zip, y = log(loss_sum)))+
                      geom_point(aes(color=fire)) +
                      scale_color_manual(values=c('Orange','Red')) +
                      ggtitle("Total Losses vs Zip code") +
                      xlab("Zip code") +
                      ylab("logarithm of Total losses") +
                      theme(plot.title = element_text(hjust = 0.5,size=29))

ggplot(final_df,aes(x = incident_type, y = log(loss_sum)))+
                      geom_point(aes(color=fire)) +
                      scale_color_manual(values=c('Orange','Red')) +
                      ggtitle("Total Losses vs District") +
                      xlab("Incident Type") +
                      ylab("logarithm of Total losses") +
                      theme(plot.title = element_text(hjust = 0.5,size=29))

#Use a pivot table to get risk per zip code
par(mfrow=c(1,1))
pvt <- PivotTable$new()
pvt$addData(final_df)
pvt$addColumnDataGroups("fire")
pvt$addRowDataGroups("zip")
pvt$defineCalculation(calculationName="fire", summariseExpression="n()")
pvt$evaluatePivot()
pvt

#risk level per zip code
par(mfrow=c(1,1))
pvt <- PivotTable$new()
pvt$addData(final_df)
pvt$addColumnDataGroups("fire")
pvt$addRowDataGroups("district")
pvt$defineCalculation(calculationName="fire", summariseExpression="n()")
pvt$evaluatePivot()
pvt

col_order <- c("Incident Type", "Alarm Date")
train_df$incident_type <- as.numeric(train_df$incident_type)
train_df$alarm.date <- as.numeric(train_df$alarm_date)
train_df$district <- as.numeric(train_df$district)
train_df$zip <- as.numeric(train_df$zip)
train_df$property_use <- as.numeric(train_df$property_use)
test_df$incident_type <- as.numeric(test_df$incident_type)
test_df$alarm_date <- as.numeric(test_df$alarm_date)
test_df$district <- as.numeric(test_df$district)
test_df$zip <- as.numeric(test_df$zip)
test_df$property_use <- as.numeric(test_df$property_use)
viz_df <- train_df[, c(4,5,6,10,11,13,14,26)]

viz_df[is.na(viz_df)] <- 0
train_df[is.na(train_df)] <- 0
test_df[is.na(test_df)] <- 0

# convert the date and time fields over to numeric
viz_df$alarm_time <- as.numeric(strptime(viz_df$alarm_time, "%H:%M:%S"))
viz_df$alarm_date <- as.numeric(str_replace_all(viz_df$alarm_date, '-', ''))

# convert the categorical fields over to numeric
sectors <- list("DO","RX","BO","JP","CH","AB","HP","EB","MT","SB","WR","RS")
sectNums <- list("1","2","3","4","5","6","7","8","9","10","11","12")

for (i in 1:length(sectors)) {
  viz_df$city_section <- str_replace(viz_df$city_section, sectors[[i]], sectNums[[i]])
}

viz_df$city_section = as.numeric(viz_df$city_section)
viz_df$city_section[is.na(viz_df$city_section)] = 13


unique(viz_df[c("city_section")])

# str(viz_df)
head(viz_df)

#correlations
par(mfrow=c(1,1))
correlations <- cor(viz_df)
corrplot(correlations, method="number")
# corrplot(correlations, addCoef.col = 1,    # Change font size of correlation coefficients
        #  number.cex = 0.5, tl.cex = 0.5, width = 1600, height = 1000)

x <- viz_df
y <- train_df[,27]
scales <- list(x=list(relation="free"), y=list(relation="free"))
featurePlot(x=x, y=y, plot="density", scales=scales)

##Logistic Regression
logmodel<-glm(fire~ property_use + incident_type + district +zip, data = train_df, family = binomial)
summary(logmodel)
par(mfrow=c(2,2))
plot(logmodel)

#evaluate performance
glm.probs <- predict(logmodel,type = "response")
glm.probs[1:5]
sum(glm.probs[1:5])/5

glm.pred <- ifelse(glm.probs > 0.64, "1","0")
attach(train_df)
# str(glm.pred)
table(glm.pred,fire)

#performance AUC
par(mfrow=c(1,1))
pred <- predict(logmodel, newdata=test_df,OOB=TRUE)

# summary(pred)
pred <- prediction(as.numeric(pred), as.numeric(test_df$fire))
perf <- performance(pred,"tpr","fpr")
plot(perf, main="lift curve", colorize=T)
str(perf)
#Auc
auc<- performance(pred,measure = "auc")
auc <- auc@y.values[[1]]
auc

limits <- data.frame(cut=perf@alpha.values[[1]], fpr=perf@x.values[[1]],
                      tpr=perf@y.values[[1]])
head(limits)

limits <- limits[order(limits$tpr, decreasing=TRUE),]
head(subset(limits, fpr < 0.2))


# Create a matrix.
M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)



# Arrays - While matrices are confined to two dimensions, arrays can be of any
# number of dimensions. The array function takes a dim attribute which creates
# the required number of dimension. In the below example we create an
# array with two elements which are 3x3 matrices each.

# Create an array.
a <- array(c('green','yellow'),dim = c(3,3,2))
print(a)


# Demonstrate Spawning a child process

is_windows <- function () (tolower(.Platform$OS.type) == "windows")

R_binary <- function () {
  R_exe <- ifelse (is_windows(), "R.exe", "R")
  return(file.path(R.home("bin"), R_exe))
}

ifelse(is_windows(), "Windows", "Linux")
# library(subprocess)

# handle <- spawn_process(R_binary(), c('--no-save'))
# Sys.sleep(1)
# print(handle)
# process_read(handle, PIPE_STDOUT, timeout = 1000)
# process_read(handle, PIPE_STDERR)

# process_write(handle, 'n <- 10\n')
# process_read(handle, PIPE_STDOUT, timeout = 1000)
# process_read(handle, PIPE_STDERR)

# process_write(handle, 'rnorm(n)\n')
# process_read(handle, PIPE_STDOUT, timeout = 1000)
# process_read(handle, PIPE_STDERR)

# process_write(handle, 'q(save = "no")\n')
# process_read(handle, PIPE_STDOUT, timeout = 1000)
# process_read(handle, PIPE_STDERR)

# process_state(handle)
# process_return_code(handle)
