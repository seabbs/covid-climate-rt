# Packages -----------------------------------------------------------------
require(EpiNow2)
require(data.table)
require(lubridate)
require(here)

# Update delays -----------------------------------------------------------
generation_time <- readRDS(here("delays", "data", "generation_time.rds"))
incubation_period <- readRDS(here("delays", "data", "incubation_period.rds"))
reporting_delay <- readRDS(here("delays", "data", "onset_to_report_delay.rds"))

# Get cases  ---------------------------------------------------------------
cases <- fread(here("data", "short_window_cases_for_R_est.csv"))
cases <- cases[, .(region = citycode, date = dmy(date), confirm = cases)]

# Insert a breakpoint after the first 7 days of data ----------------------
cases <- cases[, breakpoint := fifelse(date == (min(date) + days(3)), 1, 0), 
                by = region]
setorder(cases, region, date)

 # Set up cores ----------------------------------------------------------
setup_future(cases, min_cores_per_worker = 1)

# Run Rt estimation -------------------------------------------------------
regional_epinow(reported_cases = cases,
                generation_time = generation_time,
                delays = delay_opts(incubation_period, reporting_delay),
                gp = NULL, obs = obs_opts(week_effect = FALSE),
                stan = stan_opts(samples = 4000, warmup = 1000, cores = 1,
                                 chains = 4, max_execution_time = 60*60),
                horizon = 0, target_folder = "cases/fixed/region",
                summary_args = list(summary_dir = "cases/fixed/summary",
                                    all_regions = FALSE))