*Table A5
preserve
duplicates drop newid, force
eststo: quietly estpost tab  last_rating if last_rating>0
eststo col1
esttab  col1 using $results/TableA5.tex, replace cells("b pct(f(2))") nomtitle nonumber tex ///
title(Distribution of the last rating\label{tab.ratings}) 
restore


