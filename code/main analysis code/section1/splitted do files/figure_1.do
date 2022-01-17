*Figure 1
twoway (histogram new_price if new_price<501, bin(100) xlab(25 100 200 300 400 500) bcolor(gray) blcolor(black) ///
 xscale(range(25 500)) xtitle("Price") graphregion(color(white)) ) 
graph export $results/Fig1_distri_price.eps, replace

sum price, d
sum new_price, d
