#' clustermq futures
#'
#' A clustermq future is an asynchronous multiprocess
#' future that will be evaluated in a background R session.
#'
#' @inheritParams ClusterMQFuture
#' 
#' @param workers The number of processes to be available for concurrent
#' clustermq futures.
#' 
#' @param \ldots Additional arguments passed to `ClusterMQFuture()`.
#'
#' @return An object of class [ClusterMQFuture].
#'
#' @details
#' clustermq futures rely on the \pkg{clustermq} package, which is supported
#' on all operating systems.
#'
#' @importFrom future availableCores
#' @export
clustermq <- function(expr, envir = parent.frame(), substitute = TRUE,
                     globals = TRUE, label = NULL,
                     workers = getOption("future.clustermq.workers", availableCores()), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores()

  future <- ClusterMQFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            workers = workers,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(clustermq) <- c("clustermq", "multiprocess", "future", "function")




#' @rdname clustermq
#' @export
clustermq_local <- function(expr, envir = parent.frame(), substitute = TRUE,
                            globals = TRUE, label = NULL,
                            workers = 1L, ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores()

  workers <- clustermq::workers(n_jobs = 1L, qsys_id = "local")
  
  future <- ClusterMQFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            workers = workers,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(clustermq_local) <- c("clustermq_local", "clustermq", "multiprocess", "future", "function")



#' @rdname clustermq
#' @export
clustermq_multicore <- function(expr, envir = parent.frame(), substitute = TRUE,
                                globals = TRUE, label = NULL,
                                workers = availableCores(), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores()

  workers <- clustermq::workers(n_jobs = workers, qsys_id = "multicore")
  
  future <- ClusterMQFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            workers = workers,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(clustermq_multicore) <- c("clustermq_multicore", "clustermq", "multiprocess", "future", "function")
