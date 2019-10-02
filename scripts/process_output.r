# read in JAGS output from trawlDiversity and save the species occurrence probabilities per grid cell

require(rjags)
require(data.table)
source('scripts/get_iters.R')
source('scripts/helperMisc.R') # for lu()
source('scripts/getpresbygrid_msomStatic.r')


# ai
load('dataDL/msomStatic_norv_1yr_ai_jags_12kIter_50nZ_start2017-04-28_r2.RData')
sapply(rm_out, length) # not sure why only item 2 has data
ai <- getpresbygrid_msomStatic(rm_out[[2]]) 
    ai
write.csv(ai, file=gzfile('output/ai.csv.gz'))


# ebs
load('dataDL/msomStatic_norv_1yr_ebs_jags_12kIter_50nZ_start2016-05-07_r1.RData')
sapply(rm_out, length) # not sure why only item 1 has data
ebs <- getpresbygrid_msomStatic(rm_out[[1]]) 
    ebs
write.csv(ebs, file=gzfile('output/ebs.csv.gz'))


# gmex
load('dataDL/msomStatic_norv_1yr_gmex_jags_12kIter_50nZ_start2016-05-07_r6.RData')
sapply(rm_out, length) # not sure why only item 6 has data
gmex <- getpresbygrid_msomStatic(rm_out[[6]]) 
    gmex
write.csv(gmex, file=gzfile('output/gmex.csv.gz'))


# goa
load('dataDL/msomStatic_norv_1yr_goa_jags_12kIter_50nZ_start2017-04-28_r3.RData')
sapply(rm_out, length) # not sure why only item 3 has data
goa <- getpresbygrid_msomStatic(rm_out[[3]]) 
    goa
write.csv(goa, file=gzfile('output/goa.csv.gz'))


# neus
load('dataDL/msomStatic_norv_1yr_neus_jags_12kIter_50nZ_start2016-05-07_r8.RData')
sapply(rm_out, length) # not sure why only item 8 has data
neus <- getpresbygrid_msomStatic(rm_out[[8]]) 
    neus

write.csv(neus, file=gzfile('output/neus.csv.gz'))


# newf
load('dataDL/msomStatic_norv_1yr_newf_jags_12kIter_50nZ_start2016-05-07_r10.RData')
sapply(rm_out, length) # not sure why only item 10 has data
newf <- getpresbygrid_msomStatic(rm_out[[10]]) 
    newf
write.csv(newf, file=gzfile('output/newf.csv.gz'))


# sa
load('dataDL/msomStatic_norv_1yr_sa_jags_12kIter_50nZ_start2016-05-07_r7.RData')
sapply(rm_out, length) # not sure why only item 7 has data
sa <- getpresbygrid_msomStatic(rm_out[[7]]) 
    sa
write.csv(sa, file=gzfile('output/sa.csv.gz'))


# scotian shelf
load('dataDL/msomStatic_norv_1yr_shelf_jags_12kIter_50nZ_start2016-05-07_r9.RData')
sapply(rm_out, length) # not sure why only item 9 has data
shelf <- getpresbygrid_msomStatic(rm_out[[9]]) 
    shelf
    summary(shelf)
write.csv(shelf, file=gzfile('output/shelf.csv.gz'))


# wctri
load('dataDL/msomStatic_norv_1yr_wctri_jags_12kIter_50nZ_start2016-05-07_r4.RData') # load rm_out
sapply(rm_out, length) # not sure why only item 4 has data
wctri <- getpresbygrid_msomStatic(rm_out[[4]]) 
    wctri
    
    # a test plot
    par(mfrow=c(4,3), mai=c(0.2, 0.2, 0.2, 0.2))
    for(yr in wctri[,sort(unique(year))]){
        wctri[spp=='Allosmerus elongatus' & year==yr, plot(lon, lat, cex=ppres_mu, pch=16, main=yr)]
    }

write.csv(wctri, file=gzfile('output/wctri.csv.gz'))


# west coast annual
load('dataDL/msomStatic_norv_1yr_wcann_jags_12kIter_50nZ_start2016-05-07_r5.RData')
sapply(rm_out, length) # not sure why only item 5 has data
wcann <- getpresbygrid_msomStatic(rm_out[[5]]) 
    wcann
write.csv(wcann, file=gzfile('output/wcann.csv.gz'))



