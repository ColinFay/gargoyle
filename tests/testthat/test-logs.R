test_that("get_gargoyle_logs() works", {
  clear_gargoyle_logs()
  expect_equal(
    nrow(get_gargoyle_logs()),
    0
  )
  expect_equal(
    names(get_gargoyle_logs()),
    c("what", "time")
  )
  .logs$log <- rbind(
    .logs$log,
    data.frame(
      what = c("this"),
      time = as.character(Sys.time()),
      stringsAsFactors = FALSE
    )
  )
  expect_equal(
    nrow(get_gargoyle_logs()),
    1
  )
  expect_equal(
    names(get_gargoyle_logs()),
    c("what", "time")
  )
})
