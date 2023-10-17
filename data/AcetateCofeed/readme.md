# Itaconic acid production by co-feeding of Ustilago maydis: a combined approach of experimental data, design of experiments and metabolic modeling

## Description 

This is the source code for the paper "Itaconic acid production by co-feeding of Ustilago maydis: a combined approach of experimental data, design of experiments and metabolic modeling" by A. L. Ziegler*, L. Ullmann*, M. Boßmann, K. L. Stein, U. W. Liebal, A. Mitsos, and L. M. Blank (2023), which was submitted to  [Biotechnology and Bioengineering](https://onlinelibrary.wiley.com/journal/10970290).\
*equally contributing authors \
The the preprint of the paper is available under https://doi.org/10.1101/2023.10.13.562154 .

## Data and usage

### Data

This repository contains the following files:

* Flux balance analysis (FBA) [1] computations of growth rate over glucose and acetate flux: `Growth rate over glucose and acetate flux.ipynb`
* FBA computations of growth rate over relative carbon uptake: `Growth rate over the relative acetate carbon uptake.ipynb`
* FBA computations of itaconic acid flux over relative carbon uptake `Itaconic acid flux over the realive acetate carbon uptake.ipynb`
* FBA computations of the itaconic acid yield over different uptake rates of glucose and acetate `Itaconic acid yield over glucose and acetate flux.ipynb`
* FBA computations with embedded knockouts suggested from OptKnock [2]`iUma22_testing_knockouts.ipynb`

### Usage

For **running** the metabolic network adaptations or the FBA computations, please install the required environment (see below) and then execute the files.


References:
* [1]: A. Varma and B. O. Palsson. Stoichiometric flux balance models quantitatively predict growth and metabolic by-product secretion in wild-type Escherichia coli W3110. Applied and Environmental Microbiology, 60(10):3724-3731, 1994. doi: 10.1128/aem.60.10.3724-3731.1994.
* [2]: A. P. Burgard, P. Pharkya, and C. D. Maranas. OptKnock: a bilevel programming framework for identifying gene knockout strategies for microbial strain optimization. Biotechnology and Bioengineering, 84 (6): 647-657, 2003, doi:  10.1002/bit.10803.


## Required packages

The code is built upon: 

* **[COBRA package](http://opencobra.sourceforge.net/)**
* **[cmcrameri package](https://www.fabiocrameri.ch/colourmaps/)**
* **[matplotlib package](htttps://www.matplotlib.org/)**


which need to be installed before using our code.

## How to cite this work

Please cite our paper if you use this code:

This paper:

```
@misc{Ziegler2023,
 author = {Ziegler, Anita L. and Ullmann, Lena and Boßmann, Manuel and Stein, Karla L. and Liebal, Ulf W. and Mitsos, Alexander and Blank, Lars M.},
 title = {Itaconic acid production by co-feeding of Ustilago maydis: a combined approach of experimental data, design of experiments and metabolic modeling},
 journal = {Biotechnology and Bioengineering}
 year = {2023},
 status = {submitted}
}
```

Please also refer to the corresponding packages, that we use, if appropriate:

COBRA package 

```
@Article{Ebrahim.2013,
 author = {Ebrahim, Ali and Lerman, Joshua A. and Palsson, Bernhard O. and Hyduke, Daniel R.},
 year = {2013},
 title = {COBRApy: COnstraints-Based Reconstruction and Analysis for Python},
 pages = {74},
 volume = {7},
 journal = {BMC systems biology},
 doi = {10.1186/1752-0509-7-74}
}
```


cmcrameri package

```
@article{Kaspar.2022,
 author = {Kaspar, Felix and Crameri, Fabio},
 year = {2022},
 title = {Coloring Chemistry-How Mindful Color Choices Improve Chemical Communication},
 pages = {e202114910},
 volume = {61},
 number = {16},
 journal = {Angewandte Chemie (International ed. in English)},
 doi = {10.1002/anie.202114910}
}



```

Matplotlib package:

```
@Article{Hunter:2007,
  Author    = {Hunter, J. D.},
  Title     = {Matplotlib: A 2D graphics environment},
  Journal   = {Computing in Science \& Engineering},
  Volume    = {9},
  Number    = {3},
  Pages     = {90--95},
  abstract  = {Matplotlib is a 2D graphics package used for Python for
  application development, interactive scripting, and publication-quality
  image generation across user interfaces and operating systems.},
  publisher = {IEEE COMPUTER SOC},
  doi       = {10.1109/MCSE.2007.55},
  year      = 2007
}
```

