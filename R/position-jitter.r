#' Jitter points to avoid overplotting.
#'
#' @family position adjustments
#' @param width degree of jitter in x direction. Defaults to 40\% of the
#'   resolution of the data.
#' @param height degree of jitter in y direction. Defaults to 40\% of the
#'   resolution of the data
#' @export
#' @examples
#' ggplot(mtcars, aes(am, vs)) + geom_point()
#'
#' # Default amount of jittering will generally be too much for
#' # small datasets:
#' ggplot(mtcars, aes(am, vs)) + geom_point(position = "jitter")
#' # Control the amount as follows
#' ggplot(mtcars, aes(am, vs)) +
#'   geom_point(position = position_jitter(w = 0.1, h = 0.1))
#'
#' # The default works better for large datasets, where it will
#' # take up as much space as a boxplot or a bar
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_jitter() +
#'   geom_boxplot()
position_jitter <- function (width = NULL, height = NULL) {
  PositionJitter$new(width = width, height = height)
}

PositionJitter <- proto(Position, {
  objname <- "jitter"

  adjust <- function(., data) {
    if (empty(data)) return(data.frame())
    check_required_aesthetics(c("x", "y"), names(data), "position_jitter")

    if (is.null(.$width)) .$width <- resolution(data$x, zero = FALSE) * 0.4
    if (is.null(.$height)) .$height <- resolution(data$y, zero = FALSE) * 0.4

    trans_x <- NULL
    trans_y <- NULL
    if(.$width > 0) {
      trans_x <- function(x) jitter(x, amount = .$width)
    }
    if(.$height > 0) {
      trans_y <- function(x) jitter(x, amount = .$height)
    }

    transform_position(data, trans_x, trans_y)
  }

})
