* -----------------------------------------------------------------------------
* CHIP 2018 Data Post-Cleaning and Variable Construction
* This script processes the merged CHIP 2018 data, cleans missing values,
* constructs new variables, and prepares the final analysis dataset.
* -----------------------------------------------------------------------------

use "CHIP_2018_merged.dta", clear

* =========================
* 1. Filter to Working Individuals
* =========================
* Keep only individuals who are working (A20 == 1)
keep if A20 == 1
* Remove work status variable (no longer needed)
drop A20
* Remove employers (C03_1 == 1)
drop if C03_1 == 1

* =========================
* 2. Handle Missing and Invalid Values
* =========================
replace C07_4 = 0 if C07_4 < 0 // Set unknown/negative subsidy part 1 to 0
replace C07_5 = 0 if C07_5 < 0 // Set unknown/negative subsidy part 2 to 0
drop if A04_1 < 0              // Drop if birth year is missing/invalid
drop if C05_1 < 0              // Drop if income is missing/invalid
replace A13_3 = 0 if A13_3 < 0 // Set unknown education years to 0
replace A13_1 = 1 if A13_1 < 0 // Set unknown education level to 1 (lowest)
drop if C01_1 <= 0             // Drop if work months missing/invalid
drop if C01_2 <= 0             // Drop if work days missing/invalid
drop if C01_3 <= 0             // Drop if work hours missing/invalid
drop if C03_3 < 0              // Drop if industry type missing/invalid

* =========================
* 3. Construct Key Variables
* =========================
* Total annual subsidy
gen subsidy = C07_4 + C07_5
label var subsidy "Total subsidy (C07_4 + C07_5)"
drop C07_4 C07_5

* Age (as of 2018)
gen age = 2018 - A04_1
label var age "Age"

* Annual wage (income + 12*subsidy)
gen wage = C05_1 + subsidy * 12
label var wage "Wage"
drop C05_1 subsidy
drop if wage <= 100 // Drop implausibly low wage values

* =========================
* 4. Demographic and Socioeconomic Variables
* =========================
* Health status: 1 = healthy, 0 = unhealthy (A16_1: 4/5 = unhealthy)
gen health = 1 
replace health = 0 if A16_1 == 4 | A16_1 == 5
label var health "Health status"
drop A16_1

* Political status: 1 = party member/cadre, 0 = otherwise
gen political = 1 if A07_1 == 1 | A07_1 == 2
replace political = 0 if A07_1 != 1 & A07_1 != 2
label var political "Political status"
drop A07_1

* Education years and level
rename A13_3 edu_years
rename A13_1 edu_level
replace edu_level = 0 if edu_level <= 2
replace edu_level = 1 if edu_level == 3
replace edu_level = 2 if edu_level == 4 | edu_level == 5 | edu_level == 6
replace edu_level = 3 if edu_level == 7
replace edu_level = 4 if edu_level == 8
replace edu_level = 5 if edu_level == 9

* Education level dummies
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

* Elite university dummy
gen elite_uni = 0
replace elite_uni = 1 if edu_level >= 4 & A15_7 <=2
drop A15_7
label var elite_uni "Elite university"

* Single child dummy
gen single_child = 1 if A08_1 == 1
replace single_child = 0 if A08_1 != 1
label var single_child "Single child"
drop A08_1

* Ethnicity: Han vs. minority
gen han = 1 if A06 == 1
replace han = 0 if A06 != 1
label var han "Han Ethnicity"
drop A06

* =========================
* 5. Work and Wage Variables
* =========================
* Total hours worked per year
gen hours = C01_1 * C01_2 * C01_3
label var hours "Hours worked"
drop C01_1 C01_2 C01_3
drop if hours <= 80 // Drop implausibly low hours

* Hourly wage
gen hourly_wage = wage / hours
label var hourly_wage "Hourly wage"

* Log hourly wage and log wage
gen log_hwage = log(hourly_wage)
label var log_hwage "Log Hourly wage"
gen log_wage = log(wage)
label var log_wage "Log Wage"

* =========================
* 6. Region and Demographic Dummies
* =========================
* Eastern region dummy (based on province code)
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

* Gender dummy: 1 = women, 0 = men
gen women = 1 if A03 == 2
replace women = 0 if A03 == 1
label var women "Women"
drop A03

* Job type dummies
gen self_employed = 0
replace self_employed = 1 if C03_1 == 3
label var self_employed "Self-employed"
gen family_helper = 0
replace family_helper = 1 if C03_1 == 4
label var family_helper "Family helper"
drop C03_1

* Military status dummy
gen military = 1 if A07_2 == 1
replace military = 0 if A07_2 != 1
label var military "Military status"
drop A07_2

