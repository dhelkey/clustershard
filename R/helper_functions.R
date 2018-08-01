lra = function(x){
  #' Log-Ratio Analysis Transformation.
  #'
  #' Transforms a observational row to LRA, 
  #' following Baxter (2006).
  # stopifnot(round(sum(x)) == 100)
  p = length(x)
  gx = prod(x)^(1/p)
  out = log(x / gx)
  return( out)
}


#TODO ADD TESTS for these, especially where we expect ceretain functoins to return a type of code



plotNull = function(){
	plot(1, type = 'n', xlab = '', ylab = '', axes = FALSE)
}



clusterPlot = function(dat_plot, point_size = 1, level = 0.9, gauss = FALSE){
	g = ggplot(dat_plot, aes(x = pc1, y = pc2, color = cluster_id)) + 
	geom_point( size = point_size)
   if (gauss){
   g =  g + stat_ellipse(level = level)
   }	
   return(g)
}

scatterPlot = function(dat_plot, element1, element2, point_size = 1){
	ggplot(dat_plot, aes_string(x = element1, y = element2)) +
        geom_point(size = point_size, aes(color = cluster_id))
}


datClusterAvgFun = function(dat_plot, elements){
	print(colnames(dat_plot))
      mean_cluster = dat_plot %>% group_by(cluster_id) %>% select(cluster_id, elements) %>% summarise_all(mean)
      mean_cluster_long = reshape2::melt(mean_cluster, id.vars = "cluster_id")
}

clusterBar = function(dat_cluster_avg){
       ggplot(dat_cluster_avg, aes(x = cluster_id,y = value,  fill = cluster_id))  +
         facet_wrap(~variable, scales = 'free') +
         geom_col()
}




transformDat = function(dat, avg_readings = FALSE, standardize = FALSE,
	transformation = 'none', offset = 1e-8){
	
   #Aggregate or not
    if (avg_readings){
	##TODO Li:U - set elemenet names globaly
		dat_use = dat %>% group_by(id)%>% select(id, Li:U) %>% summarise_all(funs(mean))
    } else {
      dat_use = dat %>% select(id, Li:U)
    }
    #Extract numeric values
    dat_vals  = as.matrix(select(dat_use, Li:U))
    
    #Remove small values
    dat_vals[dat_vals <= 0 ] = offset
    
    if (transformation == 'log'){
      dat_vals = apply(dat_vals, 2, log)
    } else if (transformation == 'lra'){
      dat_vals = t(apply(dat_vals, 1, lra))
    } else if (transformation == 'none'){
      dat_vals = dat_vals
    }
	##TODO do a test to make sure that this yields the same results as putting it in prcomp()
	if (standardize){
		dat_vals = scale(dat_vals)
	}
    return(dat_vals)
}




clusterPotteryDat = function(dat_vals, k, pc_keep = NULL, method = 'gmm' ){
	
	#Cluster based on principle components transformation of 
	pr = prcomp(dat_vals)
	pr_comp = as.matrix(pr$x)
	
	if (!is.null(pc_keep)){
		pr_comp = pr_comp[ ,1:pc_keep]
	}

	if (method == 'kmeans'){
		k_cluster = kmeans(pr_comp, k)
		cl_data = k_cluster$cluster
	} else if (method == 'gmm'){
		gmm = mclust::Mclust(pr_comp, G = k)
		cl_data = gmm$classification
	}
	
	##TODO recode the cluster_id variable in asscending order of avg pc1
	cluster_id_old = cl_data
	pc1 = pr_comp[ ,1]
	cluster_mean_pc1 = sapply(1:k, 
							function(i) mean(pc1[cluster_id_old == i]))
	cluster_order = order(order(cluster_mean_pc1))
	cluster_id = as.factor(cluster_order[cluster_id_old])
	
	return( list(
		cluster_id =cluster_id,
		pc_mat = pr_comp
	))
	}

	
	
	
	

processPotteryDat = function(file_path, avg_obs = FALSE){
	#'Process pottery data file
	#'
	#' Takes in the output from read_csv(...) and processes according to
	#' the conventionss
	
      #Read element names
      #Element names Li:U
	  dat_raw = read.csv(file_path)
      element_names = names(dat_raw)[-(1:2)]
      element_names_p = stringr::str_sub(gsub("[[:digit:]]",'',element_names),2)
      
      #Example ID format: D0506-1a    8/24/2016 1:28:10 PM
      #WARNING, hardcoded values
      #This is very prone to breaking if the format changes
      id_run_list = stringr::str_split(dat_raw$SampleNo,'-')
      dat_raw$id = sapply(id_run_list, function(x) x[1]) #D0506
      run_vec = sapply(id_run_list, function(x) x[2])
      dat_raw$run = stringr::str_sub(run_vec,1, 2) #1a
         
      ###############################
      ###############################
	  #TODO - add warnings when it looks like data violates assumptions....
      ##Remove the zero row (row 76, would want to do this in a better way)
      #print(dat_raw[76, ])
      #dat_raw = dat_raw[-76, ]    
      
	  #print(head(dat_raw))
      #Remove File '160812-B' and sort by ID
      #dat = dat_raw %>% 
      #  filter(!stringr::str_detect(DataFile, stringr::regex('160812-B', ignore_case = T)) ) %>% 
      #  arrange(id)
      ###############################
      ###############################
      
      #Change column names and output clean version to work with 
      dat = dat_raw[ , c('DataFile', 'id', 'run', element_names)]
      names(dat) = c('file', 'id', 'run', element_names_p)
      return(dat)
}