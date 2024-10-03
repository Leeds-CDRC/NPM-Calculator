library(shiny)
library(readxl)

#' Load data function
#' 
#' This function accepts a shiny InputFile list
#' it extracts the file extension using the `extract_ext`
#' utility function from the $datapath value and 
#' then tries to load the data using either read.csv or readxl
#' it returns the dataframe otherwise catches an error.
#' It does so safely to help pass this up to the Shiny app
#' @param file, a Shiny InputFile list
#' @returns a dataframe
load_and_render <- function(file) {

            # retrieve file extension
            file_ext <- extract_ext(file$datapath, -1)

            tryCatch(
            {
                if (file_ext == "csv") {

                    df <- read.csv(file$datapath)

                } else if (file_ext == "xlsx") {

                    df <- read_excel(file$datapath)
                } else {
                    stop(safeError(paste0("Invalid file type uploaded: {",file_ext,"} only `csv` and `xlsx` supported.")))
                }
            },
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
            )
        return(df)
}
