*==============================================================================*
*********************Innovation-led Sustainable development*********************
*==============================================================================*


* ================================================= * 
*** 1. Descriptive statistics and Preliminary tests
* Import "main_data.dta" *
encode Code, gen(ID)
xtset ID Year

** 1.1. Descriptive statistics
sum SDG GII LBR URB INQ GDP FDI

** 1.2. Correlations of variables
pwcorr SDG GII LBR URB INQ GDP FDI, sig

** 1.3. Test for multicollinearity
reg SDG GII LBR URB INQ GDP FDI
vif

** 1.4. Test for heteroskedasticity, autocorrelation, and cross-sectional dependence
xtreg SDG GII LBR URB INQ GDP FDI, fe
xttest3
xtserial SDG GII LBR URB INQ GDP FDI
xtcdf SDG GII LBR URB INQ FDI

*** 2. Baseline regression
** 2.1. SDG - GII
xtscc SDG GII LBR FDI GDP URB INQ i.Year
krls SDG GII LBR FDI GDP URB INQ i.Year, deriv(d)
drop d_GII d_LBR d_FDI d_GDP d_URB d_INQ d_2012Year d_2013Year d_2014Year d_2015Year d_2016Year d_2017Year d_2018Year d_2019Year d_2020Year d_2021Year d_2022Year d_2023Year 

** 2.2. SDG - INPUT
xtscc SDG INPUT LBR FDI GDP URB INQ i.Year
krls SDG INPUT LBR FDI GDP URB INQ i.Year, deriv(d)
drop d_INPUT d_LBR d_FDI d_GDP d_URB d_INQ d_2012Year d_2013Year d_2014Year d_2015Year d_2016Year d_2017Year d_2018Year d_2019Year d_2020Year d_2021Year d_2022Year d_2023Year

** 2.3. SDG - OUTPUT
xtscc SDG OUTPUT LBR FDI GDP URB INQ i.Year
krls SDG OUTPUT LBR FDI GDP URB INQ i.Year, deriv(d)
drop d_OUTPUT d_LBR d_FDI d_GDP d_URB d_INQ d_2012Year d_2013Year d_2014Year d_2015Year d_2016Year d_2017Year d_2018Year d_2019Year d_2020Year d_2021Year d_2022Year d_2023Year
   
** 2.4. SDG - GII*INQ
gen GIIxINQ = GII * INQ
krls SDG GII GIIxINQ LBR URB INQ GDP FDI i.Year
   
** 2.5. SDG - GII*INPUT
gen INPUTxINQ = INPUT * INQ
krls SDG INPUT INPUTxINQ LBR URB INQ GDP FDI i.Year

** 2.6. SDG - GII*OUTPUT
gen OUTPUTxINQ = OUTPUT * INQ
krls SDG OUTPUT OUTPUTxINQ LBR URB INQ GDP FDI i.Year

*** 3. Heterogeneity analysis
** 3.1. Specific SDGs - GII
krls G1 GII LBR URB INQ GDP FDI i.Year
krls G2 GII LBR URB INQ GDP FDI i.Year
krls G3 GII LBR URB INQ GDP FDI i.Year
krls G4 GII LBR URB INQ GDP FDI i.Year
krls G5 GII LBR URB INQ GDP FDI i.Year
krls G6 GII LBR URB INQ GDP FDI i.Year
krls G7 GII LBR URB INQ GDP FDI i.Year
krls G8 GII LBR URB INQ GDP FDI i.Year
krls G9 GII LBR URB INQ GDP FDI i.Year
krls G10 GII LBR URB INQ GDP FDI i.Year
krls G11 GII LBR URB INQ GDP FDI i.Year
krls G12 GII LBR URB INQ GDP FDI i.Year
krls G13 GII LBR URB INQ GDP FDI i.Year
krls G14 GII LBR URB INQ GDP FDI i.Year
krls G15 GII LBR URB INQ GDP FDI i.Year
krls G16 GII LBR URB INQ GDP FDI i.Year
krls G17 GII LBR URB INQ GDP FDI i.Year

