# series of utility functions for calling nutrientprofiler functions
library(nutrientprofiler)

#' Run Nutrient Profiler
#'
#' This function runs the nutrientprofiler pipeline
#' on all values in the passed data.frame.
#'
#' @param dataframe, R data.frame for nutrientprofiler functions
#' @returns an R data.frame with input columns and
#' nutrientprofiler columns added
runNP <- function(dataframe) {
    stopifnot("Expected a data.frame type to be passed" = 
    is.data.frame(dataframe))

    dataframe['sg_adjusted'] <- unlist(row_lapply(dataframe, SGConverter))

    # grateful for help with this function from https://stackoverflow.com/questions/75825126/conditionally-running-a-function-on-a-row-based-on-values-in-another-column-usin/75825163#75825163

    npm_scores <- do.call("rbind", row_lapply(dataframe, NPMScore, sg_adjusted_label="sg_adjusted"))

    dataframe <- cbind(dataframe, npm_scores)

    npm_assess <- do.call("rbind", row_lapply(dataframe, NPMAssess))

    dataframe <- cbind(dataframe, npm_assess)

    return(dataframe)

}

#' Row wise application of lapply
#' 
#' This is a utility function for applying lapply across each row
#' of a data.frame
#'
#' @param data, a data.frame object
#' @param f, a function to be applied rowwise
#' @param ..., any additional arguments for the function
row_lapply <- function(data, f, ...) {
    return(
        lapply(seq_len(nrow(data)), function(i) f(data[i,], ...))
    )
}