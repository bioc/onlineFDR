# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

addis_sync_faster <- function(pval, gammai, lambda = 0.25, alpha = 0.05, tau = 0.5, w0 = 0.025, display_progress = TRUE) {
    .Call(`_onlineFDR_addis_sync_faster`, pval, gammai, lambda, alpha, tau, w0, display_progress)
}

addis_async_faster <- function(pval, E, gammai, lambda = 0.25, alpha = 0.05, tau = 0.5, w0 = 0.025, display_progress = FALSE) {
    .Call(`_onlineFDR_addis_async_faster`, pval, E, gammai, lambda, alpha, tau, w0, display_progress)
}

addis_spending_faster <- function(pval, gammai = numeric(0), alpha = 0.05, lambda = 0.25, tau = 0.5, display_progress = TRUE) {
    .Call(`_onlineFDR_addis_spending_faster`, pval, gammai, alpha, lambda, tau, display_progress)
}

addis_spending_dep_faster <- function(pval, L, gammai = numeric(0), alpha = 0.05, lambda = 0.25, tau = 0.5, display_progress = TRUE) {
    .Call(`_onlineFDR_addis_spending_dep_faster`, pval, L, gammai, alpha, lambda, tau, display_progress)
}

alphainvesting_faster <- function(pval, gammai = numeric(0), alpha = 0.05, w0 = 0.025, display_progress = TRUE) {
    .Call(`_onlineFDR_alphainvesting_faster`, pval, gammai, alpha, w0, display_progress)
}

lond_faster <- function(pval, betai, alpha = 0.05, original = TRUE, display_progress = TRUE) {
    .Call(`_onlineFDR_lond_faster`, pval, betai, alpha, original, display_progress)
}

londstar_async_faster <- function(pval, E, betai, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_londstar_async_faster`, pval, E, betai, alpha, display_progress)
}

londstar_dep_faster <- function(pval, L, betai, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_londstar_dep_faster`, pval, L, betai, alpha, display_progress)
}

londstar_batch_faster <- function(pval, batch, batchsum, betai, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_londstar_batch_faster`, pval, batch, batchsum, betai, alpha, display_progress)
}

lord_faster <- function(pval, gammai, version, alpha = 0.05, w0 = 0.005, b0 = 0.045, taudiscard = 0.5, display_progress = TRUE) {
    .Call(`_onlineFDR_lord_faster`, pval, gammai, version, alpha, w0, b0, taudiscard, display_progress)
}

lordstar_async_faster <- function(pval, E, gammai, w0 = 0.005, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_lordstar_async_faster`, pval, E, gammai, w0, alpha, display_progress)
}

lordstar_dep_faster <- function(pval, L, gammai, w0 = 0.005, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_lordstar_dep_faster`, pval, L, gammai, w0, alpha, display_progress)
}

lordstar_batch_faster <- function(pval, batch, batchsum, gammai, w0 = 0.005, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_lordstar_batch_faster`, pval, batch, batchsum, gammai, w0, alpha, display_progress)
}

online_fallback_faster <- function(pval, gammai, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_online_fallback_faster`, pval, gammai, alpha, display_progress)
}

saffron_faster <- function(pval, gammai, lambda = 0.5, alpha = 0.05, w0 = 0.025, display_progress = TRUE) {
    .Call(`_onlineFDR_saffron_faster`, pval, gammai, lambda, alpha, w0, display_progress)
}

saffronstar_async_faster <- function(pval, E, gammai, w0 = 0.025, lambda = 0.5, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_saffronstar_async_faster`, pval, E, gammai, w0, lambda, alpha, display_progress)
}

saffronstar_dep_faster <- function(pval, L, gammai, w0 = 0.025, lambda = 0.5, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_saffronstar_dep_faster`, pval, L, gammai, w0, lambda, alpha, display_progress)
}

saffronstar_batch_faster <- function(pval, batch, batchsum, gammai, w0 = 0.025, lambda = 0.5, alpha = 0.05, display_progress = TRUE) {
    .Call(`_onlineFDR_saffronstar_batch_faster`, pval, batch, batchsum, gammai, w0, lambda, alpha, display_progress)
}

