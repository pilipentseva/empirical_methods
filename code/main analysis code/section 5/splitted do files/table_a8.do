*Tabke A8
use $data/base_airbnb_AEJ.dta, clear


keep if black_pic==1 | black_pic==0
keep black_pic hoodcityID newid city
duplicates drop
bys hoodcityID : egen share_black=mean(black_pic)
keep hoodcityID share_black city
duplicates drop

save $results/base_share_black_hood.dta, replace

use $data/base_airbnb_AEJ.dta, clear

keep if Drev100>0

merge m:1 hoodcityID using $results/base_share_black_hood.dta

keep if _merge==3
quietly{
reg pic_no_ethnic i.citywaveID share_black $lesX, robust cl(newid) 
estimates store m0a	
}

gen pic_no_ethnic_share_black=pic_no_ethnic*share_black

quietly{
reg log_price i.citywaveID i.hoodcityID $lesX pic_no_ethnic , robust cl(newid)
estimates store m1a
reg log_price i.citywaveID i.hoodcityID $lesX pic_no_ethnic pic_no_ethnic_share_black , robust cl(newid)
estimates store m2a
}

estout m0a m1a m2a using $results/TableA6.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
keep(share_black pic_no_ethnic pic_no_ethnic_share_black) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
 title(Behavior of hosts posting non-person pictures \label{tab.non_person_pics}) ///
 varlabels(share_black  "Local share of Blacks" pic_no_ethnic   "Non-person picture" ///
  pic_no_ethnic_share_black "Non-person picture x share Blacks")  ///
 mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression.""\end{center}" "\end{table}")	

