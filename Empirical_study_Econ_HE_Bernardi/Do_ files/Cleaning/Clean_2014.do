clear all 
set more off 
capture log close
global name Do_file1

global root "/home/marta/HE/Data/Raw"
log using "$root/metric-log-$name.log", replace text 

import delimited "$root/2014_HHs", replace

/*Drop unuseful string variables */

drop titl version release 

rename idno year
replace year = "2013/2014"

/*** Creating a variable for the SES of heach HH: Title of study (C_TITSTU_1 + C_TITSTU_2)+ being manual worker or not (N_POSPRO_1 + N_POSPRO_2)+ employment status(N_COND_1 + N_COND_2)+ full time or part-time (TIME_1 + TIME_2) + non earned income (RENT_1 + RENT_2) */

gen n_pospro_1 = 1 if (c_pospro_1 == 2) 
replace n_pospro_1 = 2 if  (c_pospro_1 == 1) | (c_pospro_1 == 3)| (c_pospro_1 == 4)
replace n_pospro_1 = 1.5 if ( n_pospro_1 ==.)
lab var n_pospro_1 "1 if component 1 of the HHs  is manual worker and 2 otherwise"
gen n_pospro_2 = 1 if (c_pospro_2 == 2) 
replace n_pospro_2 = 2 if  (c_pospro_2 == 1) | (c_pospro_2 == 3)| (c_pospro_2 == 4)
replace n_pospro_2 = 1.5 if ( n_pospro_2 ==.)
lab var n_pospro_2 "1 if component 2 of the HH  is a manual worker and 2 otherwise"

gen  n_cond_1 = 1 if (c_cond_1 == 1)
replace  n_cond_1 =  0  if (n_cond_1 == .)
lab var n_cond_1  "1  if component 1 HH is registered employed,  0 otherwise"
gen n_cond_2 = 1 if (c_cond_2 == 1)
replace  n_cond_2 =  0  if (n_cond_2 == .)
lab var n_cond_2  "1  if component 2 HH is registered employed,  0 otherwise"

gen time_1 = 1 if (orario_1 == 1) 
replace time_1 =  0 if (orario_1 == 2)
replace time_1  = 0.5 if (time_1  == .) 
lab var time_1 "full time =  1,part-time = 0 component 1 "
gen time_2 = 1 if (orario_2 == 1) 
replace time_2  = 0.5 if(time_2  == .) 
replace time_2 =  1 if (orario_2 == 2)
lab var time_2 "full time =  1,part-time = 0 component 2 "

gen rent_1 = 1 if (c_c_redd_1 == 3) 
replace rent_1 = 0 if (rent_1 == .) 
lab var rent_1 "1 if component 1 have not wage or pension income"
gen rent_2 = 1 if (c_c_redd_2 == 3) 
replace rent_2 = 0 if (rent_2 == .)
lab var rent_2 "1 if component 2 have not wage or pension income"

rename c_titstu_1 studtitl_1
replace studtitl_1 = 0  if (studtitl_1 ==  .)
lab var studtitl_1 "Study Title of the component 1 "
rename c_titstu_2 studtitl_2
replace studtitl_2 = 0  if (studtitl_2 ==  .)
lab var studtitl_2 "Study Title of the component 2 "

br studtitl_1 studtitl_2  n_pospro_1  n_pospro_2  time_1  time_2  n_cond_1  n_cond_2  rent_1  rent_2


/*Generate the SES variable*/

gen ses = studtitl_1 + studtitl_2 + n_pospro_1 + n_pospro_2 + time_1 + time_2 + n_cond_1 + n_cond_2 + rent_1 + rent_2
lab var ses "Approximated relative Socio Economic Status of the HouseHold"


/*Divide the sample in quintiles based on the approximated SES*/ 

xtile Quintile = ses, nq(5) 

rename rgn reg_uni

lab var reg_uni "Region of residence of the HH"


/*Generate the Area variable : Nord-west : Piemonte, Valle d'Aosta, Lombardia, Liguria; == 1 
Nord-east: Trentino-Alto Adige, Veneto, Friuli-Venezia Giulia, Emilia-Romagna; ==2 
Center: Toscana, Umbria, Marche, Lazio; == 3
South: Abruzzo, Molise, Campania, Puglia, Basilicata, Calabria; == 4 
Island : Sicilia, Sardegna == 5*/


gen Area = 1 if (reg_uni == 1 ) | (reg_uni == 2) | (reg_uni == 7) | (reg_uni == 3) 
replace Area = 2 if (reg_uni == 4) | (reg_uni == 5 )| (reg_uni == 6 ) |(reg_uni == 8 ) 

replace Area = 3 if (reg_uni == 9) | (reg_uni == 11 )| (reg_uni == 12 ) 

replace Area = 4 if (reg_uni == 13) | (reg_uni == 14 )| (reg_uni == 15) |(reg_uni == 16 ) | (reg_uni == 17) |(reg_uni == 18 ) 

replace Area = 5 if (reg_uni == 19) | (reg_uni == 20 )

keep if Area != .

save C_2014_HHs.dta,replace

