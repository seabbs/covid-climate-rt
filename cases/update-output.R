# Packages ----------------------------------------------------------------
require(data.table)

# Get fixed summary estimates ---------------------------------------------
get_fixed <- function(path, write_path) {
  fixed_summary <- fread(path)
  fixed_summary <- fixed_summary[, .SD[date == max(date)], by = region][, 
                                   `:=`(type = "fixed", citycode = region)][,
                                    c("region", "date") := NULL]
  fixed_regions <- fread(here("data", "short_window_cases_for_R_est.csv"))
  fixed_regions <- unique(fixed_regions[, .(countryname, cityname, citycode)])
  fixed_summary <- fixed_regions[fixed_summary, on = "citycode"]
  fwrite(fixed_summary, write_path)
}

get_fixed(path = "cases/fixed/summary/rt.csv",
          write_path = "cases/output/fixed-rt.csv")

get_fixed(path = "cases/fixed/summary/growth_rate.csv",
          write_path = "cases/output/fixed-growth-rate.csv")

# Get time-varying Rt summary estimates -----------------------------------
get_time_varying <- function(path, write_path) {
  time_varying_summary <- fread("cases/time-varying/summary/rt.csv")
  time_varying_summary <- time_varying_summary[, citycode := region][,
                                                 region := NULL]
  vary_regions <- fread(here("data", "long_window_cases_for_Rt_est.csv"))
  vary_regions <- unique(vary_regions[, .(countryname, cityname, citycode)])
  time_varying_summary <- vary_regions[time_varying_summary, on = c("citycode")]
  fwrite(time_varying_summary, write_path)
}

get_time_varying(path = "cases/time-varying/summary/rt.csv", 
                 write_path = "cases/output/time-varying-rt.csv")

get_time_varying(path = "cases/time-varying/summary/growth_rate.csv", 
                 write_path = "cases/output/time-varying-growth-rate.csv")