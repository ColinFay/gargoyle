test_that("gargoyle init(), trigger() and watch() work", {
  shiny::reactiveConsole(TRUE)

  s <- shiny::MockShinySession$new()

  init("pif", session = s)

  expect_true(
    s$userData$pif() == 0
  )

  # I. Run test for the talkative feature OFF; default option is FALSE
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

  # II. Run test for the talkative feature ON; set option to TRUE
  options("gargoyle.talkative" = TRUE)
  expect_output(
    trigger("pif", session = s),
    regexp = "\\[Gargoyle\\] Triggering pif "
  )
  expect_true(
    s$userData$pif() == 2
  )
  expect_equal(
    watch(
      "pif",
      s
    ),
    2
  )
  options("gargoyle.talkative" = FALSE)
  shiny::reactiveConsole(FALSE)
})
test_that("gargoyle on() works", {
  shiny::reactiveConsole(TRUE)

  s <- shiny::MockShinySession$new()

  init("pif", session = s)

  # I. Run tests for on() without error
  expect_identical(
    class(
      on(
        "pif",
        {
          cat(1 + 1)
        },
        session = s
      )
    ),
    c("Observer.event", "Observer", "R6")
  )
  # II. Run tests for on() with errors - uninitialized events
  # II.A Provoke error due to uninitialized event - missmatch from init
  expect_error(
    on(
      "pif2",
      {
        cat(1 + 1)
      },
      session = s
    )
  )
  # II.B Check error message of uninitialized event - missmatch from init
  out_error <- try(on(
    "pif2",
    {
      cat(1 + 1)
    },
    session = s
  ))
  expect_equal(
    out_error[[1]],
    "Error : [Gargoyle] Flag pif2 hasn't been initiated: can't listen to it.\n"
  )

  # II.C Provoke error due to uninitialized event - missmatch from session arg
  expect_error(
    on(
      "pif",
      {
        cat(1 + 1)
      },
      session = shiny::getDefaultReactiveDomain()
    )
  )
  # II.D Check error message of uninitialized event - missmatch session arg
  out_error <- try(on(
    "pif",
    {
      cat(1 + 1)
    },
    session = shiny::getDefaultReactiveDomain()
  ))
  expect_equal(
    out_error[[1]],
    "Error : [Gargoyle] Flag pif hasn't been initiated: can't listen to it.\n"
  )

  shiny::reactiveConsole(FALSE)
})
