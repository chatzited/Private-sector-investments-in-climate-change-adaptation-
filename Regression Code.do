import excel "C:\Users\tchatzivasilei\OneDrive - Delft University of Technology\TU-Delft\Research\Firm data analysis\WORKING.xlsx", sheet("Total_sectors") firstrow clear

collapse (sum) Sales Companies Employees, by( Year Aggr_region Sector )
rename Aggr_region Region

save "C:\Users\tchatzivasilei\OneDrive - Delft University of Technology\TU-Delft\Research\Firm data analysis\Sales.dta", replace

import excel "C:\Users\tchatzivasilei\OneDrive - Delft University of Technology\TU-Delft\Research\Firm data analysis\WORKING.xlsx", sheet("Regions_all") firstrow clear

collapse (sum) TotalPurchaseforlocalusem TotalPurchasem NumberofCompaniesallincludin TotalNumberofEmployeesPurch TotalPurchaseImportsm TotalPurchaseDomesticMarketS TotalPurchaseGlobalMarketSha , by( Year NACE AdaptationMeasure Region)

rename NACE Sector
encode Region, generate(id)
encode Sector, generate(sec)

destring Year, replace
merge m:m Year Region Sector using "C:\Users\tchatzivasilei\OneDrive - Delft University of Technology\TU-Delft\Research\Firm data analysis\Sales.dta"
encode AdaptationMeasure, generate(adapt)

*Fixed effect combinations
egen group=group( Region Sector AdaptationMeasure )
egen group2=group( Region Sector)
egen group3=group( Region AdaptationMeasure )
xtset group Year

gen lnSales=ln(Sales)
gen lnInvestment=ln(TotalPurchasem)

*Main regression by sector
xtreg lnSales c.lnInvestment#ibn.sec Companies Employees if sec!=15, fe
est store All_Regions
coefplot All_Regions, keep(*lnInvestment) sort level(99)

*Main Reg by region
reghdfe lnSales c.lnInvestment#ibn.id Companies Employees if sec!=15, a(group3)
est store All_Sec
coefplot All_Sec, keep(*lnInvestment) sort level(99)






