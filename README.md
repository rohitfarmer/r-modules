# Collection of R Modules for Various Purposes

The key idea of [`modules`](https://cran.r-project.org/web/packages/modules/vignettes/modulesInR.html) package in R is to provide a unit of source code which has it’s own scope. The main and most reliable infrastructure for such organizational units in the R ecosystem is a package. However, R packages are harder to create and maintain. Modules can be used as stand alone, ad-hoc substitutes for a package or as a sub-unit within a package. By using `modules` we can import functions from an external script in a cleaner way than sourcing an R script.


## Search the local and online NCBI taxonomy database
`taxonomy.R` module has functions to search a local database/table for taxonomy IDs given organism names and then use the taxonomy IDs to search for taxonomy levels. Or to search online NCBI taxonomy databases for a list of organisim names. 

The local databases files/tables are available at [https://zenodo.org/records/10672196](https://zenodo.org/records/10672196) as `feather` files. 

For the online search, the function uses [`taxize`](https://cran.r-project.org/package=taxize) package which will require [NCBI's E-utilities API key](https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/) in your R environment.

Check out: 
  - [https://books.ropensci.org/taxize/authentication.html](https://books.ropensci.org/taxize/authentication.html)
  - [https://books.ropensci.org/taxize/](https://books.ropensci.org/taxize/)


```R
library(modules)

# Load the module and create an object
mtax <- modules::use(file.path("r-modules", "taxonomy.R"))

# Carry out local database search
tax_dat <- mtax$names_to_tax_local(orgnames, names_db = namesdb, rankedlineage_db = rankedlineage, verbose = TRUE)

# Carry out online database search
tax_dat <- names_to_tax_online(orgnames, verbose = FALSE)
```

## Parse BLASTp output from a text file with default format i.e. -outfmt 0

```R
library(modules)

# Load the module and create an object
blastp <- modules::use(file.path("r-modules", "parse-blast-output.R"))

# Parse the output by passing a text file as the function argument
blast_dat <- blatp$parse_blast_fmt_0(blast_output_file)
```
