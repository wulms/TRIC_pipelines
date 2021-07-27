
# read all the metadata
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



# split dfs into meants and meanstats
merged_df %>%
  filter(str_detect(files, "meantstats")) -> meanstats_df

merged_df %>%
  filter(!str_detect(files, "meantstats")) -> meants_df


# extract subject information
subject_string = str_remove(subject_id, "/")

subject_ids = list.files(paste0(output_tbss_nonfa, "/origdata")) %>%
  str_extract(pattern = subject_string)


#calculate merged dfs
meants_df %>%
#  nest(files) %>%
  mutate(text = lapply(files, read.delim, header = FALSE)) %>% 
  unnest(text) %>% 
  rename(mean = V1) %>%
  cbind(subject_ids) -> meants_long

meants_long %>% 
  select(-filename, -files) %>%
  pivot_wider(names_from = c(type, roinum, roi), 
              values_from = mean) -> meants_wide


meanstats_df %>%
  #  nest(files) %>%
  mutate(text = lapply(files, read.delim, header = FALSE)) %>% 
  unnest(text) %>% 
  mutate(V1 = str_remove(V1, " $")) %>%
  cbind(subject_ids) %>%
  separate(V1, into = c("mean", "sd"), sep = " ") -> meanstats_long

meanstats_long %>%
  select(-filename, -files) %>%
  pivot_wider(names_from = c(type, roinum, roi), 
              values_from = c(mean, sd)) -> meanstats_wide

# write out the files
readr::write_csv(meanstats_long, file = meanstats_long_csv)
readr::write_csv(meanstats_wide, file = meanstats_wide_csv)
readr::write_csv(meants_long, file = meants_long_csv)
readr::write_csv(meants_wide, file = meants_wide_csv)





      