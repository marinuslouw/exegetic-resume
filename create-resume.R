library(jsonlite)
library(dplyr)
library(glue)

JSONFILE <- "marinus-louw.json"
# JSONFILE <- "gerard-walsh.json"
TEMPLATE <- "resume-template.html"

data <- fromJSON(file.path("json", JSONFILE))

# TOOLS ---------------------------------------------------------------------------------------------------------------

data$tools <- lapply(data$tools, function(tool) paste0('<div class="col-md-4">', tool, '</div>')) %>% paste(collapse = "\n")

# EXPERIENCE ----------------------------------------------------------------------------------------------------------

# Replace table with formatted HTML.
#
data$experience <- lapply(1:nrow(data$experience), function(n) {
  attach(data$experience[n, ])
  # 
  html <- glue('
  <div>
    <h3 style="padding-top:10px;">{company}</h3>
    <div class="row">
      <div class="emph col">{title}</div>
      <div class="col-right light">{period}</div>
    </div>
    <div>{details}</div>
  </div>')
  # 
  detach()
  # 
  html
}) %>% paste(collapse = "\n")

# EDUCATION -----------------------------------------------------------------------------------------------------------

# Replace table with formatted HTML.
#
data$education <- lapply(1:nrow(data$education), function(n) {
  attach(data$education[n, ])
  # 
  html <- glue('
  <div>
    <h3 style="padding-top:10px;">{qualification}</h3>
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
  
# ABOUT ---------------------------------------------------------------------------------------------------------------

# Replace table with formatted HTML.
#
data$about <- lapply(1:nrow(data$about), function(n) {
  attach(data$about[n, ])
  # 
  html <- glue('
  <div>
    <h3>Spoken Languages</h3>
    <div>{languages}</div>
    </div>
    <h3 style="padding-top:10px;">Hobbies</h3>
    <div>{hobbies}</div>
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

writeLines(resume, file.path("html", HTMLFILE))
