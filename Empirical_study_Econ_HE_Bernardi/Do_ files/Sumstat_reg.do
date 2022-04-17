use MERGED.dta 


/*install packages */

ssc install asdoc 
ssc install estout
ssc install outreg2

/*SECTION 2*/

/*Generate, label and rename variable to be inserted in figures and tables */ 

tab Quintile, gen(inc)
rename inc5 high_inc
rename inc4 midhigh_inc
rename inc3 mid_inc
rename inc2 midlow_inc
rename inc1 low_inc


tab Area, gen(zone)
rename zone1 nordw
rename zone2 norde
rename zone3 center
rename zone4 sud
rename zone5 island


lab var rank_14 "HE's supply rank 2014"
lab var rank_16 "HE's supply rank 2016"


gen sex = 1 if (sesso_1 == 1 ) | (sesso_2 == 1) | (sesso_3 == 1) | (sesso_4 ==1 )| (sesso_5 == 1)| (sesso_6 ==1) | (sesso_7 == 1 ) | (sesso_8 == 1) | (sesso_9 == 1) | (sesso_10 ==1 )| (sesso_11 == 1)| (sesso_12 ==1)

replace sex = 0 if (sesso_1 == 2 ) | (sesso_2 == 2) | (sesso_3 == 2) | (sesso_4 ==2 )| (sesso_5 == 2)| (sesso_6 ==2) | (sesso_7 ==2) | (sesso_8 == 2) | (sesso_9 == 2) | (sesso_10 == 2)| (sesso_11 == 2)| (sesso_12 ==2)

lab var sex "1 for male, 0 for female"

gen cit = 1 if (cit_1 == 1 ) | (cit_2 == 1) | (cittad_3 == 1) | (cittad_4 ==1 )| (cittad_5 == 1)| (cittad_6 ==1) | (cittad_7 == 1 ) | (cittad_8 == 1) | (cittad_9 == 1) | (cittad_10 ==1 )| (cittad_11 == 1)| (cittad_12 ==1)

replace cit = 0 if (cit_1 == 2 ) | (cit_2 == 2) | (cittad_3 == 2) | (cittad_4 ==2 )| (cittad_5 == 2)| (cittad_6 ==2) | (cittad_7 ==2) | (cittad_8 == 2) | (cittad_9 == 2) | (cittad_10 == 2)| (cittad_11 == 2)| (cittad_12 ==2)


lab var cit "1 if Italian citizenship "

/*gen pooled variables*/

gen enrol = 1 if (enrol_14 ==1 ) | (enrol_16 == 1)
replace enrol = 0 if (enrol_14 ==0) | (enrol_16 == 0)


/*Look at the difference in enrollment in 2014 and in 2016 between regions and areas */

/*Table 1*/ 

asdoc tab2 reg_uni enrol_14 if (Post == 0), save(Table1.doc)
asdoc tab2 reg_uni enrol_16 if (Post == 1), append

/*Look at the difference in enrollment in 2014 and in 2016 between income groups */

/*Table 2*/
asdoc tab2 Quintile enrol_14 if (Post == 0), save(ooo.doc)
asdoc tab2 Quintile enrol_16 if (Post == 1), append


/*Table A1*/ 

/*PANEL A*/
asdoc sum age_* sex ses if high_inc ==1 & Treat == 1, save(non.odt)
asdoc sum age_* sex ses if high_inc ==1 & Treat == 0, append

/*PANEL B*/

asdoc sum age_* sex ses if midhigh_inc ==1 & Treat == 1, append 
asdoc sum age_* sex ses if midhigh_inc ==1 & Treat == 0, append

/*PANEL C*/
asdoc sum age_* sex ses if mid_inc ==1 & Treat == 1, append
asdoc sum age_* sex ses if mid_inc ==1 & Treat == 0, append

/*PANEL D*/

asdoc sum age_* sex ses if midlow_inc ==1 & Treat == 1, append 
asdoc sum age_* sex ses if midlow_inc ==1 & Treat == 0, append

/*PANEL E*/

asdoc sum age_* sex ses if low_inc ==1 & Treat == 1,append
asdoc sum age_* sex ses if low_inc ==1 & Treat == 0,append

