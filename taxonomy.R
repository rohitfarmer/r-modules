if (!require('doMC')) install.packages('doMC'); import(doMC)
if (!require('dplyr')) install.packages('dplyr'); import(dplyr)
if (!require('foreach')) install.packages('foreach'); import(foreach)
if (!require('parallel')) install.packages('parallel'); import(parallel)
if (!require('tibble')) install.packages('tibble'); import(tibble)

names_to_tax_local <- function(orgnames, names_db, rankedlineage_db, verbose = FALSE){
   #     df_out <- data.frame()
        df_out <- tibble()
        cores <- detectCores(all.tests = FALSE, logical = FALSE)
        cores <- cores - 1
        registerDoMC(cores)
        #df_out <- foreach(i = 1:length(orgnames), .combine = rbind) %dopar%{
        df_out <- foreach(i = 1:length(orgnames), .combine = bind_rows) %dopar%{
                tax <- orgnames[[i]]
                if(verbose){
                        cat(paste(i, tax, "\n"))
                }
                taxid <- names_db %>% dplyr::filter(name_txt == tax) %>%
                        dplyr::pull(tax_id)
#                taxid <- names_db[names_db$name_txt == tax,][["tax_id"]]

                if(length(taxid) !=0){
                        rankedlineage_db %>% dplyr::filter(tax_id == taxid) %>%
                                dplyr::mutate("query_org_name" = tax)
#                temp_df <- rankedlineage_db[rankedlineage_db$tax_id == taxid,]
#                temp_df$query_org_name <- tax
#                temp_df
                }
        }  
        return(df_out)
}
