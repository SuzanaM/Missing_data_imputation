## Install and load packages
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
biocLite("impute")
library(impute)

# Ucitaj validacioni set sa 10% nedostajucih podataka
dat_missing <- read.csv("C:/Users/Suzana/Desktop/Iris/iris_validation_missing_KNN.csv", header=TRUE, sep=",")
features_missing <- dat_missing[2:6]
# Nadji indekse vrijednosti koje nedostaju
indices_1 <- which(is.na(features_missing[1]))
indices_2 <- which(is.na(features_missing[2]))
indices_3 <- which(is.na(features_missing[3]))
indices_4 <- which(is.na(features_missing[4]))

# Ucitaj originalni validacioni set
dat_original <- read.csv("C:/Users/Suzana/Desktop/Iris/iris_validation_KNN.csv", header=TRUE, sep=",")
features_original <- dat_original[2:6]
# Broj nedostajucih vrijednostia
N <- sum(is.na(features_missing))

K_test <- c(10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50)

# Inicijalizuj MAE i RMSE liste:
MAE <- list(rep(0,40))
RMSE <- list(rep(0,40))

br1 <- 1
for (i in K_test) {
  dat.imputed <- impute.knn(as.matrix(features_missing) ,k = i, rowmax = 0.8, colmax = 0.8, maxp = 1500, rng.seed=362436069)
  imputed <- dat.imputed$data
  # Sad pogledaj MAE i RMSE 
  s <- 0
  r <- 0
  for (k in indices_1){s <- s+abs(features_original[k,1] - imputed[k,1])
  r <- r+((features_original[k,1] - imputed[k,1])**2)}
  for (k in indices_2){s <- s+abs(features_original[k,2] - imputed[k,2])
  r <- r+((features_original[k,2] - imputed[k,2])**2)}
  for (k in indices_3){s <- s+abs(features_original[k,3] - imputed[k,3])
  r <- r+((features_original[k,3] - imputed[k,3])**2)}
  for (k in indices_4){s <- s+abs(features_original[k,4] - imputed[k,4])
  r <- r+((features_original[k,4] - imputed[k,4])**2)}
  MAE[br1] <- s/N
  RMSE[br1] <- sqrt(r/N)
  br1 <- br1+1
}
index_MAE <- which.min(unlist(MAE))
MAE_val <- MAE[index_MAE]
index_RMSE <-which.min(unlist(RMSE))
RMSE_val <- RMSE[index_RMSE]
# Nadji najoptimalnije parametre
K_opt <- K_test[index_MAE]

df_missing <- read.csv("C:/Users/Suzana/Desktop/Iris/MCAR_30_KNN.csv", header=TRUE, sep=",")
features_missing_2 <- df_missing[2:6]
N_final <- sum(is.na(features_missing_2))
# Nadji indekse vrijednosti koje nedostaju
indices_1 <- which(is.na(features_missing_2[1]))
indices_2 <- which(is.na(features_missing_2[2]))
indices_3 <- which(is.na(features_missing_2[3]))
indices_4 <- which(is.na(features_missing_2[4]))

df_original <- read.csv("C:/Users/Suzana/Desktop/Iris/iris2_KNN.csv", header=TRUE, sep=",")
features_original_2 <- df_original[1:5]
## Perform Bayesian PCA with 2 components
dat.imputed <- impute.knn(as.matrix(features_missing_2) ,k = K_opt, rowmax = 0.8, colmax = 0.8, maxp = 1500, rng.seed=362436069)
imputed_opt <- dat.imputed$data

write.csv(imputed_opt,"C:/Users/Suzana/Desktop/Iris/KNN_imputed_MCAR.csv", row.names = TRUE)
# Izracunaj MAE i RMSE na konacnom skupu
s <- 0
r <- 0
for (k in indices_1){s <- s+abs(imputed_opt[k,1] - features_original_2[k,1])
r <- r+((imputed_opt[k,1] -features_original_2[k,1])**2)}
for (k in indices_2){s <- s+abs(imputed_opt[k,2] - features_original_2[k,2])
r <- r+((imputed_opt[k,2] - features_original_2[k,2])**2)}
for (k in indices_3){s <- s+abs(imputed_opt[k,3] - features_original_2[k,3])
r <- r+((imputed_opt[k,3] - features_original_2[k,3])**2)}
for (k in indices_4){s <- s+abs(imputed_opt[k,4] - features_original_2[k,4])
r <- r+((imputed_opt[k,4] - features_original_2[k,4])**2)}
MAE_final <- s/N_final
RMSE_final <- sqrt(r/N_final)
