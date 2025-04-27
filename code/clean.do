* clean rural data
cd "$data"
use "chip2018_rural_person.dta", clear

* Keep only the variables specified in the variables.qmd file
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C03_2 C03_3 C03_4 C05_1 C07_1 C07_4 C07_5

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

* Save the cleaned dataset
save "CHIP_2018_Rural_cleaned.dta", replace

* clean urban data
use "chip2018_urban_person.dta", clear

* Keep only the variables specified in the variables.qmd file
keep hhcode idcode A03 A04_1 A05 A05_1 A06 A07_1 A07_2 A08_1 A13_1 A13_3 A15_7 A16_1 A20 C01_1 C01_2 C01_3 C03_1 C03_4 C05_1 C07_1 C07_4 C07_5

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

* Save the cleaned dataset
save "CHIP_2018_Urban_cleaned.dta", replace

* merge rural and urban data
use "CHIP_2018_Rural_cleaned.dta", clear
append using "CHIP_2018_Urban_cleaned.dta"
save "CHIP_2018_merged.dta", replace