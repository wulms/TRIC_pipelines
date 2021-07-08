# TBSS presets

###########################################################################################

# copy the tbss folder from the FA data (the original TBSS output, to the nonFA folder in a tbss folder)?

# folder_FA <- paste0(output_tbss_FA, "/FA")
# folder_stats <- paste0(output_tbss_FA, "/stats")
input_folder <- list.files(output_tbss_FA, full.names = TRUE, 
                           all.files = TRUE, recursive = TRUE)

output_folder <- input_folder %>%
  str_replace("3_tbss/FA", "4_nonFA_copy_chaos/tbss") %>%
  str_replace("_FA_FA", "_FA")

path_to_folder(output_folder)
file.copy(input_folder, output_folder)


###########################################################################################

# TBSS non-FA: MD
##
path_to_folder(MD_out)
file.copy(MD, MD_out)

tbss_all(input_directory = output_tbss_nonfa,
         input_command = "tbss_non_FA MD")


###########################################################################################

# TBSS non-FA: AD
##
path_to_folder(L_out)
file.copy(L, L_out)

L1_files <- str_subset(L_out, "L1.nii")
L1_output <- str_replace(L1_files, "tbss/L/", "tbss/AD/") %>%
  str_replace("L1.nii", "FA.nii")

path_to_folder(L1_output)
file.copy(L1_files, L1_output)
##
tbss_all(input_directory = output_tbss_nonfa,
         input_command = "tbss_non_FA AD")

###########################################################################################

# TBSS non-FA: RD
## calculate RD
L2_files <- str_subset(L_out, "L2.nii")
L3_files <- str_subset(L_out, "L3.nii")

RD_output <- str_replace(L2_files, "L2", "RD")

## calculate RD
input_command = paste0("fslmaths ", L2_files, " -add ", L3_files, " -div 2 ", RD_output)
lapply(input_command, system)

##
RD_files <- list.files(output_tbss_L, "RD", full.names = TRUE, 
                       all.files = TRUE, recursive = TRUE)

RD_out <- str_replace(RD_files, "tbss/L/", "tbss/RD/") %>%
  str_replace("RD.nii", "FA.nii")

path_to_folder(RD_out)
file.copy(RD_files, RD_out)
## 
tbss_all(input_directory = output_tbss_nonfa,
         input_command = "tbss_non_FA RD")
