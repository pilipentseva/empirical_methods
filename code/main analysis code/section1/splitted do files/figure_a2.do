*Figure A2
cap drop sum_wave
preserve
bys newid : gen sum_wave=_N
sort newid
duplicates drop newid, force 
histogram sum_wave, width(0.5) discrete frequency xlab(2(1)21) xscale(range(2 21)) bcolor(gray)  ///
 ylab(0 5000 "5,000" 10000 "10,000" 15000 "15,000" 20000 "20,000") ///
 ytitle("Number of observations by Listing") xtitle("Number of Waves") ///
 graphregion(color(white)) 
graph export $results/FigA2_nber_obs_perlisting.eps, replace
restore
