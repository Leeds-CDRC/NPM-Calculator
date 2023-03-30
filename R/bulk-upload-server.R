library(shiny)
library(readxl)

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
