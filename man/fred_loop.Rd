% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fred_loop.R
\name{fred_loop}
\alias{fred_loop}
\title{Function to download a variable from FRED for multiple countries}
\usage{
fred_loop(prefix, suffix, iso2c, var_name, single_symbol)
}
\arguments{
\item{prefix}{character string FRED symbol prefix.}

\item{suffix}{character string FRED symbol suffix.}

\item{iso2c}{character vector of ISO two letter country codes.}

\item{var_name}{character string of the name for the downloaded variable.}

\item{single_symbol}{a character string of a single FRED symbol to download
only one series. Note: do not use with \code{prefix}, \code{suffix},
\code{iso2c}. Note, will not return a column with the ISO two letter country
code.}
}
\description{
Function to download a variable from FRED for multiple countries
}
\examples{
#' # Download Central government debt, total (\% of GDP) for Ireland
fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = 'IE',
          var_name = 'pubdebtgdp_cent_fred')

\dontrun{
# Download Central government debt, total (\% of GDP) for Ireland and Japan
fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = c('IE', 'JP'),
          var_name = 'pubdebtgdp_cent_fred')
}

# Download single series (US Federal Funds Rate)
fred_loop(single_symbol = 'FEDFUNDS', var_name = 'us_fed_funds')

}

