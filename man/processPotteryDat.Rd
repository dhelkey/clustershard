% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processPotteryDat.R
\name{processPotteryDat}
\alias{processPotteryDat}
\title{Process pottery data file}
\usage{
processPotteryDat(filelement_names_path, element_start_column = 3)
}
\description{
Reads in a csv file for pottery shard concentration
File should have one row per pottery shard observation
The SampleNo column in the file should contain the
 the shard id and the observation number separated by 
 a "-".
}
