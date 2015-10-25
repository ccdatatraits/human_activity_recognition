# Download Prediction Data from URLs provided
pml_training_data = "pml-training.csv"
pml_testing_data = "pml-testing.csv"

pml_training_url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
pml_testing_url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download.file(pml_training_url, pml_training_data)
download.file(pml_testing_url, pml_testing_data)


pml_training = read.csv(pml_training_data)
pml_testing = read.csv(pml_testing_data)

# Applying Data Slicing on `pml_training` for Cross Validation
library(caret)
library(kernlab)
inTrain <- createDataPartition(y = pml_training$classe, p = 3/4, list = FALSE)

training <- pml_training[inTrain,]
cross <- pml_training[-inTrain,]
# dimension of datasets
rbind("original dataset" = dim(pml_training),
      "training set" = dim(training),
      "crossval set" = dim(cross))

# Preproccessing
#  Remove Near Zero Variance Predictors
nzvInformation <- nearZeroVar(training, saveMetrics = TRUE)
nzvInformation[nzvInformation$nzv,]

nzv <- nearZeroVar(training)
filteredNZVTraining <- training[, -nzv]
colnames(filteredNZVTraining)

#  Remove Predictors that should not affect any outcome
filteredTraining <- filteredNZVTraining[,-which(colnames(filteredNZVTraining) %in% c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "num_window"))]
colnames(filteredTraining)

#  Check for Correlation between Predictors
outputFilteredTraining <- filteredTraining[,-which(colnames(filteredTraining) == "classe")]
tCor <- cor(outputFilteredTraining)
highCorr <- sum(abs(tCor[upper.tri(tCor)]) > .75)
highCorr

#  Remove Predictors that have majority NAs
finalTraining <- filteredTraining #creating another subset to iterate in loop
for(i in 1:length(filteredTraining)) { #for every column in the training dataset
  if( sum( is.na( filteredTraining[, i] ) ) /nrow(filteredTraining) >= .6 ) { #if NAs > 60% of total observations
    for(j in 1:length(finalTraining)) {
      if( length( grep(names(filteredTraining[i]), names(finalTraining)[j]) ) ==1)  { #if the columns are the same:
        finalTraining <- finalTraining[ , -j] #Remove that column
      }
    }
  }
}
#To check the new no. of observations
dim(finalTraining)
dim(filteredTraining)

# Applying Parallel Processing Capabilities (optional but helpful)
library(doMC)
registerDoMC(cores = 8)

# Applying Various Prediction Models until Safisfactory Results (Also adding another preProcess to normalise predictors)
gbm_model <- train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "gbm")
gbm_model
gbm_predict <- predict(gbm_model, cross)
gbm_predict
dim(cross)
length(gbm_predict)
confusionMatrix(gbm_predict, cross$classe)

lda_model <- train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "lda")
lda_model
lda_predict <- predict(lda_model, cross)
lda_predict
dim(cross)
length(lda_predict)
confusionMatrix(lda_predict, cross$classe)

rf_model <- train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "rf")
rf_model
rf_predict <- predict(rf_model, cross)
rf_predict
dim(cross)
length(rf_predict)
confusionMatrix(rf_predict, cross$classe)

# Write Results for Submission
pml_testing_predict <- predict(rf_model, pml_testing)
answers <- as.character(pml_testing_predict)

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(answers)
