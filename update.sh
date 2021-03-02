#!bin/bash

## Update delays - only if new data available
Rscript delays/update.R

## Update fixed case Rt
Rscript cases/update-short.R

## Update time-varying case Rt
Rscript cases/update-long.R