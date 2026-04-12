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
library(fixest)
download.file(
  url = "https://raw.githubusercontent.com/friosavila/mmqreg/main/software/R/v1.2.R",
  destfile = "mmqreg.R",
  mode = "wb"
)
source("mmqreg.R")
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
for (i in 2012:2023) {
  pmaindata[[paste0("D", i)]] <- as.integer(pmaindata$year == i)
}
## 2.1/ SDG-GII
### DKSE
dkse1 <- plm(SDG ~ GII + LBR + URB + INQ + GDP + FDI + factor(year),
             data = pmaindata,
             index = c("id", "year"),
             model = "pooling")
out1 <- coeftest(dkse1, vcov = vcovSCC(dkse1, type = "HC1", maxlag = 2))
print(out1)

### KRLS
Y_var <- "SDG"
X_var <- "GII"
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
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
Y_var <- "SDG"
X_var <- "INPUT"
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls2 <- krls(X = X, y = y)
summary(krls2)

## 2.3/ SDG - OUTPUT
### DKSE
dkse3 <- plm(SDG ~ OUTPUT + LBR + URB + INQ + GDP + FDI + factor(year),
             data = pmaindata,
             index = c("id", "year"),
             model = "pooling")
out3 <- coeftest(dkse3, vcov = vcovSCC(dkse3, type = "HC1", maxlag = 2))
print(out3)

### KRLS
Y_var <- "SDG"
X_var <- "OUTPUT"
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls3 <- krls(X = X, y = y)
summary(krls3)

