if (!require('doMC')) install.packages('doMC'); import(doMC)
if (!require('parallel')) install.packages('parallel'); import(parallel)
if (!require('foreach')) install.packages('foreach'); import(foreach)

names_to_taxonomy <- function(orgnames, names_db, rankedlineage_db){
  df_out <- data.frame()
  cores <- detectCores(all.tests = FALSE, logical = FALSE)
  cores <- cores - 1
  registerDoMC(cores)
  df_out <- foreach(i = 1:length(orgnames), .combine = rbind) %dopar%{
    tax <- orgnames[[i]]
    cat(paste(i, tax, "\n"))
    #taxid <- names_db %>% dplyr::filter(name_txt == tax) %>%
      #pull(tax_id)
    taxid <- names_db[names_db$name_txt == tax,][["tax_id"]]
    
    if(length(taxid) !=0){
      #rankedlineage_db %>% dplyr::filter(tax_id == taxid) %>%
        #dplyr::mutate("query_org_name" = tax)
      temp_df <- rankedlineage_db[rankedlineage_db$tax_id == taxid,]
      temp_df$query_org_name <- tax
      temp_df
    }
  }  
  return(df_out)
}
