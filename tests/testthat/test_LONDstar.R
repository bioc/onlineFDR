test.pval <- c(1e-07, 3e-04, 0.1, 5e-04)
test.df <- data.frame(id = seq_len(4), pval = test.pval)

test_that("Correct rejections for version async", {
    expect_identical(LONDstar(test.pval, version='async',
                              decision.times = seq_len(4))$R,
                     c(1,1,0,1))
    
    expect_identical(LONDstar(test.pval, version='async',
                              decision.times = rep(4,4))$R,
                     c(1,1,0,0))
})

test_that("Correct rejections for version dep", {
    expect_identical(LONDstar(test.pval, version='dep',
                              lags = rep(0,4))$R,
                     c(1,1,0,1))
    
    expect_identical(LONDstar(test.pval, version='dep',
                              lags = rep(4,4))$R,
                     c(1,1,0,0))
})


test_that("Correct rejections for version batch", {
    expect_identical(LONDstar(test.pval, version='batch',
                              batch.sizes = rep(1,4))$R,
                     c(1,1,0,1))
    
    expect_identical(LONDstar(test.pval, version='batch',
                              batch.sizes = 4)$R,
                     c(1,1,0,0))
})


test_that("Check that LOND is a special case of the LONDstar
          algorithms", {
    expect_equal(LOND(test.df, original=FALSE)$alphai,
                 LONDstar(test.pval, version='async',
                          decision.times = seq_len(4))$alphai)
              
    expect_equal(LOND(test.df, original=FALSE)$alphai,
                 LONDstar(test.pval, version='dep',
                          lags = rep(0,4))$alphai)
              
    expect_equal(LOND(test.df, original=FALSE)$alphai,
                 LONDstar(test.pval, version='batch',
                          batch.sizes = rep(1,4))$alphai)              
})