---
title       : Human Activity Recognition
subtitle    : Practical Machine Learning - Course Project
author      : Sohail Munir Khan
job         : Solutions Director, Customer Success
framework   : html5slides        # {io2012, html5slides, shower, dzslides, ...}
highlighter : prettify  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
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


