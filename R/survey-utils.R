# Survey Response Handling and Azure Storage Integration
# Functions for sanitizing survey data and sending to Azure Table Storage

#' Sanitize Survey Response
#' 
#' Cleans and validates survey response data
#'
#' @param response Character string with survey response
#'
#' @return Data frame with sanitized timestamp and response
sanitize_survey_response <- function(response) {
  
  # Remove leading/trailing whitespace
  response <- trimws(response)
  
  # Validate response is not empty
  if (nchar(response) == 0) {
    stop("Survey response cannot be empty")
  }
  
  # Validate response is one of the allowed values
  allowed_values <- c(
    "Enforcement",
    "Check compliance",
    "Check compliance (industry)",
    "Check compliance (public/third sector)",
    "Research",
    "Policy Development",
    "Other",
    "I'd rather not say"
  )
  
  if (!response %in% allowed_values) {
    stop(paste("Invalid response:", response))
  }
  
  # Create sanitized data frame
  sanitized_data <- data.frame(
    timestamp_utc = format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ"),
    response = response,
    stringsAsFactors = FALSE
  )
  
  return(sanitized_data)
}


#' Send Survey Response to Azure Table Storage
#'
#' Sends sanitized survey response to Azure Table Storage.
#' Uses SAS token auth and raises an error if config is missing
#' or if the Azure request fails.
#'
#' @param data Data frame with sanitized survey response
#' @param storage_account Character: Azure storage account name
#' @param table_name Character: Table name (default: SurveyResponses)
#' @param sas_token Character: SAS token with Add permission for table entities
#' @param partition_key Character: Partition key used for all records
#'
#' @return NULL (invisibly)
#' @keywords internal
send_to_azure_table <- function(
  data,
  storage_account = Sys.getenv("AZURE_STORAGE_ACCOUNT"),
  table_name = Sys.getenv("AZURE_TABLE_NAME", "SurveyResponses"),
  sas_token = Sys.getenv("AZURE_TABLE_SAS_TOKEN"),
  partition_key = Sys.getenv("AZURE_TABLE_PARTITION_KEY", "NPMCalculator")
) {

  if (storage_account == "" || sas_token == "") {
    stop("Azure Table not configured. Set AZURE_STORAGE_ACCOUNT and AZURE_TABLE_SAS_TOKEN")
  }

  send_via_azure_table_rest(
    data = data,
    storage_account = storage_account,
    table_name = table_name,
    sas_token = sas_token,
    partition_key = partition_key
  )

  cat("Response recorded successfully\n")

  invisible(NULL)
}


#' Send via Azure Table Storage REST API
#'
#' @keywords internal
send_via_azure_table_rest <- function(data, storage_account, table_name, sas_token, partition_key) {
  if (!requireNamespace("httr", quietly = TRUE)) {
    stop("httr package required. Install with: install.packages('httr')")
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("jsonlite package required. Install with: install.packages('jsonlite')")
  }

  sanitized_sas <- sub("^\\?", "", sas_token)
  row_key <- create_row_key()

  entity <- list(
    PartitionKey = partition_key,
    RowKey = row_key,
    TimestampUtc = data$timestamp_utc[[1]],
    Purpose = data$response[[1]],
    App = "NPM-Calculator"
  )

  endpoint <- paste0(
    "https://", storage_account, ".table.core.windows.net/",
    table_name, "?", sanitized_sas
  )

  response <- httr::POST(
    url = endpoint,
    httr::add_headers(
      `Accept` = "application/json;odata=nometadata",
      `Content-Type` = "application/json",
      `x-ms-version` = "2019-02-02"
    ),
    body = jsonlite::toJSON(entity, auto_unbox = TRUE),
    encode = "raw"
  )

  status <- httr::status_code(response)
  if (!(status %in% c(201, 204))) {
    error_text <- httr::content(response, as = "text", encoding = "UTF-8")
    stop("Azure Table API returned status ", status, ": ", error_text)
  }
}


#' Create unique row key for Azure Table entity
#'
#' @keywords internal
create_row_key <- function() {
  paste0(
    format(as.POSIXct(Sys.time(), tz = "UTC"), "%Y%m%d%H%M%S"),
    "-",
    sprintf("%06d", sample.int(999999, 1))
  )
}


#' Send via Local Backup
#'
#' Helper function to save response to local backup file
#' This can be used as fallback or with automated cloud sync
#'
#' @keywords internal
send_via_local_backup <- function(data) {
  
  backup_dir <- file.path(getwd(), "data", "survey_responses")
  
  # Create directory if it doesn't exist
  if (!dir.exists(backup_dir)) {
    dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  # Create timestamped backup file
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%OS3")
  timestamp <- gsub("[^0-9_]", "", timestamp)
  backup_file <- file.path(backup_dir, paste0("response_", timestamp, ".csv"))
  
  # Write to CSV
  utils::write.csv(data, backup_file, row.names = FALSE)
  
  cat("Survey response saved locally to:", backup_file, "\n")
  
  invisible(NULL)
}



