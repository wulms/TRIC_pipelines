# INPUT
input_sourcedata <- paste0(BIDS_folder, "/sourcedata")
input_params <- paste0(BIDS_folder, "/params")

acqparams <- paste0(input_params, "/acqparams.txt")
index <- paste0(input_params, "/index.txt")

# INPUT files
dwi_b0_images <- list.files(input_sourcedata, "s\\d{1}_acq-b0_dwi.nii.gz", full.names = TRUE, recursive = TRUE)
dwi_images <- list.files(input_sourcedata, "s\\d{1}_dwi.nii.gz", full.names = TRUE, recursive = TRUE)
dwi_bvec <- list.files(input_sourcedata, "s\\d{1}_dwi.bvec", full.names = TRUE, recursive = TRUE)
dwi_bval <- list.files(input_sourcedata, "s\\d{1}_dwi.bval", full.names = TRUE, recursive = TRUE)

# OUTPUT - folders
output_BIDS <- paste0(BIDS_folder, "/derived/TRIC_dwi_pipeline")

output_topup <- paste0(output_BIDS, "/preprocessing/topup")
output_eddy <-  paste0(output_BIDS, "/preprocessing/eddy")
output_qc <- paste0(output_BIDS, "/preprocessing/qualitycontrol")

output_tbss <- paste0(output_BIDS, "/tbss")
output_tbss_temp  <- paste0(output_BIDS, "/tbss_temp")
output_tbss_fdt <- paste0(output_BIDS, "/tbss_fdt")

# output_b0_image <- str_replace(dwi_images, "dwi.nii", "acq-b0_dwi.nii") %>% str_replace("data_bidirect/", paste0("/", output_folder, "/topup/"))

# OUTPUT - filenames

output1_AP_blip <- str_replace(dwi_images, ".nii", "_AP_blip.nii") %>% str_replace(input_sourcedata, output_topup)
output2_PA_blip <- str_replace(dwi_images, ".nii", "_PA_blip.nii") %>% str_replace(input_sourcedata, output_topup)
output3_AP_PA_blips <- str_replace(dwi_images, ".nii", "_AP_PA_blips.nii") %>% str_replace(input_sourcedata, output_topup)
output4_topup <- str_replace(dwi_images, ".nii.gz", "_topup") %>% str_replace(input_sourcedata, output_topup)
output5_field <- str_replace(dwi_images, ".nii", "_field.nii") %>% str_replace(input_sourcedata, output_topup)
output6_hifi_b0 <- str_replace(dwi_images, ".nii", "_hifi_b0.nii") %>% str_replace(input_sourcedata, output_topup)
output6_AP_blip <- str_replace(dwi_images, ".nii", "_AP_blip.nii")  %>% str_replace(input_sourcedata, output_topup) # namen doppelt? input 1?
output6_AP_blip_tmean <-  str_replace(dwi_images, ".nii", "_AP_blip_tmean.nii")  %>% str_replace(input_sourcedata, output_topup)
output7_bet <- str_replace(dwi_images, ".nii", "_bet.nii") %>% str_replace(input_sourcedata, output_topup)
# EDDY
output8_eddy_unwarped <- str_replace(dwi_images, ".nii", "_eddy_unwarped.nii") %>% str_replace(input_sourcedata, output_eddy) %>% str_remove(".nii.gz|.nii")
output8_eddy_cuda <- str_replace(dwi_images, ".nii", "_eddy_unwarped_cuda.nii") %>% str_replace(input_sourcedata, output_eddy) %>% str_remove(".nii.gz|.nii")

output8_eddy_unwarped_nii <- paste0(output8_eddy_unwarped, ".nii") 
output8_eddy_unwarped_niigz <- paste0(output8_eddy_unwarped_nii, ".gz")

# FDT 
output9_fdt <- str_replace(dwi_images, ".nii", "_fdt.nii") %>% str_replace(input_sourcedata, output_tbss_fdt) %>% str_remove(".nii.gz|.nii")

