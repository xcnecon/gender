// 2013
cd "$data"
use "working_data_2013.dta", clear
//summary statistics
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 1, statistics(mean median)
tabstat wage hours log_hwage urban east edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if women == 0, statistics(mean median)
// oaxaca decomposition
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper, by(women) pooled

// 2018
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
// Without industry segregation
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper, by(women) pooled
// without ownership segregation
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job industry_type_2 industry_type_3 self_employed family_helper, by(women) pooled
// without job segregation
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han ownership_type_1 ownership_type_2 industry_type_2 industry_type_3, by(women) pooled

// Oaxaca decomposition for unmarried women
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 1, by(women) pooled

// Oaxaca decomposition for married women   
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if unmarried == 0, by(women) pooled

// Oaxaca decomposition for under 25
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age <= 25, by(women) pooled

// Oaxaca decomposition for 25 to 50
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age >= 25 & age <= 50, by(women) pooled

// Oaxaca decomposition for over 50
oaxaca log_hwage east urban edu_years non_edu_years health political single_child han contract good_job ownership_type_1 ownership_type_2 industry_type_2 industry_type_3 self_employed family_helper if age > 50, by(women) pooled

