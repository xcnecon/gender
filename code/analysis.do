// 2013
cd "$data"
use "working_data_2013.dta", clear
//summary statistics
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 1, statistics(mean median)
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 0, statistics(mean median)
// oaxaca decomposition
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper, by(women) pooled

// 2018
cd "$data"
use "working_data_2018.dta", clear
// summary statistics
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 1, statistics(mean median)
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 0, statistics(mean median)
// pooled regression
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper
// separate regression
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 1
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 0
// Oaxaca decomposition
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper, by(women) pooled

// Oaxaca decomposition for unmarried
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 1 & age < 50, by(women) pooled
// Oaxaca decomposition for married 
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 0 & age < 50, by(women) pooled

// Regression results for unmarried
// pooled regression
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if  unmarried == 1 & age < 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 1 & women == 1 & age < 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 1 & women == 0 & age < 50

// Regression results for married
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 0 & age < 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 0 & women == 1 & age < 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 0 & women == 0 & age < 50


// Oaxaca decomposition for under 26
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age <= 26, by(women) pooled
// Oaxaca decomposition for 26 to 50
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 25 & age < 50, by(women) pooled
// Oaxaca decomposition for over 50
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 50, by(women) pooled

// Regression results for under 26
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age <= 25
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age <= 25 & women == 1
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age <= 25 & women == 0

// Regression results for 26 to 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 26 & age < 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 26 & age < 50 & women == 1
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 26 & age < 50 & women == 0

// Regression results for over 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 50
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 50 & women == 1
reg log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 50 & women == 0





