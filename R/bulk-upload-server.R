library(shiny)
library(readxl)

load_and_render <- function(file, header, sep, quote) {

            # retrieve file extension
            file_ext <- extract_ext(file$datapath, -1)

            # when reading semicolon separated files,
            # having a comma separator causes `read.csv` to error
            tryCatch(
            {
                if (file_ext == "csv") {

                    df <- read.csv(file$datapath,
                            header = header,
                            sep = sep,
                            quote = quote)

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
