# NPM Calculator Tool

[![DOI](https://zenodo.org/badge/525283616.svg)](https://zenodo.org/badge/latestdoi/525283616)

First release of the NPM Calculator tool. This version is designed to assess user-entered single product information against the [UK NPM (2004/5)](https://www.gov.uk/government/publications/the-nutrient-profiling-model) and scope for [HFSS legislation](https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance) around product placement.

## NPM Table Calculator

This package also includes an experimental Table Calculator feature. 
This uses the CDRC R package
[`nutrientprofiler`](https://github.com/Leeds-CDRC/nutrientprofiler)
which is explicitly installed in the [Dockerfile](./Dockerfile). All components
of the Table Calculator except server functions are defined within new component
files that are present in the [`R`](./R/) folder. All server functions for the
Table Calculator are defined within [server.R](./server.R#L509) to enable proper
propogration of input and output variables.

### Updating `nutrientprofiler` package in NPM Calculator

Occasionally, there may be updates to the
[`nutrientprofiler`](https://github.com/Leeds-CDRC/nutrientprofiler) package
that need to be updated within this Shiny app. To pull through more up to date
versions of the package you should change the version specified within the `RUN`
line that installs the package within the [Dockerfile](./Dockerfile#L5).

```docker
# change @v1.0.0 to another version
RUN R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v1.0.0")'
```

If the change is not included in a version but rather is the most recent commit
on the `main` branch, you can change `@v1.0.0` to `@main`, or remove the `@v1.0.0`
section completely.