---
title: "Human Activity Recognition"
author: "Sohail Munir Khan"
highlighter: prettify
output: pdf_document
job: Solutions Director, Customer Success
knit: slidify::knit2slides
mode: selfcontained
hitheme: zenburn
subtitle: Practical Machine Learning - Course Project
framework: html5slides
widgets: []
fontsize: 8pt
---

## Human Activity Recognition (http://groupware.les.inf.puc-rio.br/har)

1. Large Data can be collected during various human activity levels
2. Quantity is easily retrieved for various activities but rarel the Quality
3. Object of this Project is to identify "classe" (ranging from "A" to "E")

--- .class #id 

## Process

1. Download Prediction Data from URLs provided
2. Applying Data Slicing on `pml_training` for Cross Validation
3. Preproccessing
  + Remove Near Zero Variance Predictors
  + Remove Predictors that should not affect any outcome
  + Check for Correlation between Predictors
  + Remove Predictors that have majority NAs
4. Applying Parallel Processing Capabilities (optional but helpful)
5. Applying Various Prediction Models until Safisfactory Results
6. Write Results for Submission

---

## pml_training (url & dimension) [Download Prediction Data]


```r
pml_training_data = "pml-training.csv"
pml_training_url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(pml_training_url, pml_training_data)
pml_training = read.csv(pml_training_data)
dim(pml_training)
```

```
## [1] 19622   160
```

---

## pml_training (url & dimension) [Download Prediction Data]


```r
pml_testing_data = "pml-testing.csv"
pml_testing_url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(pml_testing_url, pml_testing_data)
pml_testing = read.csv(pml_testing_data)
dim(pml_testing)
```

```
## [1]  20 160
```

---

## Applying Data Slicing on `pml_training`


```r
library(caret)
library(kernlab)
inTrain = createDataPartition(y = pml_training$classe, p = 3/4, list = FALSE)

training = pml_training[inTrain,]
cross = pml_training[-inTrain,]
rbind("original dataset" = dim(pml_training), 
      "training set" = dim(training),
      "crossval set" = dim(cross))
```

```
##                   [,1] [,2]
## original dataset 19622  160
## training set     14718  160
## crossval set      4904  160
```

---

## Remove Near Zero Variance Predictors


```r
nzvInformation = nearZeroVar(training, saveMetrics = TRUE)
nzvInformation[nzvInformation$nzv,]
```

