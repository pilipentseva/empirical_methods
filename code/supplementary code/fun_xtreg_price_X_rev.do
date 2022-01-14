program fun_xtreg_price_X_rev



/// TABLE 5

sum review if review>0, d


quietly{
xtreg log_price i.citywaveID $lesX c.minodummy#ib10.wave ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)#c.rev100 if review>0 & review<40, ///
 fe i(newid) robust cl(newid)
estimates store xt1
xtreg log_price i.citywaveID $lesX c.minodummy#ib10.wave ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)#c.rev100 if review>0 & review<60, ///
 fe i(newid) robust cl(newid)
estimates store xt2
xtreg log_price i.citywaveID $lesX c.minodummy#ib10.wave ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)#c.rev100 ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)#c.rev100#c.rev100 if review>0 & review<80, ///
 fe i(newid) robust cl(newid)
estimates store xt3
}


estout xt1 xt2 xt3 using $results/Table5.tex , cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
 keep(*rev* *lastr*) stats(r2_a N, fmt(%9.3f %9.0g) label("Adj R2" "N obs.")) style(tex) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
 title(Fixed-Effects Estimation\label{tab.fixedeffects}) ///
 varlabels(c.minodummy#c.rev100 "Minority \$ \times K/100\$" ///
 c.minodummy#c.rev100#c.rev100 "Minority \$ \times (K/100)^2\$" ///
 lastrat7 "3.5 stars" lastrat8 "4 stars" lastrat9 "4.5 stars" lastrat10 "5 stars" ///
 c.lastrat7#c.rev100 "3.5 stars \$ \times K/100\$" ///
 c.lastrat8#c.rev100 "4 stars \$ \times K/100\$" ///
 c.lastrat9#c.rev100 "4.5 stars \$ \times K/100\$" ///
 c.lastrat10#c.rev100 "5 stars \$ \times K/100\$" ///
 c.lastrat7#c.rev100#c.rev100 "3.5 stars \$ \times (K/100)^2\$" ///
 c.lastrat8#c.rev100#c.rev100 "4 stars \$ \times (K/100)^2\$" ///
 c.lastrat9#c.rev100#c.rev100 "4.5 stars \$ \times (K/100)^2\$" ///
 c.lastrat10#c.rev100#c.rev100 "5 stars \$ \times (K/100)^2\$") ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot("\midrule" "Samples &  K\$<\$40 & K\$<\$60 & K\$<\$80 ""\\""\midrule") ///
postfoot("\hline""\end{tabular}" "Notes: OLS regressions with listing fixed effects.""\end{center}" "\end{table}")

 
end
