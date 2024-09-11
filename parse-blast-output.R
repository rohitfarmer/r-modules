# Parse BLAST output from a text file with the default format i.e. outfmt 0

library(tidyverse)

parse_blast_fmt_0 <- function(blast_output_file){
        blast_lines <- readLines(blast_output_file)

        ali_pos <- which(grepl("^>", blast_lines))

        qseqid <- sub("Query= ", "", blast_lines[which(grepl("^Query= ", blast_lines))])

        samp_df <- tibble()
        for(ai in 1:length(ali_pos)){
                ali_blk_i <- ali_pos[ai]

                if(ai != length(ali_pos)){
                        ali_blk_j <- ali_pos[ai+1] -1
                } else if(ai == length(ali_pos)) {
                        ali_blk_j <- min(which(grepl("Lambda", blast_lines))) - 1
                }


                ali_blk <- blast_lines[ali_blk_i:ali_blk_j]

                current_subject <- sub("^>", "", ali_blk[1])
                score_info <- strsplit(ali_blk[4], ", ")[[1]]
                current_score <- as.numeric(strsplit(sub(" Score = ", "", score_info[1]), " ")[[1]][1])
                current_evalue <- as.numeric(sub(" Expect = ", "", score_info[2]))

                identity_info <- strsplit(ali_blk[5], ", ")[[1]]
                current_identity_perc <- as.numeric(sub("\\%)", "", strsplit(sub(" Identities = ", "", identity_info[1]), "\\(")[[1]][2]))
                current_positive_perc <- as.numeric(sub("\\%)", "", strsplit(sub("Positives = ", "", identity_info[2]), "\\(")[[1]][2]))
                current_gaps_perc <- as.numeric(sub("\\%)", "", strsplit(sub("Gaps = ", "", identity_info[3]), "\\(")[[1]][2]))
                current_ali_length <- as.numeric(strsplit(strsplit(sub(" Identities = ", "", identity_info[1]), " ")[[1]][1], "/")[[1]][2])

                qpos <- which(grepl("^Query", ali_blk))
                qstart <- suppressWarnings(min(as.numeric(strsplit(paste(ali_blk[qpos], collapse = " "), " ")[[1]]), na.rm = TRUE))
                qend <- suppressWarnings(max(as.numeric(strsplit(paste(ali_blk[qpos], collapse = " "), " ")[[1]]), na.rm = TRUE))

                spos <- which(grepl("^Sbjct", ali_blk))
                sstart <- suppressWarnings(min(as.numeric(strsplit(paste(ali_blk[spos], collapse = " "), " ")[[1]]), na.rm = TRUE))
                send <- suppressWarnings(max(as.numeric(strsplit(paste(ali_blk[spos], collapse = " "), " ")[[1]]), na.rm = TRUE))

                blk_df <- tibble("qseqid" = qseqid, "sseqid" = current_subject, 
                                 "score" = current_score,
                                 "evalue" = current_evalue,
                                 "pident" = current_identity_perc, 
                                 "ppositive" = current_positive_perc,
                                 "ali_length" = current_ali_length,
                                 "pgaps" = current_gaps_perc,
                                 "qstart" = qstart,
                                 "qend" = qend,
                                 "sstart" = sstart,
                                 "send" = send)


                samp_df <- bind_rows(samp_df, blk_df)
        }
        samp_df <- samp_df %>%
                arrange(desc(score))
        return(samp_df)
}