```
##                          freqRatio percentUnique zeroVar  nzv
## new_window                45.57595    0.01358880   FALSE TRUE
## kurtosis_roll_belt      2400.33333    2.11985324   FALSE TRUE
## kurtosis_picth_belt      576.08000    1.71898356   FALSE TRUE
## kurtosis_yaw_belt         45.57595    0.01358880   FALSE TRUE
## skewness_roll_belt      2880.40000    2.10626444   FALSE TRUE
## skewness_roll_belt.1     576.08000    1.79372197   FALSE TRUE
## skewness_yaw_belt         45.57595    0.01358880   FALSE TRUE
## max_yaw_belt             576.08000    0.44163609   FALSE TRUE
## min_yaw_belt             576.08000    0.44163609   FALSE TRUE
## amplitude_yaw_belt        48.16722    0.02717761   FALSE TRUE
## avg_roll_arm              63.00000    1.72577796   FALSE TRUE
## stddev_roll_arm           63.00000    1.72577796   FALSE TRUE
## var_roll_arm              63.00000    1.72577796   FALSE TRUE
## avg_pitch_arm             63.00000    1.72577796   FALSE TRUE
## stddev_pitch_arm          63.00000    1.72577796   FALSE TRUE
## var_pitch_arm             63.00000    1.72577796   FALSE TRUE
## avg_yaw_arm               63.00000    1.72577796   FALSE TRUE
## stddev_yaw_arm            66.00000    1.70539475   FALSE TRUE
## var_yaw_arm               66.00000    1.70539475   FALSE TRUE
## kurtosis_roll_arm        225.03125    1.72577796   FALSE TRUE
## kurtosis_picth_arm       218.21212    1.71218916   FALSE TRUE
## kurtosis_yaw_arm        1800.25000    2.09947004   FALSE TRUE
## skewness_roll_arm        228.60317    1.73257236   FALSE TRUE
## skewness_pitch_arm       218.21212    1.71218916   FALSE TRUE
## skewness_yaw_arm        1800.25000    2.09947004   FALSE TRUE
## max_roll_arm              21.00000    1.57630113   FALSE TRUE
## min_roll_arm              21.00000    1.52194592   FALSE TRUE
## min_pitch_arm             21.00000    1.56271233   FALSE TRUE
## amplitude_roll_arm        21.00000    1.60347873   FALSE TRUE
## amplitude_pitch_arm       22.00000    1.56271233   FALSE TRUE
## kurtosis_roll_dumbbell  3600.50000    2.10626444   FALSE TRUE
## kurtosis_picth_dumbbell 7201.00000    2.14023645   FALSE TRUE
## kurtosis_yaw_dumbbell     45.57595    0.01358880   FALSE TRUE
## skewness_roll_dumbbell  4800.66667    2.11985324   FALSE TRUE
## skewness_pitch_dumbbell 7201.00000    2.13344204   FALSE TRUE
## skewness_yaw_dumbbell     45.57595    0.01358880   FALSE TRUE
## max_yaw_dumbbell         800.11111    0.46201930   FALSE TRUE
## min_yaw_dumbbell         800.11111    0.46201930   FALSE TRUE
## amplitude_yaw_dumbbell    46.16026    0.02038320   FALSE TRUE
## kurtosis_roll_forearm    221.56923    1.71218916   FALSE TRUE
## kurtosis_picth_forearm   221.56923    1.71898356   FALSE TRUE
## kurtosis_yaw_forearm      45.57595    0.01358880   FALSE TRUE
## skewness_roll_forearm    225.03125    1.71898356   FALSE TRUE
## skewness_pitch_forearm   221.56923    1.70539475   FALSE TRUE
## skewness_yaw_forearm      45.57595    0.01358880   FALSE TRUE
## max_roll_forearm          21.33333    1.47438511   FALSE TRUE
## max_yaw_forearm          221.56923    0.29215926   FALSE TRUE
## min_roll_forearm          21.33333    1.48117951   FALSE TRUE
## min_yaw_forearm          221.56923    0.29215926   FALSE TRUE
## amplitude_yaw_forearm     57.37849    0.02038320   FALSE TRUE
## avg_roll_forearm          21.33333    1.70539475   FALSE TRUE
## stddev_roll_forearm       68.00000    1.69180595   FALSE TRUE
## var_roll_forearm          68.00000    1.69180595   FALSE TRUE
## avg_pitch_forearm         64.00000    1.71898356   FALSE TRUE
## stddev_pitch_forearm      32.00000    1.71218916   FALSE TRUE
## var_pitch_forearm         64.00000    1.71898356   FALSE TRUE
## avg_yaw_forearm           64.00000    1.71898356   FALSE TRUE
## stddev_yaw_forearm        65.00000    1.71218916   FALSE TRUE
## var_yaw_forearm           65.00000    1.71218916   FALSE TRUE
```

```r
nzv = nearZeroVar(training)
filteredNZVTraining = training[, -nzv]
colnames(filteredNZVTraining)
```

