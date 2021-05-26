server_config <- list(
  max_occurrence_records = 500000, #updated
  server_max_url_length = 8150,
  brand = "ALA4R",
  notify = "Please use https://github.com/AtlasOfLivingAustralia/ALA4R/issues/ or email to support@ala.org.au",
  support_email = "support@ala.org.au",
  reasons_function = "ala_reasons",
  fields_function = "ala_fields",
  occurrences_function = "occurrences",
  config_function = "ala_config",
  base_url_spatial = "https://spatial.biodiversitydata.se/ws/",
  base_url_bie = "https://species.biodiversitydata.se/ws/",
  base_url_biocache = "https://records.biodiversitydata.se/ws/",
  base_url_biocache_download = "https://records.biodiversitydata.se/ws/biocache-download/",
  base_url_alaspatial = "https://spatial.biodiversitydata.se/alaspatial/ws",
  base_url_images = "https://images.biodiversitydata.se",
  base_url_logger = "https://logger.biodiversitydata.se/service/logger/",
  # base_url_fieldguide = "https://fieldguide.bioatlas.se/",
  base_url_lists = "https://lists.biodiversitydata.se/ws/",
  base_url_collectory = "https://collections.biodiversitydata.se/ws/",
  biocache_version = "2.2.3",
  verbose = TRUE,
  download_reason_id = 10,
  caching="off"
)
if (!"ALA4R_server_config" %in% names(options())) {
  message("\nNo existing ALA4R server config, using Swedish data sources...\n")
  options(ALA4R_server_config = server_config)
} else {
  message("Overwriting existing ALA server config with new...")
  options(ALA4R_server_config = server_config)
}

message("\n*** Successfully loaded .Rprofile ***\n")
