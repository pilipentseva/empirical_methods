preserve
duplicates drop newid, force
* Appendix A3
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