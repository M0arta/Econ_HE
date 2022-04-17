
use C_2016_HHs.dta

append using C_2014_HHs.dta


/*Rename and label variables in both datasets*/ 

rename cittad_1 cit_1
lab var cit_1 "Dummy for italian citizenship of first component"
rename cittad_2 cit_2
lab var cit_2 "Dummy for italian citizenship of second component"

rename c_c_etacalc_1 age_1
lab var age_1 "Age group of component 1"
rename c_c_etacalc_2 age_2
lab var age_2 "Age group of component 2"

rename c_c_etacalc_3 age_3
lab var age_3 "Age group of component 3"
rename c_c_etacalc_4 age_4
lab var age_4 "Age group of component 4"

rename c_c_etacalc_5 age_5
lab var age_5 "Age group of component 5"
rename c_c_etacalc_6 age_6
lab var age_6 "Age group of component 6"

rename d331_bf expense_public
lab var expense_public "Expenses for public university"

rename d334_bf expense_private
lab var expense_private "Expenses for private university"


/*Drop unesefull variables about HHs  expenses */
drop bio_* scorta_* uova* frutta* yogurt* formaggi* pesce* latte* salumi* carne* pasta* biscotti* pane* *l *bf poss*  period* c_superf* c_stanze cuc* angcot nocucina bagno vascadoccia c_numcu* terrazzo giardino energ gasrete acquacor teleffisso risc tiporisc combust acquacal tipoacquacal frigorif lavatr lavastov tipocontratto condizio annoccup titoccup propabit internet *mensile chiave* servizi* d_* fig str noalm* b_* autoc num* cond* rip viaggi* carburanti* sanita*  persona*  abbigliamento* bevande* alimentari* giochi* pr* igiene* caffe*  medicin* vino* bibite* acqua* olio* verdura* articoli* attrezzatur* max*


/*merge with Enrolment.dta by reg_uni and year*/

merge m:m reg_uni year using Enrolment.dta 

keep if _merge == 3



/*Generate variable on the level of quality and quantity of the HE supply in each region*/

egen tot_14 = total(n_enrl) if (year == "2013/2014")
egen tot_reg_14 = total(n_enrl) if(year == "2013/2014") , by (reg_uni)


egen tot_16 = total (n_enrl) if (year == "2016/2017")
egen tot_reg_16 = total(n_enrl) if (year == "2016/2017") , by (reg_uni)

/*Generate the share of enrolled for each region in 2016*/

foreach var of varlist reg_uni {
        gen share_16_`var'= (tot_reg_16 / tot_16) 
       replace share_16_`var'= 0 if (share_16_`var'== .)
        }    


/*Generate the share of enrolled for each region in 2014*/

foreach var of varlist reg_uni {
        gen share_14_`var'= (tot_reg_14 / tot_14) 
       replace share_14_`var'= 0 if (share_14_`var'== .)
        }    


/*Generate ranking of regions for 2014 and 2016 */

gsort + share_14_reg, gen (rank_14)
gsort + share_16_reg, gen (rank_16)

/*Generating a Treatment variable based on Excell calculations of difference between the shares in 2016 and 2014, Treat == 1 if increased and 0 othherwise*/

gen Treat =1 if (reg_uni ==1) |(reg_uni == 3) |(reg_uni == 5) |(reg_uni == 6) |(reg_uni == 8) |(reg_uni == 9) |(reg_uni == 10) |(reg_uni == 11)
replace Treat = 0  if (reg_uni == 2)|(reg_uni == 4) |(reg_uni == 7) |(reg_uni == 12) |(reg_uni == 13)|(reg_uni == 15)|(reg_uni == 16) |(reg_uni == 17)|(reg_uni == 18)|(reg_uni == 19)|(reg_uni == 20)      

keep if Treat != .


/*Generate a variable for being post "treatment" observations or not*/

gen  Post = 1 if (year == "2016/2017")
replace Post = 0 if (year == "2013/2014")

keep if Post != .

/*Generate outcome variable for the two periods using as a proxy the presence of a voice of expense for university or not*/

gen enrol_16 = 1 if (expense_public != 0) | (expense_private != 0) & (year == "2016/2017")
gen enrol_14 = 1 if (expense_public != 0) | (expense_private != 0) & (year == "2013/2014")

replace enrol_14 = 0  if (enrol_14 == .) & (year == "2013/2014")
replace enrol_16 = 0  if (enrol_16 == .) & (year == "2016/2017")
