library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
fluidPage(
  theme = shinytheme("yeti"),

  # Application title
  titlePanel("Marker Genes to Cell Types"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      p("Identify the cell types associated with a set of genes."),
      textAreaInput(
        inputId = "genes",
        label = "Genes separated by commas, spaces, or new lines:",
        placeholder = "CD19, CD79A, CD79B, PAX5, CD20, BANK1, IGHD, IGHM, MS4A1",
        width = "100%", height = "100%", rows = 10
      ),
      selectInput(
        inputId = "species",
        label = "Species:",
        c("human" = "hs", "mouse" = "mm")
      ),
      actionButton(inputId = "submit_button", label = "Submit")
    ),

    # Main panel
    mainPanel(
      tableOutput("celltype_table")
    )
  ),

  # Footer
  div(
    align = "center",
    style = "font-size: 80%;",
    "powered by",
    tags$a(href = "https://cran.r-project.org/package=clustermole", "clustermole", target = "_blank"),
    textOutput("clustermole_version", inline = TRUE)
  )
)
