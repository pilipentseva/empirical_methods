*Table 1
quietly reg log_price i.citywaveID i.mino
estimates store m0
 estout m0 using $results/Table1.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(*mino*) ///
 stats(r2_a N, fmt(%9.3f %9.0g) label(AdjR2 obs.)) style(tex) replace ///
 starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
 title(Raw price gaps by ethnic groups\label{rawgapsethnic}) ///
  varlabels(2.mino "Arabic/Muslim (Europe)" 3.mino "Arabic/Muslim (US/CAN)" ///
  4.mino "Blacks (Europe)" 5.mino "Blacks (US/CAN)" )

quietly estpost tabulate mino
esttab . using $results/Table1Bis.tex, replace cells("b(label(Sample size)) pct(fmt(2) label(Share))") nomtitle nonumber tex ///
  varlabels(0majority "Majority" arabicafricanEURO "Arabic/Muslim (Europe)" arabicafricanUSCAN "Arabic/Muslim (US/CAN)" ///
  blackEURO "Blacks (Europe)" blackUSCAN "Blacks (US/CAN)" )

  