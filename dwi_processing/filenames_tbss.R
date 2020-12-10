# TBSS
FA <- list.files(output_tbss_fdt, "FA.nii", recursive = TRUE, full.names = TRUE)
L <- list.files(output_tbss_fdt, "L(1|2|3).nii", recursive = TRUE, full.names = TRUE)
MD  <- list.files(output_tbss_fdt, "MD.nii", recursive = TRUE, full.names = TRUE)

output_tbss_FA <- paste0(output_tbss, "/FA")

output_tbss_nonfa  <- paste0(output_BIDS, "/nonFA/tbss")

output_tbss_L <- paste0(output_tbss_nonfa, "/L")
output_tbss_MD <- paste0(output_tbss_nonfa, "/MD")



# optional
MO  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)
SO  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)
V  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)

FA_out <- str_remove(FA, "tbss_fdt/") %>% str_remove(subject_id) %>% str_remove("ses-s\\d{1}/dwi") %>% str_replace("//", "/tbss/FA/")
L_out <- str_remove(L, "tbss_fdt/") %>% str_remove(subject_id) %>% str_remove("ses-s\\d{1}/dwi") %>% str_replace("//", "/nonFA/tbss/L/")
MD_out <-str_remove(MD, "tbss_fdt/") %>% 
  str_remove(subject_id) %>% 
  str_remove("ses-s\\d{1}/dwi") %>% 
  str_replace("//", "/nonFA/tbss/MD/") %>%
  str_replace("_MD", "_FA")

path_to_folder(FA_out)
path_to_folder(L_out)
path_to_folder(MD_out)


# non FA steps

