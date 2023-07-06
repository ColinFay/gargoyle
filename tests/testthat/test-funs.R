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
test_that("gargoyle on() works for name vector", {
  shiny::reactiveConsole(TRUE)

  s <- shiny::MockShinySession$new()

  init("pif_01", "pif_02", "pif_03", session = s)

  # 0. Define on() for 'name' vector
  # 0.A for pif_01 and pif_02
  on(
    c("pif_01", "pif_02"),
    {
      cat("Event on-Type 1: triggered by pif_{01,02}!\n")
    },
    session = s
  )
  expect_true(
    s$userData$pif_01() == 0
  )
  expect_true(
    s$userData$pif_02() == 0
  )
  # 0.B for pif_02 and pif_03
  on(
    c("pif_02", "pif_03"),
    {
      cat("Event on-Type 2: triggered by pif_{02,03}!\n")
    },
    session = s
  )
  expect_true(
    s$userData$pif_02() == 0
  )
  expect_true(
    s$userData$pif_03() == 0
  )
  # I. Test single trigger
  trigger("pif_01", session = s)
  trigger("pif_03", session = s)
  expect_true(
    s$userData$pif_01() == 1
  )
  expect_true(
    s$userData$pif_02() == 0
  )
  expect_true(
    s$userData$pif_03() == 1
  )

  # II. Test double trigger
  trigger("pif_02", session = s)
  trigger("pif_01", "pif_03", session = s)
  expect_true(
    s$userData$pif_01() == 2
  )
  expect_true(
    s$userData$pif_02() == 1
  )
  expect_true(
    s$userData$pif_03() == 2
  )

  # II. Run tests for on() with errors - uninitialized events
  # II.A Provoke error due to uninitialized event(s) - mismatch from init(s)
  # first event exists - second does not
  expect_error(
    on(
      c("pif_01", "pif_2"),
      {
        cat(1 + 1)
      },
      session = s
    )
  )
  # first does not exits - second event exists
  expect_error(
    on(
      c("pif_1", "pif_02"),
      {
        cat(1 + 1)
      },
      session = s
    )
  )
  # both events do not exists
  expect_error(
    on(
      c("pif_1", "pif_2"),
      {
        cat(1 + 1)
      },
      session = s
    )
  )
  # II.B Check error message of uninitialized event(s) - mismatch from init(s)
  # single mismatch for second event
  out_error <- try(
    on(
      c("pif_01", "pif_2"),
      {
        cat(1 + 1)
      },
      session = s
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    "Error : [Gargoyle] Flag pif_2 hasn't been initiated: can't listen to it.\n\n"
  )
  # single mismatch for first event
  out_error <- try(
    on(
      c("pif_1", "pif_02"),
      {
        cat(1 + 1)
      },
      session = s
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    "Error : [Gargoyle] Flag pif_1 hasn't been initiated: can't listen to it.\n\n"
  )
  # double mismatch for first event
  out_error <- try(
    on(
      c("pif_1", "pif_2"),
      {
        cat(1 + 1)
      },
      session = s
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    paste0(
      "Error : [Gargoyle] Flag pif_1 hasn't been initiated: can't listen to it.",
      "\n[Gargoyle] Flag pif_2 hasn't been initiated: can't listen to it.\n\n"
    )
  )

  # II.C Provoke error due to uninitialized event - mismatch from session arg
  # both events exist but the session is wrong -> throws error
  expect_error(
    on(
      c("pif_01", "pif_02"),
      {
        cat(1 + 1)
      },
      session = getDefaultReactiveDomain()
    )
  )
  # both events exist but the session is wrong -> throws correct error message
  # a double mismatch error message as the session is wrong
  out_error <- try(
    on(
      c("pif_01", "pif_02"),
      {
        cat(1 + 1)
      },
      session = getDefaultReactiveDomain()
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    paste0(
      "Error : [Gargoyle] Flag pif_01 hasn't been initiated: can't listen to it.",
      "\n[Gargoyle] Flag pif_02 hasn't been initiated: can't listen to it.\n\n"
    )
  )
  # a double mismatch error message as the session is wrong
  out_error <- try(
    on(
      c("pif_1", "pif_02"),
      {
        cat(1 + 1)
      },
      session = getDefaultReactiveDomain()
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    paste0(
      "Error : [Gargoyle] Flag pif_1 hasn't been initiated: can't listen to it.",
      "\n[Gargoyle] Flag pif_02 hasn't been initiated: can't listen to it.\n\n"
    )
  )
  # a double mismatch error message as the session is wrong
  out_error <- try(
    on(
      c("pif_01", "pif_2"),
      {
        cat(1 + 1)
      },
      session = getDefaultReactiveDomain()
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    paste0(
      "Error : [Gargoyle] Flag pif_01 hasn't been initiated: can't listen to it.",
      "\n[Gargoyle] Flag pif_2 hasn't been initiated: can't listen to it.\n\n"
    )
  )
  # a double mismatch error message as the session is wrong
  out_error <- try(
    on(
      c("pif_1", "pif_2"),
      {
        cat(1 + 1)
      },
      session = getDefaultReactiveDomain()
    ),
    silent = TRUE
  )
  expect_equal(
    out_error[[1]],
    paste0(
      "Error : [Gargoyle] Flag pif_1 hasn't been initiated: can't listen to it.",
      "\n[Gargoyle] Flag pif_2 hasn't been initiated: can't listen to it.\n\n"
    )
  )

  # III. Test classes for double on()
  expect_identical(
    class(
      on(
        c("pif_01", "pif_02"),
        {
          cat(1 + 1)
        },
        session = s
      )
    ),
    c("Observer.event", "Observer", "R6")
  )
  shiny::reactiveConsole(FALSE)
})
