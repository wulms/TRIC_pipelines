#! /bin/bash
# preproc for roinum in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 ; do
# Extraction of all ROIs from ATLAS
# 
# fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr $roinum -uthr $roinum -bin roimask
# fslmaths roimask -mas mean_FA_skeleton_mask.nii.gz -bin roimask
# padroi=`$FSLDIR/bin/zeropad $roinum 3`
# fslmeants -i all_FA_skeletonised.nii.gz -m roimask -o meants_roi${padroi}.txt done

# (1)
# fslmaths JHU-ICBM-labels-1mm.nii.gz -thr 42 -uthr 42 l_slf.nii.gz
# fslmaths l_slf.nii.gz -mas mean_FA_skeleton_mask.nii.gz -bin l_slfmask.nii.gz
# fslmeants -i all_FA_skeletonised.nii.gz -o FA_l_slf_mean.txt -m l_slfmask.nii.gz
# fslstats -t all_FA_skeletonised.nii.gz -k l_slf.nii.gz -M -S | tee -a FA_l_slf_mean.txt



# reading label xml file and extracting labels
label_xml <- xml2::read_xml(label_file) %>% 
  xml_find_all(".//label") %>% 
  as_list()

label_xml_id <- label_xml %>% unlist()
label_xml_attributes <- lapply(label_xml, attributes) %>% unlist()


# roi dataframe
atlas_info <- tibble(names = names(label_xml_attributes),
                     value = label_xml_attributes) %>%
  filter(names == "index") %>%
  select(-names) %>%
  mutate(roi = label_xml_id %>% 
           str_replace_all(" |-|\\/|\\(|\\)", "_") %>%
           str_remove_all("_$"),
         roi_out = paste0(output_extraction_ROI, "/", atlas_prefix, "_", roi),
         roi_bin_out = paste0(roi_out, "_bin"))

# create directories
dir.create(output_extraction)
dir.create(output_extraction_ROI)
dir.create(output_extraction_AD)
dir.create(output_extraction_FA)
dir.create(output_extraction_MD)
dir.create(output_extraction_RD)




# loop for ROI extraction
for (i in 1:length(atlas_info$value)) {
  
  if(!file.exists(paste0(atlas_info$roi_out[[i]], ".nii.gz"))){
    system(paste("fslmaths",  atlas, "-thr ",i," -uthr ",i," -bin", atlas_info$roi_out[[i]]))
  }
  if(!file.exists(paste0(atlas_info$roi_bin_out[[i]], ".nii.gz"))){
    system(paste("fslmaths", atlas_info$roi_out[[i]], "-mas", mean_FA_skeleton_mask, "-bin", atlas_info$roi_bin_out[[i]]))
  }
  # Overlap ROI und TBSS - binarize image
}


# extract info as timeseries from images per subject

for (i in 1:length(atlas_info$value)) {
  
  
  roinum = str_pad(i, 3, pad = "0")
  
  output_FA_meants = paste0(output_extraction_FA, "/FA_meants_", roinum, "_", atlas_info$roi[[i]], ".txt")
  output_FA_meanstats = paste0(output_extraction_FA, "/FA_meantstats_", roinum, "_", atlas_info$roi[[i]], ".txt")
 
  output_MD_meants = paste0(output_extraction_MD, "/MD_meants_", roinum, "_", atlas_info$roi[[i]], ".txt")
  output_MD_meanstats = paste0(output_extraction_MD, "/MD_meantstats_", roinum, "_", atlas_info$roi[[i]], ".txt")
  
  output_RD_meants = paste0(output_extraction_RD, "/RD_meants_", roinum, "_", atlas_info$roi[[i]], ".txt")
  output_RD_meanstats = paste0(output_extraction_RD, "/RD_meantstats_", roinum, "_", atlas_info$roi[[i]], ".txt")
  
  output_AD_meants = paste0(output_extraction_AD, "/AD_meants_", roinum, "_", atlas_info$roi[[i]], ".txt")
  output_AD_meanstats = paste0(output_extraction_AD, "/AD_meantstats_", roinum, "_", atlas_info$roi[[i]], ".txt")
  
   
  # FA
  if (!file.exists(output_FA_meants)) {
    system(paste("fslmeants -i", all_FA_skeletonised, 
                 " -m", atlas_info$roi_bin_out[[i]], 
                 " -o", output_FA_meants))
  }
  if (!file.exists(output_FA_meanstats)) {
    system(paste("fslstats -t", all_FA_skeletonised, 
                 " -k", atlas_info$roi_bin_out[[i]],
                 " -M -S | tee -a ", output_FA_meanstats))
  }
  
  # MD
  if (!file.exists(output_MD_meants)) {
    system(paste("fslmeants -i", all_MD_skeletonised, 
                 " -m", atlas_info$roi_bin_out[[i]], 
                 " -o", output_MD_meants))
  }
  if (!file.exists(output_MD_meanstats)) {
    system(paste("fslstats -t", all_MD_skeletonised, 
                 " -k", atlas_info$roi_bin_out[[i]],
                 " -M -S | tee -a ", output_MD_meanstats))
  }
  
  # RD
  if (!file.exists(output_RD_meants)) {
    system(paste("fslmeants -i", all_RD_skeletonised, 
                 " -m", atlas_info$roi_bin_out[[i]], 
                 " -o", output_RD_meants))
  }
  if (!file.exists(output_RD_meanstats)) {
    system(paste("fslstats -t", all_RD_skeletonised, 
                 " -k", atlas_info$roi_bin_out[[i]],
                 " -M -S | tee -a ", output_RD_meanstats))
  }
  
  # AD
  if (!file.exists(output_AD_meants)) {
    system(paste("fslmeants -i", all_AD_skeletonised, 
                 " -m", atlas_info$roi_bin_out[[i]], 
                 " -o", output_AD_meants))
  }
  if (!file.exists(output_AD_meanstats)) {
    system(paste("fslstats -t", all_AD_skeletonised, 
                 " -k", atlas_info$roi_bin_out[[i]],
                 " -M -S" ,
                 "| tee -a ", 
                 output_AD_meanstats))
  }

}






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


# read.table(merged_df$files[52], header = FALSE, col.names = c("mean", "sd"), row.names = c("1", "4"))