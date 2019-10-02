# try to read in JAGS output from trawlDiversity and save the species occurrence probabilities per grid cell

require(rjags)
require(data.table)
source('scripts/get_iters.R')
source('scripts/helperMisc.R') # for lu()
source('scripts/getpresbygrid_msomStatic.r')

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
    
# do other regions next


