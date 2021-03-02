# Packages ----------------------------------------------------------------
require(EpiNow2)
require(covidregionaldata)
require(data.table)
require(future)
require(here)

# Save incubation period and generation time ------------------------------
generation_time <- get_generation_time(disease = "SARS-CoV-2", 
                                       source = "ganyani", max = 30)

incubation_period <- get_incubation_period(disease = "SARS-CoV-2", 
                                           source = "lauer", max = 30)

saveRDS(generation_time , here("delays", "data", "generation_time.rds"))
saveRDS(incubation_period, here("delays", "data", "incubation_period.rds"))

# Set up parallel ---------------------------------------------------------
if (!interactive()) {
  ## If running as a script enable this
  options(future.fork.enable = TRUE)
}
plan(multiprocess)

# Fit delay from onset to admission ---------------------------------------
report_delay <- covidregionaldata::get_linelist(report_delay_only = TRUE)
report_delay <- report_delay$delay_onset_report
report_delay <- report_delay[!is.na(report_delay)]
onset_to_report_delay <- estimate_delay(report_delay,
                                        bootstraps = 100, 
                                        bootstrap_samples = 250, 
                                        samples = 4000)

## Set max allowed delay to 30 days to truncate computation
onset_to_report_delay$max <- 30
saveRDS(onset_to_report_delay, 
        here("delays", "data", "onset_to_report_delay.rds"))