* Contract type dummy
gen contract = 1 if C07_1 == 1 | C07_1 == 2
replace contract = 0 if C07_1 != 1 & C07_1 != 2
label var contract "Contract type"
drop C07_1

* Marital status dummy: 1 = unmarried, 0 = married/widowed/divorced
gen unmarried = 0
replace unmarried = 1 if A05 == 8 | A05 == 4 | A05 == 9 
label var unmarried "Unmarried"
drop A05

* Non-education years (potential experience)
gen non_edu_years = 2018 - A04_1 - edu_years
drop A04_1
label var non_edu_years "Non-education years"

* Good job dummy (job rank)
gen good_job = 0
replace good_job = 1 if C03_4 == 1 | C03_4 == 2
label var good_job "Good job"
drop C03_4

* =========================
* 7. Employer and Industry Variables
* =========================
* Employer ownership type
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

* Industry type dummies
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

* =========================
* 8. Save Final Dataset
* =========================
* Save the processed and cleaned dataset for analysis
save "working_data_2018.dta", replace

* -----------------------------------------------------------------------------
* CHIP 2013 Data Post-Cleaning and Variable Construction
* This section processes the merged CHIP 2013 data, cleans missing values,
* constructs new variables, and prepares the final analysis dataset for 2013.
* -----------------------------------------------------------------------------

use "CHIP_2013_merged.dta", clear

* =========================
* 1. Filter to Working Individuals
* =========================
* Keep only individuals who are working (a19 == 1)
keep if a19 == 1
* Remove work status variable (no longer needed)
drop a19
* Remove employers (c03_1 == 1)
drop if c03_1 == 1

* =========================
* 2. Handle Missing and Invalid Values
* =========================
replace c07_4 = 0 if c07_4 < 0 // Set unknown/negative subsidy part 1 to 0
replace c07_5 = 0 if c07_5 < 0 // Set unknown/negative subsidy part 2 to 0
drop if a04_1 < 0              // Drop if birth year is missing/invalid
drop if c05_1 < 0              // Drop if income is missing/invalid
replace a13_2 = 0 if a13_2 < 0 // Set unknown education years to 0
replace a13_1 = 1 if a13_1 < 0 // Set unknown education level to 1 (lowest)
drop if c01_1 <= 0             // Drop if work months missing/invalid
drop if c01_2 <= 0 | c01_2 > 31             // Drop if work days missing/invalid
drop if c01_3 <= 0 | c01_3 > 24         // Drop if work hours missing/invalid
drop if c03_3 < 0              // Drop if industry type missing/invalid

* =========================
* 3. Construct Key Variables
* =========================
* Total annual subsidy
replace c07_4 = 0 if c07_4 < 0 | c07_4 == . // Set unknown/negative subsidy part 1 to 0
replace c07_5 = 0 if c07_5 < 0 | c07_5 == . // Set unknown/negative subsidy part 2 to 0
gen subsidy = c07_4 + c07_5
label var subsidy "Total subsidy (c07_4 + c07_5)"
drop c07_4 c07_5

* Age (as of 2013)
gen age = 2013 - a04_1
label var age "Age"

* Annual wage (income + 12*subsidy)
gen wage = c05_1 + subsidy * 12
label var wage "Wage"
drop c05_1 subsidy
drop if wage <= 100 // Drop implausibly low wage values

* =========================
* 4. Demographic and Socioeconomic Variables
* =========================
* Health status: 1 = healthy, 0 = unhealthy (a16_1: 4/5 = unhealthy)
gen health = 1 
replace health = 0 if a16_1 == 4 | a16_1 == 5
label var health "Health status"
drop a16_1

* Political status: 1 = party member/cadre, 0 = otherwise
gen political = 1 if a07_1 == 1 | a07_1 == 2
replace political = 0 if a07_1 != 1 & a07_1 != 2
label var political "Political status"
drop a07_1

* Education years and level
replace a13_1 = 1 if a13_1 < 0 | a13_1 == . // Set unknown education level to 1 (lowest)
replace a13_2 = 0 if a13_2 < 0 | a13_2 == . // Set unknown education years to 0
rename a13_2 edu_years
rename a13_1 edu_level
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

* Elite university dummy
replace a15_7 = 0 if a15_7 == . // Set unknown university type to 0
gen elite_uni = 0
replace elite_uni = 1 if edu_level >= 4 & a15_7 <=2
drop a15_7
label var elite_uni "Elite university"

* Single child dummy
gen single_child = 1 if a08_1 == 0
replace single_child = 0 if a08_1 != 0
label var single_child "Single child"
drop a08_1

* Ethnicity: Han vs. minority
gen han = 1 if a06 == 1
replace han = 0 if a06 != 1
label var han "Han Ethnicity"
drop a06