** 3.2. SDG - Innovation input and innovation output
krls SDG IN1 LBR URB INQ GDP FDI i.Year
krls SDG IN2 LBR URB INQ GDP FDI i.Year
krls SDG IN3 LBR URB INQ GDP FDI i.Year
krls SDG IN4 LBR URB INQ GDP FDI i.Year
krls SDG IN5 LBR URB INQ GDP FDI i.Year
krls SDG OUT1 LBR URB INQ GDP FDI i.Year
krls SDG OUT2 LBR URB INQ GDP FDI i.Year

** 3.3. SDG - GII by income levels
krls SDG GII LBR URB INQ GDP FDI i.Year if INCOME == "High"
krls SDG GII LBR URB INQ GDP FDI i.Year if INCOME == "Upper-mid"
krls SDG GII LBR URB INQ GDP FDI i.Year if INCOME == "Low-mid"
krls SDG GII LBR URB INQ GDP FDI i.Year if INCOME == "Low"

** 3.4. SDG - GII by blocs
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "ASEAN"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "AU"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "BRICS"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "CELAC"
krls SDG GII LBR URB INQ GDP FDI i.Year if EU == 1
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "G7"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "OECD"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "OPEC"
krls SDG GII LBR URB INQ GDP FDI i.Year if BLOC == "SAARC"
krls SDG GII LBR URB INQ GDP FDI i.Year if BRI == 1
* ================================================= * 

* =============================== * 
*** 4. Granger non-causality test
* Import granger-test_data.dta**
encode Code, gen(ID)
xtset ID Year

xtgrangert SDG GII
xtgrangert GII SDG
xtgrangert SDG INPUT
xtgrangert INPUT SDG
xtgrangert SDG OUTPUT
xtgrangert OUTPUT SDG
xtgrangert G1 GII
xtgrangert GII G1
xtgrangert G2 GII
xtgrangert GII G2
xtgrangert G3 GII
xtgrangert GII G3
xtgrangert G4 GII
xtgrangert GII G4
xtgrangert G5 GII
xtgrangert GII G5
xtgrangert G6 GII
xtgrangert GII G6
xtgrangert G7 GII
xtgrangert GII G7
xtgrangert G8 GII
xtgrangert GII G8
xtgrangert G9 GII
xtgrangert GII G9
xtgrangert G10 GII, boot(500)
xtgrangert GII G10
xtgrangert G11 GII, boot(500)
xtgrangert GII G11
xtgrangert G12 GII
xtgrangert GII G12
xtgrangert G13 GII
xtgrangert GII G13
xtgrangert G14 GII
xtgrangert GII G14
xtgrangert G15 GII
xtgrangert GII G15
xtgrangert G16 GII
xtgrangert GII G16
xtgrangert G17 GII
xtgrangert GII G17
* =============================== * 

* ===================== * 
*** 5. Robustness check
** 5.1. Robustness check 1: Using different estimation - MMQR
* Import "main_data.dta" *
encode Code, gen(ID)
xtset ID Year

mmqreg SDG GII LBR URB INQ GDP FDI i.Year, q(0.25 0.50 0.75)
mmqreg SDG INPUT LBR URB INQ GDP FDI i.Year, q(0.25 0.50 0.75)
mmqreg SDG OUTPUT LBR URB INQ GDP FDI i.Year, q(0.25 0.50 0.75)

** 5.2. Robustness check 2: Altering proxy of dependent variable
* Import "robustness-check_data.dta" *
encode Code, gen(ID)
xtset ID Year

gen GIIxINQ = GII * INQ
krls SDI GII GIIxINQ LBR URB INQ GDP FDI i.Year

gen INPUTxINQ = INPUT * INQ
krls SDI INPUT INPUTxINQ LBR URB INQ GDP FDI i.Year
  
gen OUTPUTxINQ = OUTPUT * INQ
krls SDI OUTPUT OUTPUTxINQ LBR URB INQ GDP FDI i.Year
* ===================== * 

*==============================================================================*
***************************This is the end of DOFILE****************************
*==============================================================================*