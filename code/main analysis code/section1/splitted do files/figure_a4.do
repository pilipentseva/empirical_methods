*Figure A4
// On the majority population

preserve
keep if minodummy==0
quietly{
xtreg log_price i.citywaveID $lesX ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10)# ///
 (c.revc1 c.revc2 c.revc3 c.revc4 c.revc5 c.revc6), ///
 fe i(newid)
estimates store maj0
}
restore
estout maj0 using $results/xtreg_price_reviews_majo.txt, ///
 cells("b(star fmt(%9.5f)) se(par fmt (%9.5f))") keep(*rev* *lastr*) ///
 stats(r2_a N, fmt(%9.3f %9.0g) label(AdjR2 obs.)) style(tex) ///
 replace stardetach

estout maj0, cells(b(star fmt(%9.5f)) se(par fmt (%9.5f))) keep(*rev* *lastr*) ///
 stats(r2_a N, fmt(%9.3f %9.0g) label(AdjR2 obs.)) style(tex) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) 

// On both populations

quietly{
reg log_price i.citywaveID i.hoodcityID $lesX ///
 c.lastrat0 c.lastrat7 c.lastrat8 c.lastrat9 c.minodummy ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)# ///
 (c.revc1 c.revc2 c.revc3 c.revc4 c.revc5 c.revc6) ///
 c.minodummy#ib10.wave ///
 if review<100
estimates store rlast

xtreg log_price i.citywaveID $lesX ///
 (c.lastrat7 c.lastrat8 c.lastrat9 c.lastrat10 c.minodummy)# ///
 (c.revc1 c.revc2 c.revc3 c.revc4 c.revc5 c.revc6) ///
 c.minodummy#ib10.wave ///
 if review<100, fe i(newid)
estimates store plast 
}

estout rlast plast, ///
 cells(b(star fmt(%9.5f)) se(par fmt (%9.5f))) keep (*minodummy#c.revc* *rev*) ///
 stats(r2_a N, fmt(%9.4f %9.0g) label(AdjR2 obs.)) style(tex) ///
 replace 

estout rlast plast using $results/outreg_graphs_price_reviews_last.txt, ///
 cells("b(star fmt(%9.5f)) se(par fmt (%9.5f))") keep (*mino* *rev*) ///
 stats(r2_a N, fmt(%9.4f %9.0g) label(AdjR2 obs.)) style(tex) ///
 replace stardetach 

quietly{
reg log_price i.citywaveID i.hoodcityID $lesX ///
 c.starsshort0 c.starsshort7 c.starsshort8 c.starsshort9 ///
 (c.starsshort7 c.starsshort8 c.starsshort9 c.starsshort10 c.minodummy)# ///
 (c.revc1 c.revc2 c.revc3 c.revc4 c.revc5 c.revc6) ///
 c.minodummy c.minodummy#ib10.wave ///
 if review<100
estimates store rall

xtreg log_price i.citywaveID $lesX c.starsshort0 ///
 (c.starsshort7 c.starsshort8 c.starsshort9 c.starsshort10 c.minodummy)# ///
 (c.revc1 c.revc2 c.revc3 c.revc4 c.revc5 c.revc6) ///
 c.minodummy#ib10.wave ///
 if review<100, fe i(newid)
estimates store pall 
}

estout rall pall, ///
 cells(b(star fmt(%9.5f)) se(par fmt (%9.5f))) keep (*minodummy#c.revc* *rev*) ///
 stats(r2_a N, fmt(%9.4f %9.0g) label(AdjR2 obs.)) style(tex) /// 
 replace 

estout rall pall using $results/outreg_graphs_price_reviews.txt , ///
 cells("b(star fmt(%9.5f)) se(par fmt (%9.5f))") keep (*mino* *rev*) ///
 stats(r2_a N, fmt(%9.4f %9.0g) label(AdjR2 obs.)) style(tex) ///
 replace stardetach 
