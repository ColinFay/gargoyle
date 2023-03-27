test_that("gargoyle works", {
  shiny::reactiveConsole(TRUE)

  s <- shiny::MockShinySession$new()

  init("pif", session = s)

  expect_true(
    s$userData$pif() == 0
  )

  trigger("pif", session = s)

  expect_true(
    s$userData$pif() == 1
  )

  expect_equal(
    watch(
      "pif",
      s
    ),
    1
  )

  shiny::reactiveConsole(FALSE)
})
