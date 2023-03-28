#' A function to extract file extensions
#' 
#' Use basename to get the base filename from a path and strsplit to split the character string
#' on `.` (we have to escape twice). This returns a list with a vector of the result of the split
#' we index out the last item (which should be the file extension)
#'
#' @param filename a character string of a filename
#' 
#' @return a character string of the file extension
#' 
extract_ext <- function(filename, index = -1) {

    file_ext <- strsplit(basename(filename), split = "\\.")[[1]][index]

    return(file_ext)
}