```
##   [1] "X"                        "user_name"               
##   [3] "raw_timestamp_part_1"     "raw_timestamp_part_2"    
##   [5] "cvtd_timestamp"           "num_window"              
##   [7] "roll_belt"                "pitch_belt"              
##   [9] "yaw_belt"                 "total_accel_belt"        
##  [11] "max_roll_belt"            "max_picth_belt"          
##  [13] "min_roll_belt"            "min_pitch_belt"          
##  [15] "amplitude_roll_belt"      "amplitude_pitch_belt"    
##  [17] "var_total_accel_belt"     "avg_roll_belt"           
##  [19] "stddev_roll_belt"         "var_roll_belt"           
##  [21] "avg_pitch_belt"           "stddev_pitch_belt"       
##  [23] "var_pitch_belt"           "avg_yaw_belt"            
##  [25] "stddev_yaw_belt"          "var_yaw_belt"            
##  [27] "gyros_belt_x"             "gyros_belt_y"            
##  [29] "gyros_belt_z"             "accel_belt_x"            
##  [31] "accel_belt_y"             "accel_belt_z"            
##  [33] "magnet_belt_x"            "magnet_belt_y"           
##  [35] "magnet_belt_z"            "roll_arm"                
##  [37] "pitch_arm"                "yaw_arm"                 
##  [39] "total_accel_arm"          "var_accel_arm"           
##  [41] "gyros_arm_x"              "gyros_arm_y"             
##  [43] "gyros_arm_z"              "accel_arm_x"             
##  [45] "accel_arm_y"              "accel_arm_z"             
##  [47] "magnet_arm_x"             "magnet_arm_y"            
##  [49] "magnet_arm_z"             "max_picth_arm"           
##  [51] "max_yaw_arm"              "min_yaw_arm"             
##  [53] "amplitude_yaw_arm"        "roll_dumbbell"           
##  [55] "pitch_dumbbell"           "yaw_dumbbell"            
##  [57] "max_roll_dumbbell"        "max_picth_dumbbell"      
##  [59] "min_roll_dumbbell"        "min_pitch_dumbbell"      
##  [61] "amplitude_roll_dumbbell"  "amplitude_pitch_dumbbell"
##  [63] "total_accel_dumbbell"     "var_accel_dumbbell"      
##  [65] "avg_roll_dumbbell"        "stddev_roll_dumbbell"    
##  [67] "var_roll_dumbbell"        "avg_pitch_dumbbell"      
##  [69] "stddev_pitch_dumbbell"    "var_pitch_dumbbell"      
##  [71] "avg_yaw_dumbbell"         "stddev_yaw_dumbbell"     
##  [73] "var_yaw_dumbbell"         "gyros_dumbbell_x"        
##  [75] "gyros_dumbbell_y"         "gyros_dumbbell_z"        
##  [77] "accel_dumbbell_x"         "accel_dumbbell_y"        
##  [79] "accel_dumbbell_z"         "magnet_dumbbell_x"       
##  [81] "magnet_dumbbell_y"        "magnet_dumbbell_z"       
##  [83] "roll_forearm"             "pitch_forearm"           
##  [85] "yaw_forearm"              "max_picth_forearm"       
##  [87] "min_pitch_forearm"        "amplitude_roll_forearm"  
##  [89] "amplitude_pitch_forearm"  "total_accel_forearm"     
##  [91] "var_accel_forearm"        "gyros_forearm_x"         
##  [93] "gyros_forearm_y"          "gyros_forearm_z"         
##  [95] "accel_forearm_x"          "accel_forearm_y"         
##  [97] "accel_forearm_z"          "magnet_forearm_x"        
##  [99] "magnet_forearm_y"         "magnet_forearm_z"        
## [101] "classe"
```

---

## Remove Predictors that should not affect any outcome


```r
filteredTraining = filteredNZVTraining[,-which(colnames(filteredNZVTraining) %in% c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "num_window"))]
colnames(filteredTraining)
```

