# parse_agilent
This repository contains a couple of R functions for parsing the .csv output of Agilent’s MassHunter Qualitative software and returning the results as data frame.  

## Types of data

Both exported chromatogram files and exported spectra can be parsed.  This includes extracted ion chromatograms (EICs), total ion chromatograms (TICs), base peak chromatograms (BPCs), extracted wavelength chromatograms (EWCs), total wavelength chromatograms (TWCs), instrument curves, etc.)

## Use

```
source(‘<PATH/TO/FILE>/parse_agilent.r`)

# on chromatograms
cgrams.df <- parse_agilent_cgram_csv(‘’)
head(cgrams.df)

# on spectra
spectra.df <- parse_agilent_spectrum_csv()
head(spectra.df)
```
