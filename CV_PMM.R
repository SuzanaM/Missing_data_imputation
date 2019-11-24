# Instaliraj neophodne pakete
install.packages('mice')
# Ucitaj neophodne pakete
library('mice')

# Ucitaj validacioni set sa 10% nedostajucih podataka
dat_missing <- read.csv("C:/Users/Suzana/Desktop/Iris/iris_validation_missing.csv", header=TRUE, sep=",")
features_missing <- dat_missing[2:6]
# Nadji indekse vrijednosti koje nedostaju
indices_1 <- which(is.na(features_missing[1]))
indices_2 <- which(is.na(features_missing[2]))
indices_3 <- which(is.na(features_missing[3]))
indices_4 <- which(is.na(features_missing[4]))

# Ucitaj originalni validacioni set
dat_original <- read.csv("C:/Users/Suzana/Desktop/Iris/iris_validation.csv", header=TRUE, sep=",")
features_original <- dat_original[2:6]
# Broj nedostajucih vrijednosti
N <- sum(is.na(features_missing))
maxit_test = list(20,25,30,35,40,45,50,55,60,65,70)
donors_number = list(2,3,4,5)
# Napravi vektor da znam koji parametri daju najbolju vrijednosti
mt <- c(rep(20,4), rep(25,4), rep(30,4), rep(35,4), rep(40,4), rep(45,4), rep(50,4), rep(55,4), rep(60,4), rep(65,4), rep(70,4))
dn <- c(rep(donors_number,11))
dn <- unlist(dn)
# Inicijalizuj MAR i RMSE liste:
MAE <- list(rep(0,44))
RMSE <- list(rep(0,44))
# Pocinje krosvalidacija
br1 <- 1
for (i in maxit_test) {
  for (j in donors_number) {
    imputed = mice(features_missing, m=1, maxit = i, method = 'pmm', seed = 500, donors = j)
    imputed <- complete(imputed)
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
}
index_MAE <- which.min(unlist(MAE))
MAE_val <- MAE[index_MAE]
index_RMSE <-which.min(unlist(RMSE))
RMSE_val <- RMSE[index_RMSE]
# Nadji najoptimalnije parametre
donors_opt <- dn[index_MAE]
maxit_opt <- mt[index_MAE]

df_missing <- read.csv("C:/Users/Suzana/Desktop/Iris/MCAR_30.csv", header=TRUE, sep=",")
features_missing_2 <- df_missing[2:6]
N_final <- sum(is.na(features_missing_2))
# Nadji indekse vrijednosti koje nedostaju
indices_1 <- which(is.na(features_missing_2[1]))
indices_2 <- which(is.na(features_missing_2[2]))
indices_3 <- which(is.na(features_missing_2[3]))
indices_4 <- which(is.na(features_missing_2[4]))

df_original <- read.csv("C:/Users/Suzana/Desktop/Iris/iris2.csv", header=TRUE, sep=",")
features_original_2 <- df_original[1:5]
imputed_opt = mice(features_missing_2, m=1, maxit = maxit_opt, method = 'pmm', seed = 500, donors = donors_opt)
imputed_opt <- complete(imputed_opt)

write.csv(imputed_opt,"C:/Users/Suzana/Desktop/Iris/PMM_imputed_MCAR.csv", row.names = TRUE)
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

