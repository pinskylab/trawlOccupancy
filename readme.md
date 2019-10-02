# trawlOccupancy

A couple scripts to process the multispecies occupancy model (MSOM) output from the [trawlDiversity package](https://github.com/rBatt/trawlDiversity) and save posterior estimates of species occupancy probabilities by grid cell in each year.

* dataDL/ has the .RData files downloaded from trawlDiversity (not tracked by git since from trawlDiversity)
* scripts/ has the scripts. Run process_output.r
* output/ has the output from the scripts in gzipped csvs. Key columns are
	* reg: region abbreviation
	* spp: species name
	* lon: longitude of the grid cell
	* lat: latitude of the grid cell
	* depth: depth band of the grid cell
	* year: year
	* ppres_mu: posterior mean probability of presence (averaging over the iterations of all chains from the MSOM)
	* ppres_sd: standard deviation of the posterior probability of presence (sd of the iteractions from all chains)