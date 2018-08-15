processPotteryDat = function(filelement_names_path, element_start_column = 3){
	#'Process pottery data file
	#'
	#' Reads in a csv file for pottery shard concentration
	#' File should have one row per pottery shard observation
	#' The SampleNo column in the file should contain the
	#'  the shard id and the observation number separated by 
	#'  a "-".
	#'
	#'@inputs
	#' 
	
	#The first 2 columns need to be ID info
	stopifnot(element_start_column > 2)
	
    #Read in csv from path
	dat_raw = read.csv(filelement_names_path)
	  
	#Remove punctuation from variable names
	names(dat_raw) = gsub('[[:punct:]]+','',names(dat_raw))
	  
	#Extract elements names & remove leading number
    element_names = names(dat_raw)[-(1:element_start_column - 1)]  
    element_names_p =  stringr::str_split(element_names, '[[:digit:]]')
	element_names_p = lapply(element_names_p, tail, 1)
	element_names_p = as.character(do.call('rbind', element_names_p))
	
	#Import element data for validation
	data("elements", envir = environment())
	element_names_full = elements$symbol
	
	#See if there are any unrecognized elements
	element_binary = !(element_names_p %in% element_names_full)
	if(sum(element_binary) > 0){
		stop( paste0('Unrecognized Elements:', 
			paste(element_names_p[element_binary], collapse = ',') ))
	}
	  
    #Example ID format: D0506-1a   8/24/2016 1:28:10 PM
	#WARNING, this function must be changed if the ID format changes, 
	id_run_list = stringr::str_split(dat_raw$SampleNo,'-')

    dat_raw$id = sapply(id_run_list, function(x) x[1]) #D0506
	run_vec = sapply(id_run_list, function(x) x[2])
    dat_raw$run = stringr::str_sub(run_vec,1, 2) #1a
         
    #Change column names and output clean version to work with 
    dat = dat_raw[ , c('DataFile', 'id', 'run', element_names)]
    names(dat) = c('file', 'id', 'run', element_names_p)
    return(list( dat = dat, element_names = element_names_p))
}