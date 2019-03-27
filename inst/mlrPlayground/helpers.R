
# used in global.R
read.config = function(file) {
  #' @description Function for parsing the config file containing information
  #' about which learners are valid and some redefinitions of their hyperparameters
  #' @param file Filename of the config file
  #' @return list with 2 named elements: "valid.learners" character vector of
  #' shortnames of valid learners; "param_df" dataframe of redefinitions of some
  #' hyperparameters

  text      = read.csv(file = file, quote = "", header = FALSE, sep = "\n")
  # catch start of second section (first is documentation about writing the config)
  fst_index = which(text$V1 == "### Valid learners")
  # catch start of third section
  snd_index = which(text$V1 == "### Hyperparameter definitions")
  # character vector of valid learners (factor format)
  valid.learners  = text$V1[(fst_index + 1) : (snd_index - 1)]
  # character vector of hyperparameter redefinitions
  hyperparameters = text$V1[(snd_index + 1) : nrow(text)]

  # transform to dataframe of hyperparameter configurations
  param_df = read.table(text = as.character(hyperparameters),  header = TRUE, sep = ",", dec = ".")
  # factor to character
  param_df = lapply(param_df, as.character)
  # whitespace trimming
  param_df[c("short.name", "param.name", "new.name")] = lapply(param_df[c("short.name", "param.name", "new.name")], trimws)
  # surpress warnings when transforming "NA" to NA
  suppressWarnings({
    # character to integer (don't skip as.character here!!!)
    param_df[c("new.min", "new.max", "new.default")] = lapply(param_df[c("new.min", "new.max", "new.default")], as.integer)
  })
  # return
  list(valid.learners = valid.learners, param_df = param_df)

}

# used in reactiveValues.R for checking hyperparameter inputs in the UI
modified_req = function(x){
  #' @description modified version of the req function
  #' doesn't throw error if x equals FALSE
  #' @param x anything to check for
  # '!' doesn't work here because x can be anything
  #' @return input

  if (!is.null(x) && x == FALSE)
    x
  else
    req(x)
}


# function providing an alternative to shiny's radioButtons
custom_radioButtons = function(id, label, choices){
  # shiny's radioButtons doesn't work in our UI, so we have to do our own
  div(
    id = id,
    class="form-group shiny-input-radiogroup shiny-input-container",
    shiny:::controlLabel(id, label),
    #tags$h3(label),
    div(
      class = "radio",
      lapply(1:length(choices), function(i){
        # check the first choice
        if (i < 2)
          inp = tags$input(type = "radio", name = id, value = choices[[i]], checked = "checked")
        else
          inp = tags$input(type = "radio", name = id, value = choices[[i]])

        div(
          tags$label(
            class = "container",
            helpText(style = "margin-left: 30px;", choices[[i]]),
            inp,
            tags$span(class = "checkmark", style = "border-radius: 50%;")
          )
        )
      })
    )
  )
}


# function providing an alternative to shiny's checkboxInput
custom_checkboxInput = function(id, label, value = FALSE){
  # shiny's checkboxInput doesn't work in our UI, so we have to do our own
  value = restoreInput(id = id, default = value)
  inp   = tags$input(id = id, type = "checkbox")
  # make checkbox "checked" when value is TRUE
  if (!is.null(value) && value)
    inp$attribs$checked = "checked"

  tags$label(
    class = "container",
    helpText(label),
    inp,
    tags$span(class = "checkmark")
  )
}
