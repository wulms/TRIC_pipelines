merged_df <- tibble(files = list.files(path = output_extraction, 
                                       pattern = "txt", 
                                       recursive = TRUE, full.names = TRUE)) %>%
  mutate(filename = str_extract(files, pattern = "/(FA|MD|RD|AD)_.*txt"),
         type = str_extract(filename, "/(FA|MD|RD|AD)") %>%
           str_remove("/"),
         txt_type = str_extract(filename, "meants_|meantstats_") %>%
           str_remove("_"),
         roinum = str_extract(filename, "[:digit:]{3}"),
         roi = str_extract(filename, "(?<=[:digit:]{3}_).*$") %>%
           str_remove(".txt"))

merged_df %>%
  mutate(txt = lapply(files, read.delim, header = FALSE) %>% unlist())


#
lapply(merged_df$files[344], read.delim, header = FALSE)


merged_df %>%
  filter(str_detect(files, "meantstats")) -> meanstats_df

merged_df %>%
  filter(!str_detect(files, "meantstats")) -> meants_df

meants_df %>%
#  nest(files) %>%
  mutate(text = lapply(files, read.delim, header = FALSE)) %>% 
  unnest(text)


subjects <- RD_output %>%
  str_extract(., subject_id)
      