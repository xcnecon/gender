use "CHIP_2018_merged.dta", clear

* drop non-working individuals
keep if A20 == 1
drop A20
* drop employers
drop if C03_1 == 1

* missing values
replace C07_4 = 0 if C07_4 < 0 // if people don't know the subsidy, set it to 0
replace C07_5 = 0 if C07_5 < 0 // if people don't know the subsidy, set it to 0
drop if A04_1 < 0 // if people don't know their birth year, drop them
drop if C05_1 < 0 // if people don't know their income or income is negative, drop them
replace A13_3 = 0 if A13_3 < 0 // if people don't know their education years, set it to 0
replace A13_1 = 1 if A13_1 < 0 // if people don't know their education level, set it to 1
drop if C01_1 <= 0 // if people don't know how many months they work, drop them
drop if C01_2 <= 0 // if people don't know how many days they work in a month, drop them
drop if C01_3 <= 0 // if people don't know how many hours they work per day, drop them
drop if C03_3 < 0 // if people don't know their industry type, drop them

* create subsidy variable
gen subsidy = C07_4 + C07_5
label var subsidy "Total subsidy (C07_4 + C07_5)"
drop C07_4 C07_5

* calculate age
gen age = 2018 - A04_1
label var age "Age"

* add subsity to income
gen wage = C05_1 + subsidy * 12
label var wage "Wage"
drop C05_1 subsidy
drop if wage <= 100

* health status
gen health = 1 
replace health = 0 if A16_1 == 4 | A16_1 == 5
label var health "Health status"
drop A16_1

* political status
gen political = 1 if A07_1 == 1 | A07_1 == 2
replace political = 0 if A07_1 != 1 & A07_1 != 2
label var political "Political status"
drop A07_1

* education years
rename A13_3 edu_years

* education level
rename A13_1 edu_level
replace edu_level = 0 if edu_level <= 2
replace edu_level = 1 if edu_level == 3
replace edu_level = 2 if edu_level == 4 | edu_level == 5 | edu_level == 6
replace edu_level = 3 if edu_level == 7
replace edu_level = 4 if edu_level == 8
replace edu_level = 5 if edu_level == 9

gen edu_level_0 = (edu_level == 0) if !missing(edu_level)
gen edu_level_1 = (edu_level == 1) if !missing(edu_level)
gen edu_level_2 = (edu_level == 2) if !missing(edu_level)
gen edu_level_3 = (edu_level == 3) if !missing(edu_level)
gen edu_level_4 = (edu_level == 4) if !missing(edu_level)
gen edu_level_5 = (edu_level == 5) if !missing(edu_level)

label var edu_level_0 "Less than middle school"
label var edu_level_1 "Middle school"
label var edu_level_2 "High school"
label var edu_level_3 "Specialized school"
label var edu_level_4 "Bachelor"
label var edu_level_5 "Master or above"

* elite university
gen elite_uni = 0
replace elite_uni = 1 if edu_level >= 4 & A15_7 <=2
drop A15_7
label var elite_uni "Elite university"

* is single child
gen single_child = 1 if A08_1 == 1
replace single_child = 0 if A08_1 != 1
label var single_child "Single child"
drop A08_1

* divide ethnicity into han and minority
gen han = 1 if A06 == 1
replace han = 0 if A06 != 1
label var han "Han Ethnicity"
drop A06

* calcualte hours worked
gen hours = C01_1 * C01_2 * C01_3
label var hours "Hours worked"
drop C01_1 C01_2 C01_3
drop if hours <= 80

* calcualte hourly wage
gen hourly_wage = wage / hours
label var hourly_wage "Hourly wage"

* log wage
gen log_hwage = log(hourly_wage)
label var log_hwage "Log Hourly wage"

gen log_wage = log(wage)
label var log_wage "Log Wage"

* gen region
gen east = 0
replace east = 1 if province_code == "11" | /// Beijing
                   province_code == "12" | /// Tianjin
                   province_code == "13" | /// Hebei
                   province_code == "31" | /// Shanghai
                   province_code == "32" | /// Jiangsu
                   province_code == "33" | /// Zhejiang
                   province_code == "35" | /// Fujian
                   province_code == "37" | /// Shandong
                   province_code == "44" | /// Guangdong
                   province_code == "46"   /// Hainan

label var east "Eastern region"
drop province_code

* change gender
gen women = 1 if A03 == 2
replace women = 0 if A03 == 1
label var women "Women"
drop A03

* job type dummy
gen self_employed = 0
replace self_employed = 1 if C03_1 == 3
label var self_employed "Self-employed"

gen family_helper = 0
replace family_helper = 1 if C03_1 == 4
label var family_helper "Family helper"

drop C03_1

* Military status
gen military = 1 if A07_2 == 1
replace military = 0 if A07_2 != 1
label var military "Military status"
drop A07_2

* contract type
gen contract = 1 if C07_1 == 1 | C07_1 == 2
replace contract = 0 if C07_1 != 1 & C07_1 != 2
label var contract "Contract type"
drop C07_1

* marital status
gen unmarried = 0 if A05 == 1 | A05 == 2 | A05 == 3
replace unmarried = 1 if A05 != 1 & A05 != 2 & A05 != 3
label var unmarried "Unmarried"
drop A05
drop A05_1

* gen non-education years
gen non_edu_years = 2018 - A04_1 - edu_years
drop A04_1
label var non_edu_years "Non-education years"

* job rank
gen good_job = 0
replace good_job = 1 if C03_4 == 1 | C03_4 == 2
label var good_job "Good job"
drop C03_4

* employer ownership type
gen ownership_type = 1
replace ownership_type = 2 if C03_2 == 1 | C03_2 == 2 | C03_2 == 3 | C03_2 == 5
replace ownership_type = 3 if C03_2 == 6

label var ownership_type "Employer ownership type"
drop C03_2
gen ownership_type_1 = (ownership_type == 1) if !missing(ownership_type)   
gen ownership_type_2 = (ownership_type == 2) if !missing(ownership_type)   
gen ownership_type_3 = (ownership_type == 3) if !missing(ownership_type)   
label var ownership_type_1 "State-owned"
label var ownership_type_2 "Foreign-owned"
label var ownership_type_3 "Private"

* industry type
gen industry_type = 3
replace industry_type = 1 if C03_3 == 1
replace industry_type = 2 if C03_3 == 2 | C03_3 == 3 | C03_3 == 4 | C03_3 == 5
gen industry_type_1 = (industry_type == 1) if !missing(industry_type)
gen industry_type_2 = (industry_type == 2) if !missing(industry_type)
gen industry_type_3 = (industry_type == 3) if !missing(industry_type)
label var industry_type_1 "Primary industry"
label var industry_type_2 "Secondary industry"
label var industry_type_3 "Tertiary industry"
drop C03_3
drop industry_type

* Save the merged dataset
save "working_data.dta", replace