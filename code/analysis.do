cd "$data"
use "working_data.dta", clear

oaxaca log_hwage urban east edu_years health political single_child han contract good_job state_owned industry_type_2 industry_type_3 self_employed family_helper , by(women)





