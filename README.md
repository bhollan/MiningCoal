This is a project showcase for two courses at Georgetown.

IMPLEMENTATION

Just clone the repo, run `library(shiny)` and then `runApp()` in your R console in RStudio. You'll probably have to install a ton of libraries in the first run, but everything should be here. I've never used `git lfs` before, but afaik, it's indistinguishable.

EDITING

The raw data were taken from the MSHA's data portal, and are stored here as an `.rds` file in the `/data` folder. If you want to tweak a model, there's a `modelling.R` file where most of that was done and the results were also stored in the `/data` folder as `.rds` files to avoid high latency. Latency was also the reason the scatter plots were saved to a `/figures` folder as static `.png` images (they were taking >2-3 minutes to render). 

HOSTING

This is currently deployed on the free tier of  [shinyapps.io](https://brh60.shinyapps.io/MiningCoal/).
