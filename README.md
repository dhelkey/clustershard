# clustershard

This package provides a GUI tool to analyze elemental compositional pottery data.
    The tool simplifies the process of importing data, performing dimensionality reduction (through Principle Component Analysis), and clustering the observations (using k-means or Gaussian mixture modeling).


	
## Overview
*clustershard* provides a GUI tool (*clusterTool*) for performing analysis on pottery shard data. Data is first imported from a CSV file and then the tool allows for different transformations. A clustering method (Gaussian Mixture Models or K-means) is then applied to a principle components decomposition of the transformed data. Finally, the tool provides methods for analyzing the results and exporting the resulting plots and data.


	
	
## Getting Started
*clustershard* must first be loaded into R (requires the *devtools* package be installed) using:


```
devtools::install_github('dhelkey/dgrank', force = TRUE)
library('dgrank')
```
The GUI tool for clustering and analysis can then be run with:



```
clusterTool()
```



### Data
*clusterTool* assumes data is stored on a CSV file with one row for every measurement taken (there can be multiple rows for each specimen if it is measured multiple times).

The first row of the CSV should be a header row, with a SampleNo column, and columns with element names. The element names should start at column 3 (TODO can be set when running clusterTool). Element names can include numbers (for example the atomic mass of the element). Element names are compared with the periodic table and any unrecognized element names will throw an error. All columns to the right of the starting element column will be parsed as elements. Therefore, any superfluous columns need to be at the start of the CSV file, before the element starting column.

Identifying information about each measurement should be stored in a SampleNo column. This column should consist of text strings. The first element in the string should be an entry of the form "shardID-measurmentNum". Here, shardID is a unique identifier for each shard (e.g. D0506) and measurmentNum is an identifier for each measurement of the shard (e.g. 1a, 1b, 2a). Any extraneous information following this first dash separated value (e.g. a timestamp) is ignored by this package.


Example data

DataFile	| SampleNo |	7Li |	9Be |	23Na |	24Mg |	27Al |	29Si |	31P |	33S |	39K
---| ---| ---| ---| ---| ---| ---| ---| ---| ---| ---| 
160824-A	|D0506-1a    8/24/2016 1:28:10 PM	|0.007235833	| 0.000278074	| 0.344942658 |	0.638880939 |	10.12715041	 |43.54705309	 | 0.12743092 |	0.087898704	| 1.069493988 
160824-A	| D0506-1b    8/24/2016 1:30:26 PM	| 0.008610675	| 0.00052367 |	0.430605991	| 0.608618339	| 10.88459596	| 41.68874081	| 0.11672563	| 0.23707953	| 1.054835438



###Usage

Guide to the GUI of clustertool

![clustertool GUI](https://github.com/dhelkey/clustershard/blob/master/inst/figures/ui_numbered.PNG)

clusterTool components:

1. Import data from a CSV file (see above for format requirements).

2. Desired number of clusters.

3. Number of principle components on which the clustering is based.

4. Clustering method (Gaussian Mixture Models or K-means).

5. If TRUE, multiple observations of the same shard are combined into one reading by averaging element concentrations.

6. Data standardization. If TRUE, element concentration values are normalized to have mean 0 and standard deviation 1.

7. Data transformation. Options are 'None' for no transformation, 'Log' to take the natural log of each measurement, or 'LRA' which uses a Log-Ratio Analysis transformation (see [Baxter & Freestone (2006)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1475-4754.2006.00270.x) for details). This setting changes the data used to perform, and different settings will change the clustering results.

8. Visualization Transformation. Options are the same as above ('None', 'Log', 'LRA'). This transformation does NOT affect clustering results, but does affect the scale on which analysis plots are displayed.

9. Visualization data standardization. If true, element concentration values for plots are normalized to have mean 0 and standard deviation 1. This will not affect clustering results.

10. Allows user to export data along with clustering results.

11. Tabs for viewing the 5 different plots that *clusterTool* provides.

12. Drop down menu for selecting elements of interest.

13. Each plot provides a button to export the image to file.

## Author

* **Daniel Helkey** 

All contributors listed in the package [DESCRIPTION](DESCRIPTION).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Judith Mauche proposed and funded the project, through [TODO agency or grant].

* David Draper set up the collaboration and provided statistical consulting for the clustering tool.

* R package constructed with extensive referral to to [R Packages by Hadley Wickham](http://r-pkgs.had.co.nz/intro.html)

* Readme.md file from [template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
