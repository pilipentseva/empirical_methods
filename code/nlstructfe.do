

capture program drop nlstructfe
program nlstructfe, rclass
version 14
syntax varlist(min=8 max=8) if, at(name)
local y_diff : word 1 of `varlist'
local rev100 : word 2 of `varlist'
local lastrat10 : word 3 of `varlist'
local lastrat9 : word 4 of `varlist'
local lastrat8 : word 5 of `varlist'
local lastrat7 : word 6 of `varlist'
local minodummy : word 7 of `varlist'
local newid : word 8 of `varlist'
// Retrieve parameters out of at matrix
tempname b10 b9 b8 b7 bm rho
scalar `b10' = `at'[1, 1]
scalar `b9'  = `at'[1, 2]
scalar `b8'  = `at'[1, 3]
scalar `b7'  = `at'[1, 4]
scalar `bm'  = `at'[1, 5]
scalar `rho' = `at'[1, 6]
// Within differentiation
tempvar KKrho KKrho_mean KKrho_diff rhs
gen double `KKrho' =(`rev100')/(`rho'+`rev100') `if'
bys `newid': egen `KKrho_mean' = mean(`KKrho') `if'
gen double `KKrho_diff' = `KKrho'-`KKrho_mean' `if'
gen double `rhs' = (`b10'*`lastrat10'+`b9'*`lastrat9'+`b8'*`lastrat8'+`b7'*`lastrat7'-`bm'*`minodummy')*`KKrho_diff' `if'
// replace dependent variable
replace `y_diff' = `rhs' `if'
end


