# TBSS
FA <- list.files(output_tbss_fdt, "FA.nii", recursive = TRUE, full.names = TRUE)
L <- list.files(output_tbss_fdt, "L(1|2|3).nii", recursive = TRUE, full.names = TRUE)
MD  <- list.files(output_tbss_fdt, "MD.nii", recursive = TRUE, full.names = TRUE)

output_tbss_FA <- paste0(output_tbss, "/FA")

output_tbss_nonfa  <- paste0(output_BIDS, "/4_nonFA_copy_chaos/tbss")

output_tbss_L <- paste0(output_tbss_nonfa, "/L")
output_tbss_MD <- paste0(output_tbss_nonfa, "/MD")



# optional
MO  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)
SO  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)
V  <- list.files(output_tbss_fdt, "", recursive = TRUE, full.names = TRUE)


FA_out <- str_replace(FA, "2_tbss_fdt/", "3_tbss/FA/") %>% 
  str_remove(subject_id) %>% 
  str_remove("ses-s\\d{1}/dwi")

L_out <- str_replace(L, "2_tbss_fdt/", "4_nonFA_copy_chaos/tbss/L/") %>% 
  str_remove(subject_id) %>% 
  str_remove("ses-s\\d{1}/dwi")

<<<<<<< HEAD

if (end_on_fdt == "yes") {
  MD_out <-str_replace(MD, "2_tbss_fdt/", "4_nonFA_copy_chaos/tbss/MD/") %>% 
    str_remove(subject_id) %>%  
    str_remove("ses-s\\d{1}/dwi") %>% 
    str_remove("_MD")
}

if (end_on_fdt == "no") {
  MD_out <-str_replace(MD, "2_tbss_fdt/", "4_nonFA_copy_chaos/tbss/MD/") %>% 
    str_remove(subject_id) %>%  
    str_remove("ses-s\\d{1}/dwi") %>% 
    # rename MD to FA
    str_replace("_MD", "_FA")
}
=======
MD_out <-str_replace(MD, "2_tbss_fdt/", "4_nonFA_copy_chaos/tbss/MD/") %>% 
  str_remove(subject_id) %>%  
  str_remove("ses-s\\d{1}/dwi") %>% 
  # rename MD to FA
  str_replace("_MD", "_FA")
>>>>>>> 494f258a8d55c41eefdc8d0cbf3bfd1ffa166f7b



