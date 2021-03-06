# simulation from nested-factor model with 3 groups
# MLE for nested-factor copula log-likelihood

library(CopulaModel)
#source("../R/structcopsim.R")

options(digits=5)
grsize=c(4,4,3)
d=sum(grsize)
mgrp=length(grsize)
# number of params is length(grsize) + sum(grsize)
n=600 

th0f=frk.b2cpar(.3) # 2.557304
th1f=frk.b2cpar(.5) # 4.875
th2f=frk.b2cpar(.4) # 3.6021
th3f=frk.b2cpar(.4) # 3.6021
th0g=gum.b2cpar(.3) # 1.434065
th1g=gum.b2cpar(.5) # 1.996644
th2g=gum.b2cpar(.4) # 1.669696
th3g=gum.b2cpar(.4) # 1.669696

set.seed(123)
# Frank for group with global, and observed with group latent variable
parf=c(rep(th0f,3),rep(th1f,4),rep(th2f,4),rep(th3f,4))
udatf=simnestfact(n, grsize, cop=5, parf)
rf=cor(udatf)
set.seed(123)
# Gumbel for group with global, and observed with group latent variable
parg=c(rep(th0g,3),rep(th1g,4),rep(th2g,4),rep(th3g,4))
udatg=simnestfact(n, grsize, cop=3, parg)
rg=cor(udatg)

cat("correlation matrix of Frank nested data\n")
print(rf)
cat("correlation matrix of Gumbel nested data\n")
print(rg)

cat("\n============================================================\n")
gl=gausslegendre(25)
dstrfrk = list(data=udatf,copname="frank",quad=gl,repar=0,grsize=grsize);
dstrgum = list(data=udatg,copname="gumbel",quad=gl,repar=0,grsize=grsize);
npar=mgrp+d
paramf=rep(3,npar)
paramg=rep(2,npar)
LBf=rep(0,npar); UBf=rep(20,npar)
LBg=rep(1,npar); UBg=rep(30,npar)
ifixed = rep(F,npar)
cat("\nfrank nested: group parameters at beginning\n")
out1f= pdhessminb(paramf,f90str1nllk, ifixed=ifixed, dstrfrk, LBf, UBf, 
   mxiter=30, eps=5.e-5,iprint=T) 
print(out1f$iposdef)
cat("parameters for simulation:\n", parf,"\n")
cat("\n============================================================\n")
cat("\ngumbel nested: group parameters at beginning\n")
out1g= pdhessminb(paramg,f90str1nllk, ifixed=ifixed, dstrgum, LBg, UBg, 
   mxiter=30, eps=5.e-5,iprint=T) 
print(out1g$iposdef)
cat("parameters for simulation:\n", parg,"\n")

# for 3 groups, parameter for one group latent variable with global latent
#  often becomes comonotonic unless sample size is very large
