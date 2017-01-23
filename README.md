# parse_agilent
This repository contains a couple of R functions for parsing the .csv output of Agilent’s MassHunter Qualitative software and returning the results as data frame.  

## Types of data

Both exported chromatogram files and exported spectra can be parsed.  This includes extracted ion chromatograms (EICs), total ion chromatograms (TICs), base peak chromatograms (BPCs), extracted wavelength chromatograms (EWCs), total wavelength chromatograms (TWCs), instrument curves, etc.)

## Requirements

1. R version 3.3 (untested on earlier versions)
2. [tidyverse](https://github.com/tidyverse/)
3. [data.table](https://github.com/Rdatatable/data.table)

## Use

```
source(‘<PATH/TO/REPO>/source/parse_agilent.r`)

# on chromatograms
cgrams.df <- parse_agilent_cgram_csv(‘<PATH/TO/REPO>/data/example_cgram_file.csv’)
head(cgrams.df)

# on spectra
spectra.df <- parse_agilent_spectrum_csv()
head(spectra.df)
```