```
##  [1] "roll_belt"                "pitch_belt"              
##  [3] "yaw_belt"                 "total_accel_belt"        
##  [5] "max_roll_belt"            "max_picth_belt"          
##  [7] "min_roll_belt"            "min_pitch_belt"          
##  [9] "amplitude_roll_belt"      "amplitude_pitch_belt"    
## [11] "var_total_accel_belt"     "avg_roll_belt"           
## [13] "stddev_roll_belt"         "var_roll_belt"           
## [15] "avg_pitch_belt"           "stddev_pitch_belt"       
## [17] "var_pitch_belt"           "avg_yaw_belt"            
## [19] "stddev_yaw_belt"          "var_yaw_belt"            
## [21] "gyros_belt_x"             "gyros_belt_y"            
## [23] "gyros_belt_z"             "accel_belt_x"            
## [25] "accel_belt_y"             "accel_belt_z"            
## [27] "magnet_belt_x"            "magnet_belt_y"           
## [29] "magnet_belt_z"            "roll_arm"                
## [31] "pitch_arm"                "yaw_arm"                 
## [33] "total_accel_arm"          "var_accel_arm"           
## [35] "gyros_arm_x"              "gyros_arm_y"             
## [37] "gyros_arm_z"              "accel_arm_x"             
## [39] "accel_arm_y"              "accel_arm_z"             
## [41] "magnet_arm_x"             "magnet_arm_y"            
## [43] "magnet_arm_z"             "max_picth_arm"           
## [45] "max_yaw_arm"              "min_yaw_arm"             
## [47] "amplitude_yaw_arm"        "roll_dumbbell"           
## [49] "pitch_dumbbell"           "yaw_dumbbell"            
## [51] "max_roll_dumbbell"        "max_picth_dumbbell"      
## [53] "min_roll_dumbbell"        "min_pitch_dumbbell"      
## [55] "amplitude_roll_dumbbell"  "amplitude_pitch_dumbbell"
## [57] "total_accel_dumbbell"     "var_accel_dumbbell"      
## [59] "avg_roll_dumbbell"        "stddev_roll_dumbbell"    
## [61] "var_roll_dumbbell"        "avg_pitch_dumbbell"      
## [63] "stddev_pitch_dumbbell"    "var_pitch_dumbbell"      
## [65] "avg_yaw_dumbbell"         "stddev_yaw_dumbbell"     
## [67] "var_yaw_dumbbell"         "gyros_dumbbell_x"        
## [69] "gyros_dumbbell_y"         "gyros_dumbbell_z"        
## [71] "accel_dumbbell_x"         "accel_dumbbell_y"        
## [73] "accel_dumbbell_z"         "magnet_dumbbell_x"       
## [75] "magnet_dumbbell_y"        "magnet_dumbbell_z"       
## [77] "roll_forearm"             "pitch_forearm"           
## [79] "yaw_forearm"              "max_picth_forearm"       
## [81] "min_pitch_forearm"        "amplitude_roll_forearm"  
## [83] "amplitude_pitch_forearm"  "total_accel_forearm"     
## [85] "var_accel_forearm"        "gyros_forearm_x"         
## [87] "gyros_forearm_y"          "gyros_forearm_z"         
## [89] "accel_forearm_x"          "accel_forearm_y"         
## [91] "accel_forearm_z"          "magnet_forearm_x"        
## [93] "magnet_forearm_y"         "magnet_forearm_z"        
## [95] "classe"
```

---

## Check for Correlation between Predictors


```r
outputFilteredTraining = filteredTraining[,-which(colnames(filteredTraining) == "classe")]
tCor = cor(outputFilteredTraining)
highCorr = sum(abs(tCor[upper.tri(tCor)]) > .75)
highCorr
```

```
## [1] NA
```

---

## Remove Predictors that have majority NAs


```r
finalTraining = filteredTraining #creating another subset to iterate in loop
for(i in 1:length(filteredTraining)) { #for every column in the training dataset
  if( sum( is.na( filteredTraining[, i] ) ) /nrow(filteredTraining) >= .6 ) { #if NAs > 60% of total observations
    for(j in 1:length(finalTraining)) {
      if( length( grep(names(filteredTraining[i]), names(finalTraining)[j]) ) ==1)  { #if the columns are the same:
        finalTraining = finalTraining[ , -j] #Remove that column
      }
    }
  }
}
#To check the new no. of observations
dim(finalTraining)
```

```
## [1] 14718    53
```

```r
dim(filteredTraining)
```

```
## [1] 14718    95
```

---

## Applying Parallel Processing Capabilities


```r
library(doMC)
```

```
## Loading required package: foreach
## Loading required package: iterators
## Loading required package: parallel
```

```r
registerDoMC(cores = 8)
```

---

## Applying Prediction Model ("gbm")


```r
gbm_model = train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "gbm", verbose = FALSE)
gbm_predict = predict(gbm_model, cross)
```

---

## Confusion Matrix ("gbm")


```r
confusionMatrix(gbm_predict, cross$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1373   26    0    1    3
##          B   16  899   32    3   10
##          C    4   24  818   30    7
##          D    1    0    4  763    8
##          E    1    0    1    7  873
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9637          
##                  95% CI : (0.9581, 0.9688)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9541          
##  Mcnemar's Test P-Value : 1.451e-06       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9842   0.9473   0.9567   0.9490   0.9689
## Specificity            0.9915   0.9846   0.9839   0.9968   0.9978
## Pos Pred Value         0.9786   0.9365   0.9264   0.9832   0.9898
## Neg Pred Value         0.9937   0.9873   0.9908   0.9901   0.9930
## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
## Detection Rate         0.2800   0.1833   0.1668   0.1556   0.1780
## Detection Prevalence   0.2861   0.1958   0.1801   0.1582   0.1799
## Balanced Accuracy      0.9878   0.9659   0.9703   0.9729   0.9833
```

