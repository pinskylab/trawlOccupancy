# adapted from trawlDiversity process_msomStatic.R
#' Process Output from msomStatic (annual) and output p(occupancy) by grid cell/year/species
#' 
#' Processes a list structured as run_msom output (level 2) within a year (level 1) to be used to summarize diversity. Note that this function then only processes 1 region at a time, so it expects a list whose length is equal to the number of years for a region. Currently, intended to work with Stan model.
#' 
#' @param reg_out A list with length equal to number of years in a region, with each element containing output from run_msom
#' @param save_mem Save memory be deleting intermediate steps as function progresses; default TRUE (only reason for FALSE is for debugging)
#' 
#' @details Right now only intended for use with specific structuring of the output, so that it matches the output expected from running each year separately using the Stan version of the msomStatic model.
#' 
#' @export
getpresbygrid_msomStatic <- function(reg_out, save_mem=TRUE){

	# ====================
	# = Organize Read-in =
	# ====================
	out <- lapply(reg_out, function(x)x$out)
	empty_ind <- sapply(out, is.null)
	out <- out[!empty_ind]
	inputData <- lapply(reg_out, function(x)x$inputData)[!empty_ind]
	info <- lapply(reg_out, function(x)x$info)[!empty_ind]
	
	regs <- sapply(info, function(x)x["reg"])
	stopifnot(lu(regs)==1)
	reg <- unique(regs)
	
	langs <- unlist(sapply(info, function(x)x["language"]))
	stopifnot(lu(langs)==1)
	lang <- unique(langs)
	
	
	# =====================
	# = Get Full Data Set =
	# =====================
	# ---- Makes [rd] ----
	info_yrs <- sapply(info, function(x)as.integer(x['year']))
	sub_reg <- reg
	
	# ====================================================
	# = Get Posterior Samples (iterations) of Parameters =
	# ====================================================
	if(lang == "JAGS"){
		z_spp <- function(x){gsub("Z\\[[0-9]+\\,([0-9]+)\\]$", "\\1", x)}
		z_j <-   function(x){gsub("Z\\[([0-9]+)\\,[0-9]+\\]$", "\\1", x)}
		j_lon <-   function(x){gsub("([-0-9]+\\.*[0-9]+)\\s+[0-9]+\\.*[0-9]+\\s+[0-9]+$", "\\1", x)} # extract lon from grid name
		j_lat <-   function(x){gsub("[-0-9]+\\.*[0-9]+\\s+([0-9]+\\.*[0-9]+)\\s+[0-9]+$", "\\1", x)} # extract lat
		j_depth <-   function(x){gsub("[-0-9]+\\.*[0-9]+\\s+[0-9]+\\.*[0-9]+\\s+([0-9]+)$", "\\1", x)} # extract depth
		psppgrid <- list()
		for(i in 1:length(out)){ # for each year
			
			# ---- Get Z Iters ----
			# Z[2,1] is jID 2, sppID 1. jID is grid cell ID?
			t_Z_big <- get_iters(out[[i]], pars="Z", lang="JAGS")
			t_Z_big[,iter:=(1:nrow(t_Z_big))]
				
			t_Z_big_long <- data.table:::melt.data.table(t_Z_big, id.vars=c("iter","chain"))
			t_Z_big_long[, c("sppID","jID"):=list(z_spp((variable)), z_j((variable))), by=c("variable")] # rows are iterations of each chain for each grid cell for each species
			if(save_mem){rm(list="t_Z_big")}
				
			# ---- mean p(spp present) per grid cell ----
			nJ <- t_Z_big_long[,length(unique(jID))] # number of grid cells
			psppgrid[[i]] <- t_Z_big_long[, .(ppres_mu=mean(value), ppres_sd=sd(value)), by=c("jID", "sppID")]
			sppNames <- dimnames(inputData[[i]]$X)$spp
			psppgrid[[i]][,spp:=sppNames[as.integer(sppID)]] # add spp names
			psppgrid[[i]] <- psppgrid[[i]][!grepl("Unknown_[0-9]+", spp)] # remove unknown spp
			gridNames <- dimnames(inputData[[i]]$X)$stratum
			psppgrid[[i]][,grid := gridNames[as.integer(jID)]] # add grid names
			psppgrid[[i]][,lon := j_lon(grid)] # add lon
			psppgrid[[i]][,lat := j_lat(grid)] # add lat
			psppgrid[[i]][,depth := j_depth(grid)] # add depth
			psppgrid[[i]][,sppID:=NULL]
			psppgrid[[i]][,jID:=NULL]
			psppgrid[[i]][,grid:=NULL]
			psppgrid[[i]][,year:=info_yrs[i]]
						
		}
	} else {
		stop('Language is not JAGS')
	}
	
	psppgrid2 <- rbindlist(psppgrid) # rbind all years together
	psppgrid2[,reg := reg] # add region
	
	setcolorder(psppgrid2, c('reg', 'spp', 'lon', 'lat', 'depth', 'year', 'ppres_mu', 'ppres_sd'))
	psppgrid2[order(spp, lon, lat, depth, year)]
	
	# return
	return(psppgrid2)
	
}
	