*Appendix Table A4
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
 