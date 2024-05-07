library(shiny)
library(dplyr)
library(clustermole)

# Define server logic required to draw a histogram
function(input, output, session) {
  # Take a reactive dependency on the submit button
  df <- eventReactive(input$submit_button, {
    # Split the entered text by comma, tab, newline
    text <- input$genes
    lines <- unlist(strsplit(text, "\n"))
    elements <- unlist(strsplit(lines, "\t|,| "))
    elements <- elements[elements != ""]
    elements <- trimws(elements)
    # Run clustermole and show any error messages
    tryCatch(
      {
        celltype_df <- clustermole_overlaps(genes = elements, species = input$species)
      },
      error = function(e) {
        stop(safeError(e))
      }
    )
    # Adjust the overlap output
    celltype_df <- mutate(celltype_df, overlap = paste(overlap, "of", n_genes))
    # Remove underscores to avoid long lines since they are not used for wrapping text
    celltype_df <- mutate(celltype_df, celltype = gsub("_", " ", celltype))
    # Format p-values in scientific notation to avoid rounding to 0
    celltype_df$p_value <- sprintf("%.2g", celltype_df$p_value)
    celltype_df$fdr <- sprintf("%.2g", celltype_df$fdr)
    # Specify columns to display
    celltype_df <- select(celltype_df, `Cell Type` = celltype, Organ = organ, Species = species, Database = db, Overlap = overlap, P = p_value, FDR = fdr)
    # Output just the most significant results
    head(celltype_df, 25)
  })

  # Output the table of cell types
  output$celltype_table <- renderTable(df(), striped = TRUE, spacing = "xs")

  # Output the clustermole version
  output$clustermole_version <- renderText(as.character(packageVersion("clustermole")))
}
