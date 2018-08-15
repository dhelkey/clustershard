lra = function(x){
  #' Log-Ratio Analysis Transformation.
  #'
  #' Transforms a observational row to LRA, 
  #' following Baxter (2006).
  p = length(x)
  gx = prod(x)^(1/p)
  out = log(x / gx)
  return( out)
}


#TODO ADD TESTS for these, to enforce API is followed

datClusterAvgFun = function(dat_plot, elements){
	#' Compute mean element concentration by cluster
      mean_cluster = dat_plot %>% group_by(cluster_id) %>% select(cluster_id, elements) %>% summarise_all(mean)
      mean_cluster_long = reshape2::melt(mean_cluster, id.vars = "cluster_id")
}

transformDat = function(dat, avg_readings = FALSE, standardize = FALSE,
	transformation = 'none', offset = 1e-8){
	#' Transform data matrix
	
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
	if (standardize){
		dat_vals = scale(dat_vals)
	}
    return(dat_vals)
}



clusterPotteryDat = function(dat_vals, k, pc_keep = NULL, method = 'gmm' ){
	#' Cluster a data matrix using principle components
	#'
	#' /code{clusterPotteryDat} takes in a data matrix, performs a principle
	#' components transformation, and clusters using the first k components.
	#'
	#' @inputs
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
	#Reorder clusters to be increasing in average 1st principle component	
	cluster_id_old = cl_data
	pc1 = pr_comp[ ,1]
	cluster_mean_pc1 = sapply(1:k,function(i) mean(pc1[cluster_id_old == i]))
	cluster_order = order(order(cluster_mean_pc1))
	cluster_id = as.factor(cluster_order[cluster_id_old])
	
	return( list(
		cluster_id =cluster_id,
		pc_mat = pr_comp
	))
}


