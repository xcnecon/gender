* clean rural data
cd "$root/data"
use "chip2018_rural_person.dta", clear

* Keep only the variables specified in the variables.qmd file
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C05_1 C07_1 C07_4 C07_5

* Convert idcode to string and concatenate to create unique identifier
tostring idcode, gen(idcode_str) force

* Extract province code from hhcode (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop hhcode idcode idcode_str
order ind_code
label var ind_code "Individual code"

* mark rural
gen urban = 0
label var urban "Urban"
order urban

* Label variables according to the descriptions
label var A03 "Gender"
label var A04_1 "Birth year"
label var A05 "Marriage status"
label var A05_1 "First marriage age"
label var A06 "Ethnicity"
label var A07_1 "Political status"
label var A07_2 "Military status"
label var A08_1 "Sibling number (1 = single child)"
label var A13_1 "Education level"
label var A13_3 "Education years"
label var A15_7 "University type"
label var A16_1 "Health"
label var A20 "Work status"
label var C01_1 "Work month"
label var C01_2 "Work day in a month"
label var C01_3 "Work hour per day"
label var C03_1 "Job type"
label var C05_1 "Monthly income"
label var C07_1 "Contract type"
label var C07_4 "Subsidy part 1"
label var C07_5 "Subsidy part 2"

* Create subsidy variable by combining C07_4 and C07_5
gen subsidy = C07_4 + C07_5
label var subsidy "Total subsidy (C07_4 + C07_5)"
drop C07_4 C07_5

* Save the cleaned dataset
save "CHIP_2018_Rural_cleaned.dta", replace

* clean urban data
use "chip2018_urban_person.dta", clear

* Keep only the variables specified in the variables.qmd file
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C05_1 C07_1 C07_4 C07_5

* Convert idcode to string and concatenate to create unique identifier
tostring idcode, gen(idcode_str) force

* Extract province code from hhcode (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop idcode_str hhcode idcode
order ind_code
label var ind_code "Individual code"

* mark urban
gen urban = 1
label var urban "Urban"
order urban

* Label variables according to the descriptions
label var A03 "Gender"
label var A04_1 "Birth year"
label var A05 "Marriage status"
label var A05_1 "First marriage age"
label var A06 "Ethnicity"
label var A07_1 "Political status"
label var A07_2 "Military status"
label var A08_1 "Sibling number (1 = single child)"
label var A13_1 "Education level"
label var A13_3 "Education years"
label var A15_7 "University type"
label var A16_1 "Health"
label var A20 "Work status"
label var C01_1 "Work month"
label var C01_2 "Work day in a month"
label var C01_3 "Work hour per day"
label var C03_1 "Job type"
label var C05_1 "Monthly income"
label var C07_1 "Contract type"
label var C07_4 "Subsidy part 1"
label var C07_5 "Subsidy part 2"

* Create subsidy variable by combining C07_4 and C07_5
gen subsidy = C07_4 + C07_5
label var subsidy "Total subsidy (C07_4 + C07_5)"
drop C07_4 C07_5

* Save the cleaned dataset
save "CHIP_2018_Urban_cleaned.dta", replace

* merge rural and urban data
use "CHIP_2018_Rural_cleaned.dta", clear
append using "CHIP_2018_Urban_cleaned.dta"

* calculate age
gen age = 2018 - A04_1
label var age "Age"
drop A04_1

* add subsity to income
gen wage = C05_1 + subsidy * 12
label var wage "Wage"
drop C05_1 subsidy
drop if wage <= 100

* drop non-working individuals
keep if A20 == 1
drop A20

* health status
gen health = 1 
replace health = 0 if A16_1 == 4 | A16_1 == 5
label var health "Health status"
drop A16_1

* political status
gen political = 1 if A07_1 == 1 | A07_1 == 2
replace political = 0 if A07_1 == 3 | A07_1 == 4
label var political "Political status"
drop A07_1

* education years
rename A13_3 edu_years
drop A13_1
drop A15_7
drop if edu_years < 0

* is single child
gen single_child = 1 if A08_1 == 1
replace single_child = 0 if A08_1 != 1
label var single_child "Single child"
drop A08_1

* divide ethnicity into han and minority
gen han = 1 if A06 == 1
replace han = 0 if A06 == 2
label var han "Han Ethnicity"
drop A06

* calcualte hours worked
gen hours = C01_1 * C01_2 * C01_3
label var hours "Hours worked"
drop C01_1 C01_2 C01_3
drop if hours <= 1

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
gen employer = 0
replace employer = 1 if C03_1 == 1
label var employer "Employer (雇主)"

gen employee = 0
replace employee = 1 if C03_1 == 2
label var employee "Employee (雇员)"

gen self_employed = 0
replace self_employed = 1 if C03_1 == 3
label var self_employed "Self-employed (自营劳动者)"

gen family_helper = 0
replace family_helper = 1 if C03_1 == 4
label var family_helper "Family helper (家庭帮工)"

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

* Save the merged dataset
save "CHIP_2018_merged.dta", replace