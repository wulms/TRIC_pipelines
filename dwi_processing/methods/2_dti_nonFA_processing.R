# TBSS processing

#dtifit -k data -m nodif_brain_mask -r bvecs -b bvals -o dti
# Add L2 and L3 together and divide by two to create a measure of 
# radial (perpendicular) diffusivity 
# fslmaths ${dir}/FDT/${sub}\_L2.nii.gz -add ${dir}/FDT/${sub}\_L3.nii.gz -div 2\
#${dir}/FDT/${sub}\_L23.nii.gz \# Re-orientate the FA map to standard space 
# note that you aren't resampling, just spinning it around a bit.
#fslreorient2std ${dir}/TBSS/${sub}\_FA.nii.gz ${dir}/TBSS/${sub}\_FA.nii.gz \# fslreorient2std sub-001_T1w sub-001_T1w_reoriented


file.copy(FA, FA_out)

path_to_folder(L_out)
file.copy(L, L_out)

path_to_folder(MD_out)
file.copy(MD, MD_out)

# TBSS like pipeline

## tbss FA

tbss_all(input_directory = output_tbss_FA,
         input_command = "tbss_1_preproc *.nii.gz")

tbss_all(input_directory = output_tbss_FA,
         input_command = "tbss_2_reg -T")


tbss_all(input_directory = output_tbss_FA,
         input_command = "tbss_3_postreg -S")

tbss_all(input_directory = output_tbss_FA,
         input_command = "tbss_4_prestats 0.3")


# TBSS non-FA: MD

##
folder_FA <- paste0(output_tbss_FA, "/FA")
folder_stats <- paste0(output_tbss_FA, "/stats")

input_folder <- list.files(output_tbss_FA, full.names = TRUE, 
                           all.files = TRUE, recursive = TRUE)

output_folder <- input_folder %>%
  str_replace("tbss/FA", "nonFA/tbss") %>%
  str_replace("_FA_FA", "_FA")

path_to_folder(output_folder)
file.copy(input_folder, output_folder)

##
tbss_all(input_directory = output_tbss_nonfa,
         input_command = "tbss_non_FA MD")


# TBSS non-FA: AD

##
L1_files <- str_subset(L_out, "L1.nii")
L1_output <- str_replace(L1_files, "tbss/L/", "tbss/AD/") %>%
  str_replace("L1.nii", "FA.nii")

path_to_folder(L1_output)
file.copy(L1_files, L1_output)
##
tbss_all(input_directory = output_tbss_nonfa,
         input_command = "tbss_non_FA AD")

# TBSS non-FA: RD

##
L2_files <- str_subset(L_out, "L2.nii")
L3_files <- str_subset(L_out, "L3.nii")

RD_output <- str_replace(L2_files, "L2", "RD")

file.exists(L2_files)

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