% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/online-fallback.R
\name{online_fallback}
\alias{online_fallback}
\title{Online fallback procedure for FWER control}
\usage{
online_fallback(
  d,
  alpha = 0.05,
  gammai,
  random = TRUE,
  display_progress = FALSE,
  date.format = "\%Y-\%m-\%d"
)
}
\arguments{
\item{d}{Either a vector of p-values, or a dataframe with three columns: an
identifier (`id'), date (`date') and p-value (`pval'). If no column of
dates is provided, then the p-values are treated as being ordered
in sequence, arriving one at a time.}

\item{alpha}{Overall significance level of the FDR procedure, the default is
0.05.}

\item{gammai}{Optional vector of \eqn{\gamma_i}. A default is provided as
proposed by Javanmard and Montanari (2018), equation 31.}

\item{random}{Logical. If \code{TRUE} (the default), then the order of the
p-values in each batch (i.e. those that have exactly the same date) is
randomised.}

\item{display_progress}{Logical. If \code{TRUE} prints out a progress bar for
the algorithm runtime.}

\item{date.format}{Optional string giving the format that is used for dates.}
}
\value{
\item{out}{ A dataframe with the original data \code{d} (which will
  be reordered if there are batches and \code{random = TRUE}), the
  LORD-adjusted significance thresholds \eqn{\alpha_i} and the indicator
  function of discoveries \code{R}. Hypothesis \eqn{i} is rejected if the
  \eqn{i}-th p-value is less than or equal to \eqn{\alpha_i}, in which case
  \code{R[i] = 1}  (otherwise \code{R[i] = 0}).}
}
\description{
Implements the online fallback procedure of Tian and Ramdas (2021), which
guarantees strong FWER control under arbitrary dependence of the p-values.
}
\details{
The function takes as its input either a vector of p-values or a dataframe
with three columns: an identifier (`id'), date (`date') and p-value (`pval').
The case where p-values arrive in batches corresponds to multiple instances
of the same date. If no column of dates is provided, then the p-values are
treated as being ordered in sequence, arriving one at a time. Given an overall
significance level \eqn{\alpha}, we choose a sequence of non-negative
non-increasing numbers \eqn{\gamma_i} that sum to 1.

The online fallback procedure provides a uniformly more powerful method than
Alpha-spending, by saving the significance level of a previous rejection.
More specifically, the procedure tests hypothesis \eqn{H_i} at level
\deqn{\alpha_i = \alpha \gamma_i + R_{i-1} \alpha_{i-1}} where \eqn{R_i =
1\{p_i \leq \alpha_i\}} denotes a rejected hypothesis.

Further details of the online fallback procedure can be found in Tian and
Ramdas (2021).
}
\examples{
sample.df <- data.frame(
id = c('A15432', 'B90969', 'C18705', 'B49731', 'E99902',
    'C38292', 'A30619', 'D46627', 'E29198', 'A41418',
    'D51456', 'C88669', 'E03673', 'A63155', 'B66033'),
date = as.Date(c(rep('2014-12-01',3),
               rep('2015-09-21',5),
                rep('2016-05-19',2),
                '2016-11-12',
               rep('2017-03-27',4))),
pval = c(2.90e-08, 0.06743, 0.01514, 0.08174, 0.00171,
        3.60e-05, 0.79149, 0.27201, 0.28295, 7.59e-08,
        0.69274, 0.30443, 0.00136, 0.72342, 0.54757))

online_fallback(sample.df, random=FALSE)

set.seed(1); online_fallback(sample.df)

set.seed(1); online_fallback(sample.df, alpha=0.1)

}
\references{
Tian, J. and Ramdas, A. (2021). Online control of the familywise
error rate. \emph{Statistical Methods for Medical Research}, 30(4):976–993.
}