## 2.4/ SDG - GIIxINQ
pmaindata$GIIxINQ <- pmaindata$GII * pmaindata$INQ
Y_var <- "SDG"
X_var <- "GII"
Z_var <- c("GIIxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls4 <- krls(X = X, y = y)
summary(krls4)

## 2.5/ SDG - INPUTxINQ
pmaindata$INPUTxINQ <- pmaindata$INPUT * pmaindata$INQ
Y_var <- "SDG"
X_var <- "INPUT"
Z_var <- c("INPUTxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls5 <- krls(X = X, y = y)
summary(krls5)

## 2.6/ SDG - OUTPUTxINQ
pmaindata$OUTPUTxINQ <- pmaindata$OUTPUT * pmaindata$INQ
Y_var <- "SDG"
X_var <- "OUTPUT"
Z_var <- c("OUTPUTxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls6 <- krls(X = X, y = y)
summary(krls6)
# ---------------------- #

# ------------------------- #
# 3/ Heterogeneity analysis #
## 3.1/ Specific SDGs - GII
X_var <- "GII"
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
for (i in 1:17) {
  Y_var <- paste0("G", i)
  data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
  y <- as.numeric(data[[Y_var]])
  X <- as.matrix(data[, c(X_var, Z_var)])
  
  assign(paste0("krls", i + 6), krls(X = X, y = y))
}
for (i in 7:23) summary(get(paste0("krls", i)))

## 3.2/ SDG - Innovation input and innovation output
Y_var <- "SDG"
GII_subs <- c("IN1", "IN2", "IN3", "IN4", "IN5", "OUT1", "OUT2")
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
for (i in seq_along(GII_subs)) {
  X_var <- GII_subs[i]
  data <- na.omit(pmaindata[, c(Y_var, X_var, Z_var)])
  y <- as.numeric(data[[Y_var]])
  X <- as.matrix(data[, c(X_var, Z_var)])
  
  assign(paste0("krls_", X_var), krls(X = X, y = y))
}
for (s in GII_subs) summary(get(paste0("krls_", s)))

## 3.3/ SDG - GII by income levels
Y_var <- "SDG"
X_var <- "GII"
Z_var <- c("LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
income_levels <- c("High", "Uppder-mid", "Low-mid", "Low")
for (i in income_levels) {
  data <- na.omit(pmaindata[pmaindata$INCOME == i, c(Y_var, X_var, Z_var)])
  y <- as.numeric(data[[Y_var]])
  X <- as.matrix(data[, c(X_var, Z_var)])
  
  assign(paste0("krls_", gsub("-", "_", i)), krls(X = X, y = y))
}

## 3.4/ SDG - GII by blocs
for (i in c("ASEAN", "AU", "BRICS", "CELAC", "G7", "OECD", "OPEC", "SAARC")) {
  data <- na.omit(pmaindata[pmaindata$BLOC == i, c(Y_var, X_var, Z_var)])
  y    <- as.numeric(data[[Y_var]])
  X    <- as.matrix(data[, c(X_var, Z_var)])
  assign(paste0("krls_", i), krls(X = X, y = y))
}

for (i in c("EU", "BRI")) {
  data <- na.omit(pmaindata[pmaindata[[i]] == 1, c(Y_var, X_var, Z_var)])
  y    <- as.numeric(data[[Y_var]])
  X    <- as.matrix(data[, c(X_var, Z_var)])
  assign(paste0("krls_", i), krls(X = X, y = y))
}
# ------------------------- #

# ----------------------------- #
# 4/ Granger non-causality test #
# Note: The Granger non-causality test developed by Juodis et al. (2021) and Xiao et al. (2023)
# is implemented in Stata due to lack of R package.
# Please refer to the file `stata_code.do` for the Stata implementation of Granger non-causality test.
# ----------------------------- #

# ------------------- #
# 5/ Robustness check #
## 5.1/ Robustness check 1: Using different estimation - MMQR
# Note: Import data #
rb1data <- read_dta("D:/replication_SD-25-3087.R1/clean_data/main_data.dta")
rb1data$id <- as.numeric(as.factor(rb1data$Code))
rb1data <- rename(rb1data,
                   year = Year)
prb1data <- pdata.frame(rb1data,
                         index = c("id", "year"))
# ----------------- #

# Note: Get result function #
get_result <- function(res, tau){
  coef <- res[[paste0("tau = ", tau)]][["coefs"]][,1]
  se   <- res[[paste0("tau = ", tau)]][["std. errors"]][,2]
  
  tval <- coef / se
  pval <- 2 * (1 - pnorm(abs(tval)))
  
  data.frame(
    variable = names(coef),
    coef = coef,
    se = se,
    p_value = pval
  )
}
# ------------------------- #

### SDG - GII
cprb1data <- na.omit(prb1data[, c("SDG", "GII", "LBR", "URB", "INQ", "GDP", "FDI", "year")])
rb11 <- mmqreg(SDG ~ GII + LBR + URB + INQ + GDP + FDI,
               data = cprb1data,
               tau = c(0.25, 0.50, 0.75),
               absorb = "year"
)
taus <- c(0.25, 0.50, 0.75)
cat("Observations:", nrow(cprb1data), "\n\n")
for(t in taus){
  cat("=== Quantile", t, "===\n")
  print(get_result(rb11, t))
  cat("\n")
}

### SDG - INPUT
cprb1data <- na.omit(prb1data[, c("SDG", "INPUT", "LBR", "URB", "INQ", "GDP", "FDI", "year")])
rb11 <- mmqreg(SDG ~ INPUT + LBR + URB + INQ + GDP + FDI,
               data = cprb1data,
               tau = c(0.25, 0.50, 0.75),
               absorb = "year"
)
taus <- c(0.25, 0.50, 0.75)
cat("Observations:", nrow(cprb1data), "\n\n")
for(t in taus){
  cat("=== Quantile", t, "===\n")
  print(get_result(rb11, t))
  cat("\n")
}

### SDG - OUTPUT
cprb1data <- na.omit(prb1data[, c("SDG", "OUTPUT", "LBR", "URB", "INQ", "GDP", "FDI", "year")])
rb11 <- mmqreg(SDG ~ OUTPUT + LBR + URB + INQ + GDP + FDI,
               data = cprb1data,
               tau = c(0.25, 0.50, 0.75),
               absorb = "year"
)
taus <- c(0.25, 0.50, 0.75)
cat("Observations:", nrow(cprb1data), "\n\n")
for(t in taus){
  cat("=== Quantile", t, "===\n")
  print(get_result(rb11, t))
  cat("\n")
}

## 5.2/ Robustness check 2: Altering proxy of dependent variable
# Note: Import data #
rb2data <- read_dta("D:/replication_SD-25-3087.R1/clean_data/robustness-check_data.dta")
rb2data$id <- as.numeric(as.factor(rb2data$Code))
rb2data <- rename(rb2data,
                  year = Year)
prb2data <- pdata.frame(rb2data,
                        index = c("id", "year"))
# ----------------- #

### SDG - GIIxINQ
prb2data$GIIxINQ <- prb2data$GII * prb2data$INQ
Y_var <- "SDI"
X_var <- "GII"
Z_var <- c("GIIxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(prb2data[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls25 <- krls(X = X, y = y)
summary(krls25)

### SDG - INPUTxINQ
prb2data$INPUTxINQ <- prb2data$INPUT * prb2data$INQ
Y_var <- "SDI"
X_var <- "INPUT"
Z_var <- c("INPUTxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(prb2data[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls26 <- krls(X = X, y = y)
summary(krls26)

### SDG - OUTPUTxINQ
prb2data$OUTPUTxINQ <- prb2data$OUTPUT * prb2data$INQ
Y_var <- "SDI"
X_var <- "OUTPUT"
Z_var <- c("OUTPUTxINQ", "LBR", "URB", "INQ", "GDP", "FDI", paste0("D", 2012:2023))
data <- na.omit(prb2data[, c(Y_var, X_var, Z_var)])
y <- as.numeric(data[[Y_var]])
X <- as.matrix(data[, c(X_var, Z_var)])
krls27 <- krls(X = X, y = y)
summary(krls27)
# ------------------- #

# ============================================================= #
# ============================ END ============================ #
# ============================================================= #
