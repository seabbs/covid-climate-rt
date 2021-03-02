
# Covid-19 Rt estimates for evaluating the role of climate


## Repository structure

- `data`: Contains the raw case and death count data on which the study is based. Not pushed to git as may be identifying.
- `delays`: Contains an `update.R` used to update the estimation of delay distributions and `data` in which current delay distribution estimates are stored.
- `cases`: Contains two update scripts, `update-long.R` and `update-short.R` these update Rt estimates for the time-varying estimate and the fixed estimate. 

## Reproducibility

### Install dependencies

Install all dependencies with the following:

```r
# install.packages("devtools")
devtools::install_dev_deps()
```

### Update estimates

Update all estimates using the followng:

```bash
nohup bash update.sh
```

### Docker

A Dockerfile and prebuilt Docker image has been provided to enhance reproducibility. First login into the GitHub package repository using your GitHub credentials (if you have not already done so) and then run the following:

```bash
# docker login docker.pkg.github.com
docker pull docker.pkg.github.com/seabbs/covid-climate-rt/covidclimatert:latest
docker tag docker.pkg.github.com/seabbs/covid-climate-rt/covidclimatert:latest covidclimatert
```
To run the docker image run:

``` bash
docker run -d -p 8787:8787 --name covidclimatert -e USER=covidclimatert -e PASSWORD=covidclimatert covidclimatert
```