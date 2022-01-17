*Table 8
   ***FLUX***
	
// inno_names: the number of new guests (whose names are in _n and were not in _n-1)
// inno_mino_names: the number of new minority guests (whose names that are in _n and were not in _n-1)
gen inno_names=nber_names if wave!=minwave
gen inno_mino_names=nber_mino_names if wave!=minwave

replace rating_visible=. if rating_visible==0

gen share_inno_mino_names = inno_mino_names/inno_names
bys newid (wave): gen Dreview = review[_n]-review[_n-1]
bys newid (wave): gen L_guest_satisfaction_overall = guest_satisfaction_overall[_n-1]
bys newid (wave): gen L_rating_visible = rating_visible[_n-1]
gen L_guest_satisfaction_overallNA = missing(L_guest_satisfaction_overall)
gen L_rating_visibleNA = missing(L_rating_visible)
replace L_guest_satisfaction_overall = 0 if missing(L_guest_satisfaction_overall)
replace L_rating_visible = 0 if missing(L_rating_visible)

// Innovation in ratings
bys newid (wave): gen inno_satis = ((guest_satisfaction_overall[_n]*review[_n])-(guest_satisfaction_overall[_n-1]*review[_n-1]))/(review[_n]-review[_n-1])
bys newid (wave): gen inno_rating = ((rating_visible[_n]*review[_n])-(rating_visible[_n-1]*review[_n-1]))/(review[_n]-review[_n-1])
replace inno_satis = guest_satisfaction_overall[_n] if missing(guest_satisfaction_overall[_n-1])
replace inno_rating = rating_visible[_n] if missing(rating_visible[_n-1])

sum inno_satis inno_rating inno_names

replace inno_satis=inno_satis/20
replace L_guest_satisfaction_overall=L_guest_satisfaction_overall/20

sum inno_satis  L_guest_satisfaction_overall

// Interaction : Coeff d'interet
gen mino_share = minodummy*share_inno_mino_names

// Regressions
quietly {
xtreg inno_satis i.hoodcityID $lesX mino_share minodummy share_inno_mino_names inno_names review Dreview L_guest_satisfaction_overall L_guest_satisfaction_overallNA ///
 if inno_names>0 & !missing(inno_satis), robust fe i(blockID)
estimates store ols1

xtreg inno_satis i.citywaveID $lesX mino_share share_inno_mino_names inno_names review Dreview L_guest_satisfaction_overall L_guest_satisfaction_overallNA ///
 if inno_names>0 & !missing(inno_satis), fe i(newid) robust cl(newid)
estimates store xt1
}
estout xt1 using $results/Table8.tex , cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(share_inno_mino_names mino_share) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
varlabels(share_inno_mino_names "Share of minority among new guests" mino_share "Minority host \$ \times \$ Share of minority among new guests") ///
  title(Average rating, depending on hosts' and guests' ethnicity\label{tab.ratings.minority}) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 )  ///
 mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression in column (1), and OLS regression with listings fixed-effects in column (2).""\end{center}" "\end{table}")

