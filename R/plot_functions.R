plotNull = function(){
	plot(1, type = 'n', xlab = '', ylab = '', axes = FALSE)
}

clusterPlot = function(dat_plot, marker_size = 1, level = 0.9, gauss = FALSE){
	g = ggplot(dat_plot, aes_string(x = 'pc1', y = 'pc2', color = 'cluster_id')) + 
	geom_point( size = marker_size)
	if (gauss){
		g =  g + stat_ellipse(level = level)
	}	
	return(g)
}

scatterPlot = function(dat_plot, element1, element2, marker_size = 1){
	ggplot(dat_plot, aes_string(x = element1, y = element2)) +
        geom_point(size = marker_size, aes(color = cluster_id))
}

boxPlot = function(dat_vals){
		dat_long = utils::stack(as.data.frame(dat_vals)) #ggplot requires data be in long format
		ggplot(dat_long) + 
		geom_boxplot(aes_string(x = 'ind', y = 'values')) + labs(x = 'element', y = 'value')
}

clusterBar = function(dat_cluster_avg){
	#' Create barplot of element concentration by cluster
       ggplot(dat_cluster_avg, aes_string(x = 'cluster_id',y = 'value',  fill = 'cluster_id'))  +
         facet_wrap(~variable, scales = 'free') +
         geom_col()
}