* =========================
* 5. Work and Wage Variables
* =========================
* Total hours worked per year
gen hours = c01_1 * c01_2 * c01_3
label var hours "Hours worked"
drop c01_1 c01_2 c01_3
drop if hours <= 80 // Drop implausibly low hours

* Hourly wage
gen hourly_wage = wage / hours
label var hourly_wage "Hourly wage"

* Log hourly wage and log wage
gen log_hwage = log(hourly_wage)
label var log_hwage "Log Hourly wage"
gen log_wage = log(wage)
label var log_wage "Log Wage"

* =========================
* 6. Region and Demographic Dummies
* =========================
* Eastern region dummy (based on province code)
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

* Gender dummy: 1 = women, 0 = men
gen women = 1 if a03 == 2
replace women = 0 if a03 == 1
label var women "Women"
drop a03

* Job type dummies
gen self_employed = 0
replace self_employed = 1 if c03_1 == 3
label var self_employed "Self-employed"
gen family_helper = 0
replace family_helper = 1 if c03_1 == 4
label var family_helper "Family helper"
drop c03_1

* Contract type dummy
gen contract = 1 if c07_1 == 1 | c07_1 == 2
replace contract = 0 if c07_1 != 1 & c07_1 != 2 | c07_1 == .
label var contract "Contract type"
drop c07_1

* Marital status dummy: 1 = unmarried, 0 = married/widowed/divorced
gen unmarried = 0
replace unmarried = 1 if a05 == 6 | a05 == 3
label var unmarried "Unmarried"
drop a05

* Non-education years (potential experience)
gen non_edu_years = 2013 - a04_1 - edu_years
drop a04_1
label var non_edu_years "Non-education years"


* Good job dummy (job rank)
* Recode c03_4 into 2018 occupation categories
replace c03_4 = 0 if c03_4 == .
* 1. Create a new byte variable for the 2018 categories

* 2. Recode 2013 codes into 2018 categories:
*  1 = 单位(部门)负责人  ← 2013 codes 1–4
replace c03_4 = 1 if inrange(c03_4, 1, 4)
*  2 = 专业技术人员      ← 2013 codes 5–17
replace c03_4 = 2 if inrange(c03_4, 5, 17)
*  3 = 办事人员和有关人员 ← 2013 codes 18–21
replace c03_4 = 3 if inlist(c03_4, 18, 19, 20, 21)
*  4 = 商业、服务业人员  ← 2013 codes 22–27
replace c03_4 = 4 if inlist(c03_4, 22, 23, 24, 25, 26, 27)
*  5 = 农林牧渔和水利业生产人员 ← 2013 codes 28–30
replace c03_4 = 5 if inlist(c03_4, 28, 29, 30)
*  6 = 生产、运输设备操作人员及有关人员 ← 2013 codes 31–49
replace c03_4 = 6 if inrange(c03_4, 31, 49)
*  7 = 军人              ← 2013 code 50
replace c03_4 = 7 if c03_4 == 50
*  8 = 不便分类的其他从业人员 ← 2013 code 51
replace c03_4 = 8 if c03_4 == 51
gen good_job = 0
replace good_job = 1 if c03_4 == 1 | c03_4 == 2
label var good_job "Good job"
drop if c03_4 == .
drop c03_4


* =========================
* 7. Employer and Industry Variables
* =========================
* Employer ownership type
gen ownership_type = 1
replace ownership_type = 2 if c03_2 == 1 | c03_2 == 2 | c03_2 == 3 | c03_2 == 5
replace ownership_type = 3 if c03_2 == 6
label var ownership_type "Employer ownership type"
drop c03_2
gen ownership_type_1 = (ownership_type == 1) if !missing(ownership_type)   
gen ownership_type_2 = (ownership_type == 2) if !missing(ownership_type)   
gen ownership_type_3 = (ownership_type == 3) if !missing(ownership_type)   
label var ownership_type_1 "State-owned"
label var ownership_type_2 "Foreign-owned"
label var ownership_type_3 "Private"

* Industry type dummies
gen industry_type = 3
replace industry_type = 1 if c03_3 == 1
replace industry_type = 2 if c03_3 == 2 | c03_3 == 3 | c03_3 == 4 | c03_3 == 5
gen industry_type_1 = (industry_type == 1) if !missing(industry_type)
gen industry_type_2 = (industry_type == 2) if !missing(industry_type)
gen industry_type_3 = (industry_type == 3) if !missing(industry_type)
label var industry_type_1 "Primary industry"
label var industry_type_2 "Secondary industry"
label var industry_type_3 "Tertiary industry"
drop c03_3
drop industry_type

* =========================
* 8. Save Final Dataset
* =========================
* Save the processed and cleaned dataset for analysis
save "working_data_2013.dta", replace