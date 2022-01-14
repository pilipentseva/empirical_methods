program fun_reg_price_X

// Table 2 - Ethnic price gaps with block ID and neighborhood ID
quietly{
reg log_price i.citywaveID minodummy, robust cl(newid) 
estimates store m0a	

reg log_price i.citywaveID $lesX minodummy, robust cl(newid) 
estimates store m1a
	
areg log_price _IcitywaveI_* _IhoodcityI_* minodummy, robust cl(blockID) absorb(blockID)
estimates store m2a	

areg log_price _IcitywaveI_* _IhoodcityI_* $lesX minodummy, robust cl(blockID) absorb(blockID)
estimates store m3a	
}

estout m0a m1a m2a m3a using $results/Table2.tex , ///
cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(minodummy) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
  varlabels(minodummy "Minority" ) ///
  title(Ethnic price gap, by specification\label{tab.gap}) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot("\midrule""city-wave FE & Yes & Yes & Yes  & Yes""\\" "Neighborhood FE & No & No & Yes & Yes""\\" "Block FE & No & No & Yes & Yes""\\""Property characteristics & No & Yes & No  & Yes""\\" "\midrule") ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression on the daily log-price on the minority dummy, controlling city-wave fixed-effects. Robust standard errors clustered at the property level.""\end{center}" "\end{table}")


end
