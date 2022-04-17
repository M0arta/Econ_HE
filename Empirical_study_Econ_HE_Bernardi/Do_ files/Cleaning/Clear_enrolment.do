/*** Import and clean dataset with number of enrolled student in 2013/2014 and 2016/2017 by each university and merge it with the original dataset using the regional appartenance */

import delimited Enrolled_uni.csv
 
/*Rename variables from italian to English*/

rename ateneocod uni_code

rename annoa year

rename ateneonome city_uni

rename isc n_enrl

/*label variables */

lab var n_enrl "Number of students enrolled"

lab var uni_code "University id"

lab var year "Accademic year"

keep if year == "2013/2014" | year == "2016/2017"

 /*Generate a variable for the regional appartenance*/

gen reg_uni = . 

replace reg_uni = 12 if (city_uni == "Roma Biomedico") | (city_uni == "Viterbo")| (city_uni == "Cassino")| (city_uni == "Roa Europea")| (city_uni == "Roma Foro Italico")| (city_uni == "Roma La Sapienza")| (city_uni == "Roma LInk Campus")| (city_uni == "Roma LUISS")| (city_uni == "Roma LUMSA")| (city_uni == "Roma Tor Vergata")| (city_uni == "Roma Tre")| (city_uni == "Roma UNINT")| (city_uni == "Tuscia")


replace reg_uni = 16 if (city_uni == "Bari") | (city_uni == "Lecce") | (city_uni == "Foggia") | (city_uni == "Bari Politecnico")
replace reg_uni = 11 if (city_uni == "Ancona") | (city_uni == "Urbino") | (city_uni == "Macerata")| (city_uni == "Camerino")
replace reg_uni = 1 if (city_uni == "Vercelli") |  (city_uni == "Torino") | (city_uni == "Bra Scienze Gastronomiche") | (city_uni == "Torino Politecnico")| (city_uni == "Piemonte Orientale")

replace reg_uni = 3 if (city_uni == "Milano") | (city_uni == "Pavia") | (city_uni == "Varese, Como") | (city_uni == "Brescia") | (city_uni == "Castellanza (VA)") | (city_uni == "Bergamo")| (city_uni == "Milano Bicocca")| (city_uni == "Milano Bocconi")| (city_uni == "Milano San Raffaele")| (city_uni == "Milano IULM")| (city_uni == "Milano Politecnico")| (city_uni == "Milano San Raffaele")| (city_uni == "Insubria")| (city_uni == "Rozzano (MI) Humanitas University")

replace reg_uni = 15 if (city_uni == "Napoli Benincasa") | (city_uni == "Napolu L'Orientale")| (city_uni == "Napoli Parthenope")| (city_uni == "Napoli Federico II")| (city_uni == "Napoli Vanvitelli")| (city_uni == "Sannio")
replace reg_uni = 9 if (city_uni == "Pisa") | (city_uni == "Siena") | (city_uni == "Lucca") | (city_uni == "Firenze")| (city_uni == "Siena Stranieri")
replace reg_uni = 17 if (city_uni == "Potenza")| (city_uni == "Basilicata")
replace reg_uni = 18 if (city_uni == "Reggio Calabria") | (city_uni == "Rende (CS)") | (city_uni == "Calabria") | (city_uni == "Reggio Calabria - Dante Alighieri")
replace reg_uni = 8 if (city_uni == "Modena e Reggio Emilia") | (city_uni == "Parma") | (city_uni == "Ferrara") | (city_uni == "Bologna") | (city_uni == "Faenza") 
replace reg_uni = 5 if (city_uni == "Padova") | (city_uni == "Verona") | (city_uni == "Venice, Verona") | (city_uni == "Venezia Iuav")| (city_uni == "Venezia Cà Foscari")
replace reg_uni = 10 if (city_uni == "Perugia")| (city_uni == "Perugia Stranieri") 
replace reg_uni = 6 if (city_uni == "Udine")
replace reg_uni = 4 if (city_uni == "Trieste") | (city_uni == "Trento") | (city_uni == "Bolzano")
replace reg_uni = 20 if (city_uni == "Sassari") | (city_uni == "Cagliari")
replace reg_uni = 13 if (city_uni == "L'Aquila") | (city_uni == "Teramo") | (city_uni == "Chieti e Pescara")
replace reg_uni = 7 if (city_uni == "Genova")
replace reg_uni = 20 if (city_uni == "Sassari")
replace reg_uni = 19 if (city_uni == "Salerno")| (city_uni == "Enna KORE") | (city_uni == "Catania") | (city_uni == "Catanzaro") | (city_uni == "Palermo") | (city_uni == "Messina")
replace reg_uni = 2 if (city_uni == "Aosta")

/*Drop telematic universities*/

keep if reg_uni != .

save Enrolment.dta,replace
