#' Calculation for quantile-quantile plot.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2:::rd_aesthetics("stat", "qq")}
#'
#' @param distribution Distribution function to use, if x not specified
#' @param dparams Parameters for distribution function
#' @param ... Other arguments passed to distribution function
#' @param na.rm If \code{FALSE} (the default), removes missing values with
#'    a warning.  If \code{TRUE} silently removes missing values.
#' @inheritParams stat_identity
#' @return a data.frame with additional columns:
#'   \item{sample}{sample quantiles}
#'   \item{theoretical}{theoretical quantiles}
#' @export
#' @examples
#' \donttest{
#' df <- data.frame(y = rt(200, df = 5))
#' p <- ggplot(df, aes(sample = y))
#' p + stat_qq()
#' p + geom_point(stat = "qq")
#'
#' # Use fitdistr from MASS to estimate distribution params
#' library(MASS)
#' params <- as.list(fitdistr(y, "t")$estimate)
#' ggplot(df, aes(sample = y)) +
#'   stat_qq(dist = qt, dparam = params)
#'
#' # Using to explore the distribution of a variable
#' ggplot(mtcars) +
#'   stat_qq(aes(sample = mpg))
#' ggplot(mtcars) +
#'   stat_qq(aes(sample = mpg, colour = factor(cyl)))
#' }
stat_qq <- function (mapping = NULL, data = NULL, geom = "point", position = "identity",
distribution = qnorm, dparams = list(), na.rm = FALSE, ...) {
  StatQq$new(mapping = mapping, data = data, geom = geom, position = position,
  distribution = distribution, dparams = dparams, na.rm = na.rm, ...)
}

StatQq <- proto(Stat, {
  objname <- "qq"

  default_geom <- function(.) GeomPoint
  default_aes <- function(.) aes(y = ..sample.., x = ..theoretical..)
  required_aes <- c("sample")

  calculate <- function(., data, scales, quantiles = NULL, distribution = qnorm, dparams = list(), na.rm = FALSE) {
    data <- remove_missing(data, na.rm, "sample", name = "stat_qq")

    sample <- sort(data$sample)
    n <- length(sample)

    # Compute theoretical quantiles
    if (is.null(quantiles)) {
      quantiles <- ppoints(n)
    } else {
      stopifnot(length(quantiles) == n)
    }

    theoretical <- safe.call(distribution, c(list(p = quantiles), dparams))

    data.frame(sample, theoretical)
  }


})
