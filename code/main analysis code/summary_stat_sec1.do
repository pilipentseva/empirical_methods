
 
gen Drev=Drev100*100

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit


// Appendix Table A3 - full list of characteristics of the properties and the hosts 
do $code/table_a3


 
 
// Appendix Table A1 - number of observations and listings by city

do $code/table_a1

// Appendix Table A4 - hedonic regression

do $code/table_a4

// Table 1 - raw price gaps by ethnic groups

do $code/table_1
 // Appendix Table A5 - Distribution of the last rating

do $code/table_a5
// Appendix Table A6 - number of neighbourhoods and blocks per city

do $code/table_a6
 


// Appendix Figure A2 - number of observations by listing

do $code/figure_a2
 
// Figure 1 - distribution of daily prices

do $code/figure_1


 * Figure A3
do $code/figure_a3
 


// Figure A4 - Illustration of the conceptual framework: Prices with the number of reviews, by unobservable quality
do $code/figure_a4
 

 


