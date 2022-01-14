program fun_structural_fe

// Define parameters and starting values
gen rho = 0.136
local diff = 500
local iter = 1

* Specifications
global struc_step1 c.minodummy#ib10.wave $lesX i.citywaveID lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho  

// First iter (to kill the NAs in the predicted values of phat) 
gen KKrho = (rev100)/(rho+rev100) 
gen lastrat10_KKrho=lastrat10*KKrho
gen lastrat9_KKrho=lastrat9*KKrho
gen lastrat8_KKrho=lastrat8*KKrho
gen lastrat7_KKrho=lastrat7*KKrho
gen minodummy_KKrho=-minodummy*KKrho

// OLS regression
quietly xtreg log_price $struc_step1, fe i(newid)
estimates store mreg
estout mreg, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(mino* *last* *rho*) stats(r2_a N, fmt(%9.3f %9.0g) label(AdjR2 obs.)) style(tex) replace starlevels(* 0.1 ** 0.05 *** 0.01 ) 

replace KKrho = 0
replace lastrat10_KKrho = 0
replace lastrat9_KKrho = 0
replace lastrat8_KKrho = 0
replace lastrat7_KKrho = 0
replace minodummy_KKrho = 0

predict phat0, xb
drop if missing(phat0)

tempvar y 
gen `y' = log_price - phat0
bys newid: egen y_mean = mean(`y') 
gen y_diff = `y' - y_mean
drop y_mean

// Use the NL program
matrix inivals = (.115, .062, -.005, -.029, -.034, .136)
nl structfe @ y_diff rev100 lastrat10 lastrat9 lastrat8 lastrat7 minodummy newid, parameters(b10 b9 b8 b7 bm rho) initial(inivals)

// Replace rho by its estimate (obtained via NL estimation)
local diff=abs(rho-_b[/rho])/rho
replace rho=_b[/rho]
display  "Rho : " _b[/rho]
display  "beta m : " _b[/bm]

// Drop interacted variables depending on rho
drop phat0 KKrho lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho y_diff

// Next iteration
local iter =`iter'+1
while `diff'>=0.001 & `iter'<10 {
    
    gen KKrho = (rev100)/(rho+rev100) 
    gen lastrat10_KKrho=lastrat10*KKrho
    gen lastrat9_KKrho=lastrat9*KKrho
    gen lastrat8_KKrho=lastrat8*KKrho
    gen lastrat7_KKrho=lastrat7*KKrho
    gen minodummy_KKrho=-minodummy*KKrho

    quietly xtreg log_price $struc_step1, fe i(newid)
    estimates store mreg
    estout mreg, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(*mino* *last* *rho*) stats(r2_a N, fmt(%9.3f %9.0g) label(AdjR2 obs.)) style(tex) replace starlevels(* 0.1 ** 0.05 *** 0.01 ) 
    
    replace KKrho = 0
    replace lastrat10_KKrho = 0
    replace lastrat9_KKrho = 0
    replace lastrat8_KKrho = 0
    replace lastrat7_KKrho = 0
    replace minodummy_KKrho = 0

    predict phat0, xb
    drop if missing(phat0)

tempvar y 
gen `y' = log_price - phat0
bys newid: egen y_mean = mean(`y') 
gen y_diff = `y' - y_mean
drop y_mean

    matrix inivals = (.115, .062, -.005, -.029, -.034, .136)
    nl structfe @ y_diff rev100 lastrat10 lastrat9 lastrat8 lastrat7 minodummy newid, parameters(b10 b9 b8 b7 bm rho) initial(inivals)
  
    local diff=abs(rho-_b[/rho])/rho
    replace rho=_b[/rho]
    display  "Rho : " _b[/rho]
    display  "beta m : " _b[/bm]
    
    drop phat0 KKrho lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho y_diff
local iter =`iter'+1
}

*****global struc_step1 c.minodummy#ib10.wave $lesX i.citywaveID lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho  


// Final regression
gen KKrho = (rev100)/(rho+rev100) 
gen lastrat10_KKrho=lastrat10*KKrho
gen lastrat9_KKrho=lastrat9*KKrho
gen lastrat8_KKrho=lastrat8*KKrho
gen lastrat7_KKrho=lastrat7*KKrho
gen minodummy_KKrho=-minodummy*KKrho

replace rho=_b[/rho]
gen se_rho=_se[/rho]

preserve
keep rho se_rho
duplicates drop
gen it=$e_sample
save $results_sample/rho.dta,replace
restore

quietly{
    xtreg log_price $struc_step1 , fe i(newid)
    estimates store m1
	parmest, saving($results_sample/res_reg_1.dta, replace)

    xtreg log_price $lesX c.minodummy#ib10.wave lastrat7 lastrat8 lastrat9 minodummy i.citywaveID minodummy_KKrho KKrho, fe i(newid)
   estimates store m2
   parmest, saving($results_sample/res_reg_2.dta, replace)

}

forvalues i =1/2 {
use $results_sample/res_reg_`i'.dta, clear
drop dof t p min95 max95
keep if regexm(parm,"KKrho")
gen it=$e_sample
save $results_sample/res_reg_`i'.dta, replace
}
 

 use $results_sample/res_reg_1.dta, clear
  append using $results_sample/res_reg_2.dta
    append using $results_sample/rho.dta
	replace parm="rho" if parm==""
	replace estimate=rho if  parm=="rho"
	replace stderr=se_rho if  parm=="rho"
	drop rho se_rho

  gen n=_n
 drop parm
reshape wide estimate stderr, i(it) j(n)
rename estimate1 b_lastrat10_KKrho
rename stderr1 se_lastrat10_KKrho
rename estimate2 b_lastrat9_KKrho
rename stderr2 se_lastrat9_KKrho
rename estimate3 b_lastrat8_KKrho
rename stderr3 se_lastrat8_KKrho
rename estimate4 b_lastrat7_KKrho
rename stderr4 se_lastrat7_KKrho
rename estimate5 b1_minodummy_KKrho
rename stderr5 se1_minodummy_KKrho 
rename estimate6 b2_minodummy_KKrho
rename stderr6 se2_minodummy_KKrho 
rename estimate7 b_KKrho
rename stderr7 se_KKrho 
rename estimate8 b_rho
rename stderr8 se_rho 

 save $results_sample/res_regs_$e_sample.dta, replace
 

end
