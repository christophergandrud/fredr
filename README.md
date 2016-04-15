# fredr

A simple R package for downloading a variable from the
[FRED database](https://research.stlouisfed.org/fred2/) for multiple countries.

[![CRAN Version](http://www.r-pkg.org/badges/version/fredr)](http://cran.r-project.org/package=simPH) [![Build Status](https://travis-ci.org/christophergandrud/fredr.svg?branch=master)](https://travis-ci.org/christophergandrud/fredr)

## Examples

For series that are available across multiple countries, FRED denotes each series with a common ID scheme. This includes a **prefix**, the country's [ISO two letter country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), and a **suffix**. You can find the prefix and suffix on each series' data page on FRED.

For example, this symbol is for Irish central government debt, total (% of GDP): *DEBTTLIEA188A*. It has the prefix `DEBTTL` and suffix `A188A`. Ireland's ISO two letter country code is `IE`.

In the following example we download the central government debt data for Ireland and Japan (whose ISO2C code is `JP`):

```R
# Download Central government debt, total (% of GDP) for Ireland and Japan
fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = c('IE', 'JP'),
          var_name = 'pubdebtgdp_cent_fred')
```

You can also download a single series using the `single_symbol` argument. For example:

```R
# Download single series (US Federal Funds Rate)
fred_loop(single_symbol = 'FEDFUNDS')
```

## Install

The package is not on CRAN so install using:

```R
devtools::github_install('christophergandrud/fredr')
```
