#' Function to download a variable from FRED for multiple countries
#'
#' @param prefix character string FRED symbol prefix.
#' @param suffix character string FRED symbol suffix.
#' @param iso2c character vector of ISO two letter country codes.
#' @param var_name character string of the name for the downloaded variable.
#' @param single_symbol a character string of a single FRED symbol to download
#' only one series. Note: do not use with \code{prefix}, \code{suffix},
#' \code{iso2c}. Note, will not return a column with the ISO two letter country
#' code.
#'
#' @examples
#' #' # Download Central government debt, total (% of GDP) for Ireland
#' fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = 'IE',
#'           var_name = 'pubdebtgdp_cent_fred')
#'
#'\dontrun{
#' # Download Central government debt, total (% of GDP) for Ireland and Japan
#' fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = c('IE', 'JP'),
#'           var_name = 'pubdebtgdp_cent_fred')
#' }
#'
#' # Download single series (US Federal Funds Rate)
#' fred_loop(single_symbol = 'FEDFUNDS', var_name = 'us_fed_funds')
#'
#' @importFrom quantmod getSymbols
#' @importFrom lubridate ymd
#'
#' @export

fred_loop <- function(prefix, suffix, iso2c, var_name, single_symbol)
{
    if (!missing(single_symbol)) {
        fred_id <- single_symbol
        if (missing(var_name)) var_name <- fred_id
    }
    else if (missing(single_symbol)) {
        if (any(duplicated(iso2c))) stop('iso2c has duplicates. Please remove.',
                                         call. = FALSE)
        fred_id <- sprintf('%s%s%s', prefix, iso2c, suffix)
    }

    missing <- NULL
    fred_combined <- NULL

    message('Downloading: \n')

    for (u in fred_id){
        message(u)
        marker <- tryCatch(
            data.frame(getSymbols(Symbols = u, src = 'FRED',
                                  auto.assign = FALSE)),
            error = function(e) e
        )
        if (inherits(marker, 'error')) {
            missing <- c(missing, u)
            next
        }

        # Clean up

        marker$date <- ymd(rownames(marker))

        if (missing(single_symbol)) {
            marker$iso2c <- gsub(prefix, '', u)
            marker$iso2c <- gsub(suffix, '', marker$iso2c)
            names(marker) <- c(var_name, 'date', 'iso2c')
        }

        else names(marker) <- c(var_name, 'date')

        if (is.null(fred_combined)) {
            fred_combined <- marker
        } else
            fred_combined <- rbind(fred_combined, marker)

        # Sleep to avoid being locked out
        if (missing(single_symbol)) {
            if (!isTRUE(last_element(u, fred_id))) Sys.sleep(2)
        }
    }

    row.names(fred_combined) <- NULL

    if (missing(single_symbol)) {
        fred_combined <- fred_combined[, c('iso2c', 'date', var_name)]
    }

    else if (!missing(single_symbol)) {
        fred_combined <- fred_combined[, c('date', var_name)]
    }

    return(fred_combined)
}
