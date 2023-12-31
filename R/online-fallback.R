#' Online fallback procedure for FWER control
#'
#' Implements the online fallback procedure of Tian and Ramdas (2021), which
#' guarantees strong FWER control under arbitrary dependence of the p-values.
#'
#' The function takes as its input either a vector of p-values or a dataframe
#' with three columns: an identifier (`id'), date (`date') and p-value (`pval').
#' The case where p-values arrive in batches corresponds to multiple instances
#' of the same date. If no column of dates is provided, then the p-values are
#' treated as being ordered in sequence, arriving one at a time. Given an overall
#' significance level \eqn{\alpha}, we choose a sequence of non-negative
#' non-increasing numbers \eqn{\gamma_i} that sum to 1.
#' 
#' The online fallback procedure provides a uniformly more powerful method than
#' Alpha-spending, by saving the significance level of a previous rejection.
#' More specifically, the procedure tests hypothesis \eqn{H_i} at level
#' \deqn{\alpha_i = \alpha \gamma_i + R_{i-1} \alpha_{i-1}} where \eqn{R_i =
#' 1\{p_i \leq \alpha_i\}} denotes a rejected hypothesis.
#'
#' Further details of the online fallback procedure can be found in Tian and
#' Ramdas (2021).
#'
#'
#' @param d Either a vector of p-values, or a dataframe with three columns: an
#'   identifier (`id'), date (`date') and p-value (`pval'). If no column of
#'   dates is provided, then the p-values are treated as being ordered
#'   in sequence, arriving one at a time.
#'
#' @param alpha Overall significance level of the FDR procedure, the default is
#'   0.05.
#'
#' @param gammai Optional vector of \eqn{\gamma_i}. A default is provided as
#' proposed by Javanmard and Montanari (2018), equation 31.
#'
#' @param random Logical. If \code{TRUE} (the default), then the order of the
#'   p-values in each batch (i.e. those that have exactly the same date) is
#'   randomised.
#'
#' @param display_progress Logical. If \code{TRUE} prints out a progress bar for
#'  the algorithm runtime. 
#'
#' @param date.format Optional string giving the format that is used for dates.
#'
#'
#' @return \item{out}{ A dataframe with the original data \code{d} (which will
#'   be reordered if there are batches and \code{random = TRUE}), the
#'   LORD-adjusted significance thresholds \eqn{\alpha_i} and the indicator
#'   function of discoveries \code{R}. Hypothesis \eqn{i} is rejected if the
#'   \eqn{i}-th p-value is less than or equal to \eqn{\alpha_i}, in which case
#'   \code{R[i] = 1}  (otherwise \code{R[i] = 0}).}
#'
#'
#' @references Tian, J. and Ramdas, A. (2021). Online control of the familywise
#' error rate. \emph{Statistical Methods for Medical Research}, 30(4):976–993.
#'
#'
#' @examples
#' sample.df <- data.frame(
#' id = c('A15432', 'B90969', 'C18705', 'B49731', 'E99902',
#'     'C38292', 'A30619', 'D46627', 'E29198', 'A41418',
#'     'D51456', 'C88669', 'E03673', 'A63155', 'B66033'),
#' date = as.Date(c(rep('2014-12-01',3),
#'                rep('2015-09-21',5),
#'                 rep('2016-05-19',2),
#'                 '2016-11-12',
#'                rep('2017-03-27',4))),
#' pval = c(2.90e-08, 0.06743, 0.01514, 0.08174, 0.00171,
#'         3.60e-05, 0.79149, 0.27201, 0.28295, 7.59e-08,
#'         0.69274, 0.30443, 0.00136, 0.72342, 0.54757))
#'
#' online_fallback(sample.df, random=FALSE)
#' 
#' set.seed(1); online_fallback(sample.df)
#' 
#' set.seed(1); online_fallback(sample.df, alpha=0.1)
#' 
#' @export

online_fallback <- function(d, alpha = 0.05, gammai, random = TRUE, display_progress = FALSE, date.format = "%Y-%m-%d") {
    
    d <- checkPval(d)
    
    if (is.data.frame(d)) {
        d <- checkdf(d, random, date.format)
        pval <- d$pval
    } else if (is.vector(d)) {
        pval <- d
    } else {
        stop("d must either be a dataframe or a vector of p-values.")
    }
    
    N <- length(pval)
    
    if (alpha <= 0 || alpha > 1) {
        stop("alpha must be between 0 and 1.")
    }
    
    if (missing(gammai)) {
        gammai <- 0.07720838 * log(pmax(seq_len(N), 2))/((seq_len(N)) * exp(sqrt(log(seq_len(N)))))
    } else if (any(gammai < 0)) {
        stop("All elements of gammai must be non-negative.")
    } else if (sum(gammai) > 1) {
        stop("The sum of the elements of gammai must not be greater than 1.")
    }
    
    ### Start algorithm
    out <- online_fallback_faster(pval, 
                                  gammai,
                                  alpha = alpha,
                                  display_progress = display_progress)
    out$R <- as.numeric(out$R)
    out
}
