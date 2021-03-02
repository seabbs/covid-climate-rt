# Packages -----------------------------------------------------------------
require(EpiNow2)
require(data.table)
require(future)
require(lubridate)
require(futile.logger)

# Update delays -----------------------------------------------------------
generation_time <- readRDS(here("delays", "data", "generation_time.rds"))
incubation_period <- readRDS(here("delays", "data", "incubation_period.rds"))
reporting_delay <- readRDS(here("delays", "data", "onset_to_report_delay.rds"))

# Get cases  ---------------------------------------------------------------
cases <- fread(here("data", "long_window_cases_for_Rt_est.csv"))
cases <- cases[, .(region = citycode, date = dmy(date), confirm = cases)]

 # Set up cores ----------------------------------------------------------
setup_future(cases, min_cores_per_worker = 1)

# Run Rt estimation -------------------------------------------------------
regional_epinow(reported_cases = cases,
                generation_time = generation_time,
                delays = delay_opts(incubation_period, reporting_delay),
                stan = stan_opts(samples = 4000, warmup = 1000, cores = 1,
                                 chains = 4, max_execution_time = 60*60),
                horizon = 0, target_folder = "cases/time-varying/region",
                summary_args = list(summary_dir = "cases/time-varying/summary",
                                    all_regions = FALSE))

