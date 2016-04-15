#' @noRd

last_element <- function(x, v)
{
    x_position <- match(x, v)
    v_final <- length(v)
    if (x_position == v_final) return(TRUE)
    else return(FALSE)
}