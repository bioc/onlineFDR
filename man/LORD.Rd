% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LORD.R
\name{LORD}
\alias{LORD}
\title{LORD: Online FDR control based on recent discovery}
\usage{
LORD(
  d,
  alpha = 0.05,
  gammai,
  version = "++",
  w0,
  b0,
  tau.discard = 0.5,
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
proposed by Javanmard and Montanari (2018), equation 31 for all versions of
LORD except 'dep'. The latter is provided a default to satisfy a condition
given in Javanmard and Montanari (2018), example 3.8.}

\item{version}{Takes values '++', 3, 'discard', or 'dep'. This specifies the
version of LORD to use, and defaults to '++'.}

\item{w0}{Initial `wealth' of the procedure, defaults to \eqn{\alpha/10}.}

\item{b0}{The 'payout' for rejecting a hypothesis in all versions of LORD
except for '++'. Defaults to \eqn{\alpha - w_0}.}

\item{tau.discard}{Optional threshold for hypotheses to be selected for
testing. Must be between 0 and 1, defaults to 0.5. This is required if
\code{version='discard'}.}

\item{random}{Logical. If \code{TRUE} (the default), then the order of the
p-values in each batch (i.e. those that have exactly the same date) is
randomised.}

\item{display_progress}{Logical. If \code{TRUE} prints out a progress bar for the algorithm runtime.}

\item{date.format}{Optional string giving the format that is used for dates.}
}
\value{
\item{d.out}{ A dataframe with the original data \code{d} (which
  will be reordered if there are batches and \code{random = TRUE}), the
  LORD-adjusted significance thresholds \eqn{\alpha_i} and the indicator
  function of discoveries \code{R}. Hypothesis \eqn{i} is rejected if the
  \eqn{i}-th p-value is less than or equal to \eqn{\alpha_i}, in which case
  \code{R[i] = 1}  (otherwise \code{R[i] = 0}).}
}
\description{
Implements the LORD procedure for online FDR control, where LORD stands for
(significance) Levels based On Recent Discovery, as presented by Javanmard
and Montanari (2018) and Ramdas et al. (2017).
}
\details{
The function takes as its input either a vector of p-values or a dataframe
with three columns: an identifier (`id'), date (`date') and p-value (`pval').
The case where p-values arrive in batches corresponds to multiple instances
of the same date. If no column of dates is provided, then the p-values are
treated as being ordered in sequence, arriving one at a time..

The LORD procedure provably controls FDR for independent p-values (see below
for dependent p-values). Given an overall significance level \eqn{\alpha}, we
choose a sequence of non-negative non-increasing numbers \eqn{\gamma_i} that
sum to 1.

Javanmard and Montanari (2018) presented versions of LORD which differ in the
way the adjusted significance thresholds \eqn{\alpha_i} are calculated. The
significance thresholds for LORD 2 are based on all previous discovery times.
LORD 2 has been superseded by the algorithm given in Ramdas et al. (2017),
LORD++ (\code{version='++'}), which is the default version. The significance
thresholds for LORD 3 (\code{version=3}) are based on the time of the last
discovery as well as the 'wealth' accumulated at that time. Finally, Tian and
Ramdas (2019) presented a version of LORD (\code{version='discard'}) that can
improve the power of the procedure in the presence of conservative nulls by
adaptively `discarding' these p-values.

LORD depends on constants \eqn{w_0} and (for versions 3 and 'dep') \eqn{b_0},
where \eqn{0 \le w_0 \le \alpha} represents the initial `wealth' of the
procedure and \eqn{b_0 > 0} represents the `payout' for rejecting a
hypothesis. We require \eqn{w_0+b_0 \le \alpha} for FDR control to hold.
Version 'discard' also depends on a constant \eqn{\tau}, where \eqn{\tau \in
(0,1)} represents the threshold for a hypothesis to be selected for testing:
p-values greater than \eqn{\tau} are implicitly `discarded' by the procedure.

Note that FDR control also holds for the LORD procedure if only the p-values
corresponding to true nulls are mutually independent, and independent from
the non-null p-values.

For dependent p-values, a modified LORD procedure was proposed in Javanmard
and Montanari (2018), which is called be setting \code{version='dep'}. Given
an overall significance level \eqn{\alpha}, we choose a sequence of
non-negative numbers \eqn{\xi_i} such that they satisfy a condition given in
Javanmard and Montanari (2018), example 3.8.

Further details of the LORD procedures can be found in Javanmard and
Montanari (2018), Ramdas et al. (2017) and Tian and Ramdas (2019).
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

LORD(sample.df, random=FALSE)

set.seed(1); LORD(sample.df, version='dep')

set.seed(1); LORD(sample.df, version='discard')

set.seed(1); LORD(sample.df, alpha=0.1, w0=0.05)


}
\references{
Javanmard, A. and Montanari, A. (2018) Online Rules for Control
of False Discovery Rate and False Discovery Exceedance. \emph{Annals of
Statistics}, 46(2):526-554.

Ramdas, A., Yang, F., Wainwright M.J. and Jordan, M.I. (2017). Online control
of the false discovery rate with decaying memory. \emph{Advances in Neural
Information Processing Systems 30}, 5650-5659.

Tian, J. and Ramdas, A. (2019). ADDIS: an adaptive discarding algorithm for
online FDR control with conservative nulls.
\emph{Advances in Neural Information Processing Systems}, 9388-9396.
}
\seealso{
\code{\link{LORDstar}} presents versions of LORD for \emph{asynchronous}
testing, i.e. where each hypothesis test can itself be a sequential process
and the tests can overlap in time.
}
