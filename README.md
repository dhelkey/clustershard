# clustershard

This package provides a GUI tool to analyze elemental compositional pottery data.
    The tool simplifies the process of importing data, performing dimensionality reduction (through Principle Component Analysis), and clustering the observations (using k-means or Gaussian mixture modeling).


## Getting Started
clustershard must first be loaded into R (requires the *devtools* package) using:


```
devtools::install_github('dhelkey/dgrank', force = TRUE)
library('dgrank')
```
The GUI tool for clustering and analysis can then be run with:



```
clusterTool()
```


### Data
clustershard assumes data is stored on a CSV file with one row for every measurement taken (there can be multiple rows for each specimen if it is measured multiple times).

The first row of the CSV should be a header row, with a SampleNo column, and columns with element names. The element names should start at column 3 (TODO can be set when running clusterTool). Element names can include numbers (for example the atomic mass of the element). Element names are compared with the periodic table and any unrecognized element names will throw an error. All columns to the right of the starting element column will be parsed as elements. Therefore, any superfluous columns need to be at the start of the CSV file, before the element starting column.

Identifying information about each measurement should be stored in a SampleNo column. This column should consist of text strings. The first element in the string should be an entry of the form "shardID-measurmentNum". Here, shardID is a unique identifier for each shard (e.g. D0506) and measurmentNum is an identifier for each measurement of the shard (e.g. 1a, 1b, 2a). Any extraneous information following this first dash separated value (e.g. a timestamp) is ignored by this package.


Example data

DataFile	| SampleNo |	7Li |	9Be |	23Na |	24Mg |	27Al |	29Si |	31P |	33S |	39K
---| ---| ---| ---| ---| ---| ---| ---| ---| ---| ---| 
160824-A	|D0506-1a    8/24/2016 1:28:10 PM	|0.007235833	| 0.000278074	| 0.344942658 |	0.638880939 |	10.12715041	 |43.54705309	 | 0.12743092 |	0.087898704	| 1.069493988 
160824-A	| D0506-1b    8/24/2016 1:30:26 PM	| 0.008610675	| 0.00052367 |	0.430605991	| 0.608618339	| 10.88459596	| 41.68874081	| 0.11672563	| 0.23707953	| 1.054835438



###Usage

Guide to the GUI of clustertool

![clustertool GUI](https://github.com/dhelkey/clustershard/blob/master/inst/figures/ui.PNG)




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
