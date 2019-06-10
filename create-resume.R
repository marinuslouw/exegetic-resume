library(jsonlite)
library(dplyr)
library(glue)

JSONFILE <- "marinus-louw.json"
# JSONFILE <- "gerard-walsh.json"
TEMPLATE <- "resume-template.html"

data <- fromJSON(JSONFILE)

# TOOLS ---------------------------------------------------------------------------------------------------------------

data$tools <- lapply(data$tools, function(tool) paste0('<div class="col-md-4">', tool, '</div>')) %>% paste(collapse = "\n")

# EDUCATION -----------------------------------------------------------------------------------------------------------

# Replace table with formatted HTML.
#
data$education <- lapply(1:nrow(data$education), function(n) {
  attach(data$education[n, ])
  # 
  html <- glue('
  <div>
    <h3>{qualification}</h3>
    <div>{institution}</div>
    <div class="row">
      <div class="col light">{location}</div>
      <div class="col-right light">{period}</div>
    </div>
    <div>{details}</div>
  </div>')
  # 
  detach()
  # 
  html
}) %>% paste(collapse = "\n")

# POPULATE TEMPLATE ---------------------------------------------------------------------------------------------------

template <- readLines(TEMPLATE) %>% paste(collapse = "\n")

resume <- glue(template, .open = "{{", .close = "}}", .envir = data)

# PERSIST -------------------------------------------------------------------------------------------------------------

HTMLFILE <- sub(".json$", ".html", JSONFILE)

writeLines(resume, HTMLFILE)