/*Table A2*/

asdoc sum age_* sex ses, by(Area) save(new.odt) append

/*Table 3*/

asdoc sum age_* sex ses Area, label save(Ta.doc)


/*Ttest on output before and after treat control comparison */ 

/*Table 4*/

asdoc ttest ses, by(Treat), save(op.doc)
asdoc ttest sex, by(Treat), append
asdoc ttest cit , by(Treat), append
asdoc ttest enrol, by(Treat), append


/*Restrict the sample to the population from 18 to 34*/

 keep if (age_1 == 2) | (age_2 == 2) |(age_3== 2) |(age_4 == 2) |(age_5 == 2) |(age_6 ==2)


//*SECTION 3*// 

/*Table 5*/

/*LPM and Probit estimation*/

/*generate interaction variables*/

gen interact = rank_16 * ses
gen inter_14 = rank_14 * ses if (year == "2013/2014")
gen inter_16 = rank_16 * ses if (year == "2016/2017")

gen ginteract = rank_16 * Area
gen ginter_14 = rank_14 * Area if (year == "2013/2014")
gen ginter_16 = rank_16 * Area if (year == "2016/2017")


tab year, gen(timeFE)

 /*LPM 2014*/
 
reg enrol_14 rank_14 ses i.sex i.cit i.Area inter_14 ginter_14 if (year== "2013/2014"),cluster(reg_uni)
outreg2 using 1.doc, ctitle("LPM 2014") title("Table 4a: LPM and Probit for 2014")

/*LPM 2016*/ 

reg enrol_16 rank_16 ses i.sex i.cit i.Area inter_16 ginter_16 if (year== "2016/2017"),cluster(reg_uni)
outreg2 using 2.doc, ctitle("LPM 2016") title("Table 4b: LPM and Probit for 2016")


/*Probit 2014*/

probit enrol_14 rank_14 ses i.sex i.cit i.Area inter_14 ginter_14 if (year== "2013/2014"),cluster(reg_uni)
margins, dydx (rank_14 ses i.sex i.cit i.Area inter_14 ginter_14)
estimates  store margin1
outreg2 [margin1] using 1.doc,append ctitle("Probit 2014")

/*Probit 2016*/

probit enrol_16 rank_16 ses i.sex i.cit i.Area inter_16 ginter_16 if (year== "2016/2017"),cluster(reg_uni)
margins, dydx (rank_16 ses i.sex i.cit i.Area inter_16 ginter_16)
estimates  store margin2
outreg2 [margin2] using 2.doc,append ctitle("Probit 2016")


/*LPM Pooled*/

reg enrol rank_16 ses i.sex i.cit i.Area timeFE* interact ginteract ,cluster(reg_uni)
outreg2 using 6.doc, ctitle("LPM ") title("Table 5c: LPM and Probit Pooled")

/*Probit Pooled*/
probit enrol rank_16 ses i.sex i.cit i.Area timeFE* interact ginteract ,cluster(reg_uni)
margins, dydx (rank_16 ses i.sex i.cit i.Area timeFE* interact ginteract)
estimates  store margin4
outreg2 [margin4] using 6.doc,append ctitle("Probit")

/*Probit models for the diff-in-diff*/

gen inter = Treat * Post


/*Table 6*/ 


probit enrol Treat Post inter ses i.sex i.cit Area, cluster(reg_uni)
margins, dydx (Treat Post inter i.sex i.cit Area)
estimates store match2
outreg2 [match2] using lol.doc,append  ctitle("Probit Diff")

probit enrol Treat Post inter i.sex i.cit i.Area studtitl* reg_uni time* rent* n_cond*, cluster(reg_uni)
margins, dydx (Treat Post inter i.sex i.cit i.Area studtitl* reg_uni time* rent* n_cond*)
estimates store match3
outreg2 [match3] using lol.doc,append  ctitle("Probit Diff Spec")

probit enrol rank_16 ses i.sex i.cit i.Area timeFE* interact ginteract ,cluster(reg_uni)
margins, dydx (rank_16 ses i.sex i.cit i.Area timeFE* interact ginteract)
estimates  store margin4
outreg2 [margin4] using lol.doc,append ctitle("Probit no diff")












