#' Storage object
#'
#' @importFrom R6 R6Class
#' @importFrom qs qsave qread
#' @importFrom fs path_norm dir_create path dir_delete file_delete
#' @export
Storage <- R6::R6Class(
  "Storage",
  public = list(
    path = character(0),
    initialize = function(
    path = "~/.odds"
    ){
      self$path <- path_norm(path)
      dir_create(
        self$path
      )
    },
    set = function(
    value,
    object,
    namespace = "global",
    preset = "high",
    algorithm = "zstd",
    compress_level = 4L,
    shuffle_control = 15L,
    check_hash = TRUE,
    nthreads = 1
    ){
      dir_create(
        path(
          self$path,
          namespace
        )
      )
      qsave(
        x = value,
        file = path(
          self$path,
          namespace,
          object,
          ext = "qs"
        ),
        preset = preset,
        algorithm = algorithm,
        compress_level = compress_level,
        shuffle_control = shuffle_control,
        check_hash = check_hash,
        nthreads = nthreads
      )
    },
    get = function(
    value,
    namespace = "global",
    use_alt_rep = FALSE,
    strict = FALSE,
    nthreads = 1
    ){
      qread(
        file = path(
          self$path,
          namespace,
          value,
          ext = "qs"
        ),
        use_alt_rep = use_alt_rep,
        strict = strict,
        nthreads = nthreads
      )
    },
    rm = function(
    value,
    namespace = "global"
    ){
      file_delete(
        path(
          self$path,
          namespace,
          value,
          ext = "qs"
        )
      )
    },
    remove_namespace = function(
    namespace
    ){
      dir_delete(
        path(
          self$path,
          namespace
        )
      )
    }
  )
)
