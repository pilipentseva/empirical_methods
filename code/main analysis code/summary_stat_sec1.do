
 
gen Drev=Drev100*100

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit


// Appendix Table A3 - full list of characteristics of the properties and the hosts 
 
preserve
duplicates drop newid, force
eststo clear

global descrip_flat bedrooms bathrooms $descrip_gen $descrip_spe $equip people extrapeople smoking_allowed pets_allowed house loft realbed year2008
global lesX_sansmissing sharedflat $descrip_flat $loueur $count person_capacity 

eststo: quietly estpost summarize $lesX_sansmissing
eststo: quietly estpost summarize $lesX_sansmissing if active_listing==1

esttab using $results/TableA3.tex, replace cells("mean(f(3))") nomtitle nonumber tex ///
title(Summary statistics: Property \& host characteristics\label{propcharac}) ///
 varlabels(entireflat "Entire Flat" sharedflat "Shared Flat" ///
 person_capacity "Person Capacity" bedrooms "$\#$ bedrooms" ///
 bathrooms "$\#$ bathrooms" appart "Flat" house_loft "House or Loft" ///
 couch "Couch" airbed "Airbed" sofa "Sofa" futon "Futon" ///
 realbed "Real Bed" terrace_balcony "Terrace or Balcony" ///
 cabletv "Cable TV" wireless "Wireless" heating "Heating" ///
 ac "AC" elevator "Elevator" handiaccess "Wheelchair Accessible" ///
 doorman "Doorman" fireplace "Fireplace" washer "Washer" ///
 dryer "Dryer" parking "Parking" gym "Gym" pool "Pool" buzzer "Buzzer" ///
 hottub "Hot Tub" breakfast "Breakfast served" ///
 family "Family/Kids Friendly" events "Suitable for events" ///
 people "Additional People" extrapeople "Price per Additional People" ///
 smoking_allowed "Smoking Allowed" pets_allowed "Pets Allowed" ///
 verified_email "Verified Email" couple "Host in couple" ///
 more_1_flat "Host has multiple properties" year2009 "Member since 2009" /// 
 year2010 "Member since 2010"  year2011 "Member since 2011" ///
 year2012 "Member since 2012"  year2013 "Member since 2013" ///
 year2014 "Member since 2014"  year2015 "Member since 2015" ///
 superhost "Superhost" verified_offline "Verified Offline" verified_phone "Verified Phone" ///
 count_languages "Nber of Languages" picture_count "Nber of pictures" ///
 deposit "Deposit" minstay "Minimum Stay" checkin "Checkin Time" ///
 checkout "Checkout Time" flexible "Flexible cancellation" ///
 moderate "Moderate cancellation" strict "Strict cancellation" ///
 facebook "Nber of Facebook friends" count_descrip "Nber of words in Description" ///
 count_about "Nber of words in Profile" count_rules "Nber of words in Rules" ///
 noccur_pro_true "Nber of pictures taken by professionals" change_pics "Nber of picture changes" ) 

restore


 *active listing*
 keep if Drev100>0

 
 
// Appendix Table A1 - number of observations and listings by city

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



// Appendix Table A4 - hedonic regression

