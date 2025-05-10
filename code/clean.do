* -----------------------------------------------------------------------------
* CHIP Data Cleaning Script
* This script cleans and harmonizes CHIP 2018 and 2013 rural and urban datasets.
* It selects relevant variables, creates unique IDs, labels variables, and merges data.
* -----------------------------------------------------------------------------

* =========================
* 1. Clean 2018 Rural Data
* =========================
cd "$data"
use "chip2018_rural_person.dta", clear

* Keep only variables needed for analysis (see variables.qmd)
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A10 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C03_2 C03_3 C03_4 C05_1 C07_1 C07_4 C07_5

* Create unique individual code by concatenating household and person IDs
* Convert idcode to string for concatenation
tostring idcode, gen(idcode_str) force

* Extract province code from household code (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop hhcode idcode idcode_str
order ind_code
label var ind_code "Individual code"

* Mark as rural (urban = 0)
gen urban = 0
label var urban "Urban"
order urban

* generate rural migrant dummy
gen rural_migrant = 0
label var rural_migrant "Rural migrant in urban area"

* Label variables for clarity
label var A03 "Gender"
label var A04_1 "Birth year"
label var A05 "Marriage status"
label var A06 "Ethnicity"
label var A07_1 "Political status"
label var A07_2 "Military status"
label var A08_1 "Sibling number (1 = single child)"
label var A10 "Hukou"
label var A13_1 "Education level"
label var A13_3 "Education years"
label var A15_7 "University type"
label var A16_1 "Health"
label var A20 "Work status"
label var C01_1 "Work month"
label var C01_2 "Work day in a month"
label var C01_3 "Work hour per day"
label var C03_1 "Job type"
label var C03_2 "Ownership type"
label var C03_3 "Industry type"
label var C03_4 "Occupation type"
label var C05_1 "Annual income"
label var C07_1 "Contract type"
label var C07_4 "Subsidy part 1"
label var C07_5 "Subsidy part 2"

* Save cleaned rural 2018 data
save "CHIP_2018_Rural_cleaned.dta", replace

* =========================
* 2. Clean 2018 Urban Data
* =========================
use "chip2018_urban_person.dta", clear

* Keep only variables needed for analysis (see variables.qmd)
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A10 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C03_2 C03_3 C03_4 C05_1 C07_1 C07_4 C07_5 

* Create unique individual code by concatenating household and person IDs
tostring idcode, gen(idcode_str) force

* Extract province code from household code (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop idcode_str hhcode idcode
order ind_code
label var ind_code "Individual code"

* Mark as urban (urban = 1)
gen urban = 1
label var urban "Urban"
order urban

* generate rural migrant dummy
gen rural_migrant = 0
replace rural_migrant = 1 if A10 == 1
label var rural_migrant "Rural migrant in urban area"

* Label variables for clarity
label var A03 "Gender"
label var A04_1 "Birth year"
label var A05 "Marriage status"
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
label var C03_2 "Ownership type"
label var C03_3 "Industry type"
label var C03_4 "Occupation type"
label var C05_1 "Annual income"
label var C07_1 "Contract type"
label var C07_4 "Subsidy part 1"
label var C07_5 "Subsidy part 2"


* Save cleaned urban 2018 data
save "CHIP_2018_Urban_cleaned.dta", replace

* =========================
* 3. Merge 2018 Rural and Urban Data
* =========================
use "CHIP_2018_Rural_cleaned.dta", clear
append using "CHIP_2018_Urban_cleaned.dta"
* Save merged 2018 data
save "CHIP_2018_merged.dta", replace

* =========================
* 4. Clean 2013 Rural Data
* =========================
use "chip2013_rural_person.dta", clear
rename person idcode

* Keep only variables needed for analysis (see variables.qmd)
keep hhcode idcode a03 a04_1 a05 a06 a07_1 a08_1 a10 a13_1 a13_2 a15_7 a16_1 a19 c01_1 c01_2 c01_3 c03_1 c03_2 c03_3 c03_4 c05_1 c07_1 c07_4 c07_5

* Create unique individual code by concatenating household and person IDs
tostring idcode, gen(idcode_str) force

* Extract province code from household code (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop hhcode idcode idcode_str
order ind_code
label var ind_code "Individual code"

* Mark as rural (urban = 0)
gen urban = 0
label var urban "Urban"
order urban

* generate rural migrant dummy
gen rural_migrant = 0
label var rural_migrant "Rural migrant in urban area"

* Label variables for clarity
label var a03 "Gender"
label var a04_1 "Birth year"
label var a05 "Marriage status"
label var a06 "Ethnicity"
label var a07_1 "Political status"
label var a08_1 "Sibling number (0 = single child)"
label var a13_1 "Education level"
label var a13_2 "Education years"
label var a15_7 "University type"
label var a16_1 "Health"
label var a19 "Work status"
label var c01_1 "Work month"
label var c01_2 "Work day in a month"
label var c01_3 "Work hour per day"
label var c03_1 "Job type"
label var c03_2 "Ownership type"
label var c03_3 "Industry type"
label var c03_4 "Occupation type"
label var c05_1 "Annual income"
label var c07_1 "Contract type"
label var c07_4 "Subsidy part 1"
label var c07_5 "Subsidy part 2"

* Save cleaned rural 2013 data
save "CHIP_2013_Rural_cleaned.dta", replace

* =========================
* 5. Clean 2013 Urban Data
* =========================
use "chip2013_urban_person.dta", clear
rename person idcode

* Keep only variables needed for analysis (see variables.qmd)
keep hhcode idcode a03 a04_1 a05 a06 a07_1 a08_1 a10 a13_1 a13_2 a15_7 a16_1 a19 c01_1 c01_2 c01_3 c03_1 c03_2 c03_3 c03_4 c05_1 c07_1 c07_4 c07_5

* Create unique individual code by concatenating household and person IDs
tostring idcode, gen(idcode_str) force

* Extract province code from household code (first 2 digits)
gen province_code = substr(hhcode, 1, 2)

gen ind_code = hhcode + idcode_str
drop idcode_str hhcode idcode
order ind_code
label var ind_code "Individual code"

* Mark as urban (urban = 1)
gen urban = 1
label var urban "Urban"
order urban

* generate rural migrant dummy
gen rural_migrant = 0
replace rural_migrant = 1 if a10 == 1
label var rural_migrant "Rural migrant in urban area"
drop a10

* Label variables for clarity
label var a03 "Gender"
label var a04_1 "Birth year"
label var a05 "Marriage status"
label var a06 "Ethnicity"
label var a07_1 "Political status"
label var a08_1 "Sibling number (0 = single child)"
label var a13_1 "Education level"
label var a13_2 "Education years"
label var a15_7 "University type"
label var a16_1 "Health"
label var a19 "Work status"
label var c01_1 "Work month"
label var c01_2 "Work day in a month"
label var c01_3 "Work hour per day"
label var c03_1 "Job type"
label var c03_2 "Ownership type"
label var c03_3 "Industry type"
label var c03_4 "Occupation type"
label var c05_1 "Annual income"
label var c07_1 "Contract type"
label var c07_4 "Subsidy part 1"
label var c07_5 "Subsidy part 2"

* Save cleaned urban 2013 data
save "CHIP_2013_Urban_cleaned.dta", replace

* =========================
* 6. Merge 2013 Rural and Urban Data
* =========================
use "CHIP_2013_Rural_cleaned.dta", clear
append using "CHIP_2013_Urban_cleaned.dta"
* Save merged 2013 data
save "CHIP_2013_merged.dta", replace

