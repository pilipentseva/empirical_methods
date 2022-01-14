## theory_K_price
## Produces the theory_K_price.pdf plot for Fig A4
## 

## Clean up workspace
rm(list=ls())

## Load useful packages
library(tidyverse)
library(here) #sets the root folder as home, as it contains a .here file 

## Systematic unobserved quality penalty for mino
delnu = -.2
## Stdev error review
sigrev <- 3
## Stdev unobservables
signu <- 1
## rho
rho <- (sigrev/signu)^2;

## Plot
tibble(K = rep(0:49,times=5),
       q5 = rep(1:5,each=50),
       rbar = q5 - 3,
       price = (K*rbar+ rho*delnu)/(K+rho)) %>%
    mutate(`Quintile quality` = factor(q5, levels=5:1)) %>% 
    ggplot(aes(x=K, y=price,
               linetype=`Quintile quality`,
               color=`Quintile quality`)) + 
    geom_line() +
    labs(x="Number of reviews", y="Price") + 
    theme_bw(base_size=15) +
    scale_colour_grey()

## Save
ggsave(here("results","theory_K_price.pdf"),width=9)

