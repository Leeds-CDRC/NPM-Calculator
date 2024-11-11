# # License

# The NPM calculator and underlying nutrientprofiler R package provide functions to help assess product information against the UK Nutrient Profiling Model (2004/5) and scope for HFSS legislation around product placement. It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

# Copyright (C) 2024 University of Leeds

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# A copy of the GNU Affero General Public License is supplied
# along with this program in the `LICENSE` file in the repository.
# You can also find the full text at https://www.gnu.org/licenses.

# You can contact us by raising an issue on our GitHub repository (https://github.com/Leeds-CDRC/NPM-Calculator/issues/new - login required) or by emailing
# us at info@cdrc.ac.uk.
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

                    df <- as.data.frame(read_excel(file$datapath))
                    df$food_type[is.na(df$food_type)] <- ""

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
