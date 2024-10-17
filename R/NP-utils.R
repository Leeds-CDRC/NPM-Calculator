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

#' Check Column Names function
#'
#' This function checks that all required parameter names or
#' spreadsheet "column" names are present, and provides a
#' warning message to the app user if not
#'
#' @param data_frame a data.frame object, loaded from a csv or Excel
#' @return Prints code snippets to help you rename variables if needed
#' @export
checkColumnNames <- function(data_frame){
    expected_column_names <- c("name", "brand", "product_category",
    "product_type", "food_type", "drink_format","drink_type",
    "nutrition_info", "energy_measurement_kj", "energy_measurement_kcal",
    "sugar_measurement_g", "satfat_measurement_g", "salt_measurement_g",
    "sodium_measurement_mg", "fibre_measurement_nsp", "fibre_measurement_aoac",
    "protein_measurement_g", "fvn_measurement_percent", "weight_g",
    "volume_ml", "volume_water_ml")
    data_names <- names(data_frame)
    missing_column_names <- setdiff(expected_column_names, data_names)
    extra_data_names <- setdiff(data_names, expected_column_names)
    df_title <- deparse(substitute(data_frame))
    warning1 <- "The provided dataframe is missing the following required column names:\n"
    warning2 <- "\n The provided dataframe contains these unmatched columns names:\n"
    if (length(missing_column_names) >=1) {
        stop(paste0(warning1, paste(missing_column_names, collapse=";\n"), warning2, paste(extra_data_names, collapse=";\n")))
    } 
}