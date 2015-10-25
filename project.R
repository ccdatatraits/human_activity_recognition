# Download Prediction Data from URLs provided

# Applying Data Slicing on `pml_training` for Cross Validation

# Preproccessing
#  Remove Near Zero Variance Predictors
#  Remove Predictors that should not affect any outcome
#  Check for Correlation between Predictors
#  Remove Predictors that have majority NAs

# Applying Parallel Processing Capabilities (optional but helpful)

# Applying Various Prediction Models until Safisfactory Results

# Write Results for Submission


pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

#answers = rep("A", 20)
#pml_write_files(answers)
