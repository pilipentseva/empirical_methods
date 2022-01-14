## graphs_price_reviews.R
## Produces price_reviews_xtreg_majo.pdf for Fig 2
## 

## Clean up workspace
rm(list=ls())
## Load useful packages
library(tidyverse)
library(here) #sets the root folder as home, as it contains a .here file 

## Create grid and spline
dd <- 1:60
knots=c(5,10,20,30,50)
lins = dd
for (ki in knots){lins = cbind(lins,pmax(0,dd-ki))}

## Import data
coef <- read.table(here("results","xtreg_price_reviews_majo.txt"),
                   stringsAsFactors=FALSE,comment.char="",sep="&")
coef <- as.matrix(coef[grep("revc",coef[,1]),2])
class(coef) <- "numeric"

## Build predicted values
p7 <- coef[1:6,]
p8 <- coef[6+(1:6),]
p9 <- coef[12+(1:6),]
p10 <- coef[18+(1:6),]

ff7 = (lins%*%p7)
ff7[31:60] = NA
ff8 = (lins%*%p8)
ff9 = (lins%*%p9)
ff10 = (lins%*%p10)

fmat <- rbind(ff7,ff8,ff9,ff10)

## Sort in dataset for ggplot
dat = data.frame(dd=rep(dd,times=4),ffe=fmat,
  stars=factor(rep(c("3.5 or less","4","4.5","5"),each=length(dd)),
    level=rev(c("3.5 or less","4","4.5","5")),ordered=TRUE))

## ggplot and export
ggplot(dat,aes(x=dd,y=ffe,linetype=stars, colour=stars)) +
  geom_line() + 
  labs(x="Number of reviews",y="Relative price") + 
  theme_bw(base_size=15) +
  scale_colour_grey()
ggsave(here("results","price_reviews_xtreg_majo.pdf"))
