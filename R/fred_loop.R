#' Function to download a variable from FRED for multiple countries
#'
#' @param prefix character string FRED symbol prefix.
#' @param suffix character string FRED symbol suffix.
#' @param iso2c character vector of ISO two letter country codes.
#' @param var_name character string of the name for the downloaded variable.
#'
#' @example 
#' # Download Central government debt, total (% of GDP) for Ireland and Japan
#' fred_loop(prefix = 'DEBTTL', suffix = 'A188A', iso2c = c('IE', 'JP'), 
#'           var_name = 'pubdebtgdp_cent_fred')
#'
#' @importFrom quantmod getSymbols
#' @importFrom lubridate ymd

fred_loop <- function(prefix, suffix, iso2c, var_name) {

    fred_id <- sprintf('%s%s%s', prefix, iso2c, suffix)

    missing <- NULL
    fred_combined <- NULL
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
        marker$iso2c <- gsub(prefix, '', u)
        marker$iso2c <- gsub(suffix, '', marker$iso2c)

        marker$date <- rownames(marker) %>% ymd

        names(marker) <- c(var_name, 'iso2c', 'date')

        if (is.null(fred_combined)) {
            fred_combined <- marker
        } else
            fred_combined <- rbind(fred_combined, marker)

        # Sleep to avoid being locked out
        Sys.sleep(3)
    }
    row.names(fred_combined) <- NULL
    fred_combined <- fred_combined[, c('iso2c', 'date', var_name)]
    return(fred_combined)
}