---

## Applying Prediction Model ("lda")


```r
lda_model = train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "lda", verbose = FALSE)
lda_predict = predict(lda_model, cross)
```

---

## Confusion Matrix ("lda")


```r
confusionMatrix(lda_predict, cross$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1144  140   87   44   47
##          B   31  615   87   23  148
##          C  114  114  570   98   71
##          D  101   34   86  606   97
##          E    5   46   25   33  538
## 
## Overall Statistics
##                                           
##                Accuracy : 0.7082          
##                  95% CI : (0.6953, 0.7209)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.6306          
##  Mcnemar's Test P-Value : < 2.2e-16       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.8201   0.6481   0.6667   0.7537   0.5971
## Specificity            0.9094   0.9269   0.9020   0.9224   0.9728
## Pos Pred Value         0.7825   0.6803   0.5895   0.6558   0.8315
## Neg Pred Value         0.9271   0.9165   0.9276   0.9503   0.9147
## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
## Detection Rate         0.2333   0.1254   0.1162   0.1236   0.1097
## Detection Prevalence   0.2981   0.1843   0.1972   0.1884   0.1319
## Balanced Accuracy      0.8647   0.7875   0.7843   0.8381   0.7849
```

---

## Applying Prediction Model ("rf")


```r
rf_model = train(classe ~ ., data = finalTraining, preProcess = c("center", "scale"), method = "rf", verbose = FALSE)
rf_predict = predict(rf_model, cross)
```

---

## Confusion Matrix ("rf")


```r
confusionMatrix(rf_predict, cross$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1394    5    0    0    0
##          B    0  944    2    0    0
##          C    0    0  850    9    0
##          D    0    0    3  794    2
##          E    1    0    0    1  899
## 
## Overall Statistics
##                                         
##                Accuracy : 0.9953        
##                  95% CI : (0.993, 0.997)
##     No Information Rate : 0.2845        
##     P-Value [Acc > NIR] : < 2.2e-16     
##                                         
##                   Kappa : 0.9941        
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9993   0.9947   0.9942   0.9876   0.9978
## Specificity            0.9986   0.9995   0.9978   0.9988   0.9995
## Pos Pred Value         0.9964   0.9979   0.9895   0.9937   0.9978
## Neg Pred Value         0.9997   0.9987   0.9988   0.9976   0.9995
## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
## Detection Rate         0.2843   0.1925   0.1733   0.1619   0.1833
## Detection Prevalence   0.2853   0.1929   0.1752   0.1629   0.1837
## Balanced Accuracy      0.9989   0.9971   0.9960   0.9932   0.9986
```

---

## Results Summary


```r
pml_testing_predict = predict(rf_model, pml_testing)
answers = as.character(pml_testing_predict)
answers
```

```
##  [1] "B" "A" "B" "A" "A" "E" "D" "B" "A" "A" "B" "C" "B" "A" "E" "E" "A"
## [18] "B" "B" "B"
```

---

## Choices

* Approximately 3/4 (75%) of data is put aside for cross validation
* Near Zero Variance predictors removed
* "X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "num_window" removed as predictors
* Trying to find highly correlated predictors. No pair found that had same variances within .75 correlation
* Removed predictors that had more than 60% NAs
* Each prediction is also preProcessed with making the predictors normalised (center and scale)

---

## Out of Sample Error

* Applied "gbm" as a prediction model. Accuracy: 0.9637 (Out of Sample Error (1 - Accuracy): 0.0363 == 3.63%). Can we do better?
* Applied "lda" as a prediction model. Accuracy: 0.7082 (Out of Sample Error (1 - Accuracy): 0.2918 == 29.18%). Much worse. Trying one more.
* Applied "rf" as a prediction model. Accuracy: 0.9953 (Out of Sample Error (1 - Accuracy): 0.0047 == 0.47%). Much better with Random Forest.
* Used "rf" to predict results for pml_testing. All tests passed :)
