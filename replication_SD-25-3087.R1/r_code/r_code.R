# ============================================================= #
# The More, the Merrier? Innovation‐Led Sustainable Development #
# =========== DOI: https://doi.org/10.1002/sd.70292 =========== #
# ============================================================= #

# ---------- #
# 0/ Library #
library(haven)
library(dplyr)
library(plm)
library(tidyverse)
library(psych)
library(car)
library(lmtest)
library(KRLS)
library(sandwich)
# ---------- #

# ----------------------------------------------- #
# 1/ Descriptive statistics and Preliminary tests # 
## 1.0/ Import "main_data.dta" and Set panel data 
maindata <- read_dta("D:/replication_SD-25-3087.R1/clean_data/main_data.dta")
maindata$id <- as.numeric(as.factor(maindata$Code))
maindata <- rename(maindata,
                   year = Year)
pmaindata <- pdata.frame(maindata,
                         index = c("id", "year"))

## 1.1/ Descriptive statistics
Xy1 <- c("SDG", "GII", "LBR", "URB", "INQ", "GDP", "FDI")
describe(pmaindata[, Xy1])

## 1.2/ Correlations of variables
Xy2 <- pmaindata[, c("SDG", "GII", "LBR", "URB", "INQ", "GDP", "FDI")]
ctest <- corr.test(Xy2,
                   method = "pearson",
                   adjust = "none")
print(ctest, short = FALSE)

## 1.3/ Test for multicollinearity
ols <- plm(SDG ~ GII + LBR + URB + INQ + GDP + FDI,
           data = pmaindata,
           index = c("id", "year"),
           model = "pooling")
vif(ols)

## 1.4/ Test for heteroskedasticity, autocorrelation, and cross-sectional dependence
fem <- plm(SDG ~ GII + LBR + URB + INQ + GDP + FDI,
           data = pmaindata,
           index = c("id", "year"),
           model = "within")
bptest(fem, studentize = FALSE)
pwartest(fem)
pcdtest(fem, test = "cd")
# ----------------------------------------------- #

# ---------------------- #
# 2/ Baseline regression #
## 2.1/ SDG-GII
### DKSE
dkse1 <- plm(SDG ~ GII + LBR + URB + INQ + GDP + FDI + factor(year),
             data = pmaindata,
             index = c("id", "year"),
             model = "pooling")
out1 <- coeftest(dkse1, vcov = vcovSCC(dkse1, type = "HC1", maxlag = 2))
print(out1)

### KRLS
X_vars <- c("GII", "LBR", "FDI", "GDP", "URB", "INQ")
X_matrix <- model.matrix(~ . - year + factor(year) - 1, 
                         data = pmaindata[, c(X_vars, "year")])
rows_kept <- rownames(X_matrix)
y_vector <- as.numeric(pmaindata[rows_kept, "SDG"])
final_keep <- !is.na(y_vector)
X <- as.matrix(X_matrix[final_keep, ])
X <- X[, colnames(X) != "factor(year)2011"]
y <- y_vector[final_keep]
krls1 <- krls(X = X, y = y)
summary(krls1)

## 2.2/ SDG - INPUT
### DKSE
dkse2 <- plm(SDG ~ INPUT + LBR + URB + INQ + GDP + FDI + factor(year),
             data = pmaindata,
             index = c("id", "year"),
             model = "pooling")
out2 <- coeftest(dkse2, vcov = vcovSCC(dkse2, type = "HC1", maxlag = 2))
print(out2)

### KRLS
X_vars <- c("INPUT", "LBR", "FDI", "GDP", "URB", "INQ")
X_matrix <- model.matrix(~ . - year + factor(year) - 1, 
                         data = pmaindata[, c(X_vars, "year")])
rows_kept <- rownames(X_matrix)
y_vector <- as.numeric(pmaindata[rows_kept, "SDG"])
final_keep <- !is.na(y_vector)
X <- as.matrix(X_matrix[final_keep, ])
X <- X[, colnames(X) != "factor(year)2011"]
y <- y_vector[final_keep]
krls2 <- krls(X = X, y = y)
summary(krls2)