quietly reg log_price i.citywaveID $lesX , robust cl(newid) 
estimates store m0
quietly areg log_price _IcitywaveI_* _IhoodcityI_* $lesX , robust cl(blockID) absorb(blockID)			
estimates store m1	
estout m0 m1 using $results/TableA4.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep($lesX) ///
 stats(r2_a N, fmt(%9.3f %9.0g) label("Adj R2" "N obs.")) style(tex) replace ///
 starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
 title(Log daily rate\label{hedonic.gap}) ///
 varlabels(_cons Constant person_capacity345 "Person Capacity ($>2$)" ///
 entireflat "Entire Flat" sharedflat "Shared Flat" ///
 person_capacity "Person Capacity" bedrooms "$\#$ bedrooms" ///
 bathrooms "$\#$ bathrooms" appart "Flat" house_loft "House or Loft" ///
 couch "Couch" airbed "Airbed" sofa "Sofa" futon "Futon" ///
 realbed "Real Bed" terrace_balcony "Terrace or Balcony" ///
 cabletv "Cable TV" wireless "Wireless" heating "Heating" ///
 ac "AC" elevator "Elevator" handiaccess "Wheelchair Accessible" ///
 doorman "Doorman" fireplace "Fireplace" washer "Washer" ///
 dryer "Dryer" parking "Parking" gym "Gym" pool "Pool" buzzer "Buzzer" ///
 hottub "Hot Tub" breakfast "Breakfast served" ///
 family "Family/Kids Friendly" events "Suitable for events" ///
 people "Additional People" extrapeople "Price per Additional People" ///
 smoking_allowed "Smoking Allowed" pets_allowed "Pets Allowed" ///
 verified_email "Verified Email" couple "Host in couple" ///
 more_1_flat "Host has multiple properties" year2009 "Member since 2009" /// 
 year2010 "Member since 2010"  year2011 "Member since 2011" ///
 year2012 "Member since 2012"  year2013 "Member since 2013" ///
 year2014 "Member since 2014"  year2015 "Member since 2015" ///
 superhost "Superhost" verified_offline "Verified Offline" verified_phone "Verified Phone" ///
 count_languages "Nber of Languages" picture_count "Nber of pictures" ///
 deposit "Deposit" minstay "Minimum Stay" checkin "Checkin Time" ///
 checkout "Checkout Time" flexible "Flexible cancellation" ///
 moderate "Moderate cancellation" strict "Strict cancellation" ///
 facebook "Nber of Facebook friends" count_descrip "Nber of words in Description" ///
 count_about "Nber of words in Profile" count_rules "Nber of words in Rules" ///
 noccur_pro_true "Nber of pictures taken by professionals" change_pics "Nber of picture changes" ) 
 

// Table 1 - raw price gaps by ethnic groups

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

  
 // Appendix Table A5 - Distribution of the last rating
preserve
duplicates drop newid, force
eststo: quietly estpost tab  last_rating if last_rating>0
eststo col1
esttab  col1 using $results/TableA5.tex, replace cells("b pct(f(2))") nomtitle nonumber tex ///
title(Distribution of the last rating\label{tab.ratings}) 
restore



  
// Appendix Table A6 - number of neighbourhoods and blocks per city

preserve
duplicates drop hoodcityID, force
quietly estpost tab city
eststo col1
restore
preserve
duplicates drop blockID, force
quietly estpost tab city
eststo col2
restore
esttab col1 col2 using $results/TableA6.tex, replace cells("b") nomtitle nonumber tex  ///
title(Number of hoods/blocks by city\label{cities.gap}) ///
varlabels(london "London" paris "Paris" madrid "Madrid" barcelona "Barcelona" rome "Rome" milan "Milan"  toronto "Toronto" ///
florence "Florence" amsterdam "Amsterdam" berlin "Berlin" marseille "Marseille" vancouver "Vancouver"  los-angeles "Los Angeles"  ///
montreal "Montreal" boston "Boston" new-york "New York City" miami "Miami" chicago "Chicago" san-francisco "San Francisco") 


 


// Appendix Figure A2 - number of observations by listing

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

 
// Figure 1 - distribution of daily prices

twoway (histogram new_price if new_price<501, bin(100) xlab(25 100 200 300 400 500) bcolor(gray) blcolor(black) ///
 xscale(range(25 500)) xtitle("Price") graphregion(color(white)) ) 
graph export $results/Fig1_distri_price.eps, replace

sum price, d
sum new_price, d

 

// Figure A3 Left: Histogram distribution of the number of reviews 
histogram review if review <= 50, discrete width(0.5) xtitle("Number of reviews") bcolor(gray) blcolor(black) ///
 graphregion(color(white))
graph export $results/FigA3_distribution_reviews.eps, replace
 
// Figure A3 Right: Histogram distribution of the delta number of reviews 
histogram Drev if   Drev<=50, discrete width(0.5) bcolor(gray) blcolor(black) xscale(range(1 50)) ///
 xtitle("Variation in the number of reviews between the first and last observations") ///
 graphregion(color(white))
graph export $results/FigA3_distribution_Deltareviews.eps, replace


// Figure A4 - Illustration of the conceptual framework: Prices with the number of reviews, by unobservable quality

 
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


