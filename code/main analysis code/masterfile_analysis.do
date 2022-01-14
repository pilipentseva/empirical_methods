global data "C:/Users/Имя/OneDrive/Рабочий стол/my github project/data"
global code "C:/Users/Имя/OneDrive/Рабочий стол/my github project/code"
global results "C:/Users/Имя/OneDrive/Рабочий стол/my github project/results"

clear all

set matsize 11000
set maxvar 32000


    * *** Add required packages from SSC to this list ***
    local ssc_packages "distinct" "parmest" "eststo"
	
    if !missing("`ssc_packages'") {
        foreach pkg in "`ssc_packages'" {
        * install using ssc, but avoid re-installing if already present
            capture which `pkg'
            if _rc == 111 {                 
               dis "Installing `pkg'"
               quietly ssc install `pkg', replace
               }
        }
    }
	
	
 **MASTERFILE**
log using $results/masterfile.log, replace



use $data/base_airbnb_AEJ.dta, clear
xtset newid wave

do $code/global_vars.do
global_vars

*creation sub-folder "results"
capture mkdir "$results/"



 *Descriptive Statistics*
do $code/summary_stat_sec1

/*
Section 1
Appendix Table A1 - number of observations and listings by city
Appendix Figure A2 - number of observations by listing
Appendix Table A3 - full list of characteristics of the properties and the hosts
Figure 1 - distribution of daily prices
Appendix Table A4 - hedonic regression
Table 1 - raw price gaps by ethnic groups
Appendix Table A5 - distribution of the last rating
Appendix Table A6 - number of neighbourhoods and blocks per city


Section 4
Figure A3 - Distribution of the number of reviews  
and of the longitudinal variation in the number of reviews within a property 

Figure A4 - Illustration of the conceptual framework: 
Prices with the number of reviews, by unobservable quality

*/

do $code/preliminary_regression_sec2

/*
Section 1
Table 2 - ethnic  price  differential  for  several specifications
Table 3 - ethnic price gap, for several segments of the number of reviews

Section 4
Table 5 - Robustness: Linear and quadratic models of price with listing FE

*/

 
   *Structural Estimation*
use $data/base_airbnb_AEJ.dta, clear
xtset newid wave
global sample "full"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/main_regression_sec3


/*
Section 3
Table 4 - Non-linear model of log-prices as a function of the number of reviews
*/


  *ADDITIONAL RESULTS / ROBUSTNESS*
do $code/additional_stat_analysis_sec4


/*
Section 4

Table 6 - main  analysis  on  several  sub-samples
Table 7 - Ethnic  matching  between  Arabic/Muslim  hosts  and  Arabic/Muslim guests
Table 8 - Average rating, depending on hosts’ and guests’ ethnicity
Table 9 - Differential Upgrading
Table 10 - Ethnic differentials in the accumulation of reviews over time
*/

do $code/appendix_sec5

/*
Appendix

Table A7 - Behaviour of hosts posting non-person pictures
Table A8 - Probability to leave the market at wave t


*/

		  
log close


