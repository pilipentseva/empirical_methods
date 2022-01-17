*Appendix A1
quietly estpost tab city
eststo col1
preserve
duplicates drop newid, force
quietly estpost tab city
eststo col2
restore
esttab col1 col2 using $results/TableA1.tex, replace cells("b pct(f(2))") nomtitle nonumber tex  ///
title(Number of observations/listings by city\label{cities.gap}) ///
varlabels(london "London" paris "Paris" madrid "Madrid" barcelona "Barcelona" rome "Rome" milan "Milan"  toronto "Toronto" ///
florence "Florence" amsterdam "Amsterdam" berlin "Berlin" marseille "Marseille" vancouver "Vancouver"  los-angeles "Los Angeles"  ///
montreal "Montreal" boston "Boston" new-york "New York City" miami "Miami" chicago "Chicago" san-francisco "San Francisco") 

