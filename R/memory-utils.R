# Memory monitoring utility for NPM Calculator
# Add this to server.R for debugging memory issues

#' Monitor memory usage
#' Prints current memory usage to console/logs
monitor_memory <- function(label = "") {
  mem_info <- gc()
  used_mb <- sum(mem_info[,2]) * 8 / 1024  # Convert to MB (assuming 8 bytes per unit)
  
  cat(sprintf("[%s] Memory usage: %.1f MB\n", 
              if(nchar(label) > 0) label else "Memory Check", 
              used_mb))
  
  # Also check if we're using more than 80% of available memory
  if (used_mb > 800) {  # Assuming 1GB available
    warning(sprintf("High memory usage detected: %.1f MB", used_mb))
  }
  
  return(used_mb)
}

#' Clean up unused reactive values
#' Call this after bulk processing to free memory
cleanup_session <- function(session) {
  gc(verbose = FALSE, reset = TRUE)
  
  # Force cleanup of any orphaned reactive values
  if (exists(".values", envir = session)) {
    rm(list = ls(.values), envir = .values)
  }
  
  cat("Session cleanup completed\n")
}
