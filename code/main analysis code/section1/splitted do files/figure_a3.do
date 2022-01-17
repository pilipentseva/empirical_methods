*Figure A3
// Figure A3 Left: Histogram distribution of the number of reviews 
histogram review if review <= 50, discrete width(0.5) xtitle("Number of reviews") bcolor(gray) blcolor(black) ///
 graphregion(color(white))
graph export $results/FigA3_distribution_reviews.eps, replace
 
// Figure A3 Right: Histogram distribution of the delta number of reviews 
histogram Drev if   Drev<=50, discrete width(0.5) bcolor(gray) blcolor(black) xscale(range(1 50)) ///
 xtitle("Variation in the number of reviews between the first and last observations") ///
 graphregion(color(white))
graph export $results/FigA3_distribution_Deltareviews.eps, replace
