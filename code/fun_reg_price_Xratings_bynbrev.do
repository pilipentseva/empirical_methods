program fun_reg_price_Xratings_bynbrev


 
 * Share of minority

quietly {
sum minodummy if review==0
global mean0=r(mean)
global mean0=round($mean0,.0001)
sum minodummy if review>0 & review <=4
global mean04=r(mean)
global mean04=round($mean04,.0001)
sum minodummy if review>=5 & review<20
global mean520=r(mean)
global mean520=round($mean520,.0001)
sum minodummy if review>=20 & review<50
global mean2050=r(mean)
global mean2050=round($mean2050,.0001)
sum minodummy if review>=50
global mean50=r(mean)
global mean50=round($mean50,.0001)
}

/// TABLE 3 : Block ID and Hood ID
quietly {
areg log_price  _IcitywaveI_* _IhoodcityI_* $lesX minodummy if review==0, robust cl(blockID) absorb(blockID)
estimates store m1b	
areg log_price  _IcitywaveI_* _IhoodcityI_* $lesX $ratinglist minodummy if review>0 & review <=4, robust cl(blockID) absorb(blockID)
estimates store m2b		
areg log_price  _IcitywaveI_* _IhoodcityI_* $lesX $ratinglist minodummy if review>=5 & review<20, robust cl(blockID) absorb(blockID)
estimates store m3b	
areg log_price  _IcitywaveI_* _IhoodcityI_* $lesX $ratinglist minodummy if review>=20 & review<50, robust cl(blockID) absorb(blockID)
estimates store m4b	
areg log_price  _IcitywaveI_* _IhoodcityI_* $lesX $ratinglist minodummy if review>=50, robust cl(blockID) absorb(blockID)
estimates store m5b
}


estout m1b m2b m3b m4b m5b using $results_sample/Table3_$sample.tex , ///
cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(minodummy) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
  varlabels(minodummy "Minority" ) ///
  title(Ethnic price gap, for several segments of the number of reviews ($sample) \label{tab.gapr_$sample}) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot("\midrule" "Nb reviews &   0&   1-4  & 5-19 & 20-49 & 50+""\\""\midrule""Share Minority &  $mean0&  $mean04  & $mean520 & $mean2050 & $mean50""\\""\midrule") ///
postfoot("\hline""\end{tabular}" "Notes: OLS regressions of the daily log-price on the minority dummy, controlling for neighborhood FE, property characteristics and ratings (for properties with at least one review).""\end{center}" "\end{table}")


  
 end
