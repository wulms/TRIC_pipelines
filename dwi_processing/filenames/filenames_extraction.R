#! /bin/bash
# preproc for roinum in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 ; do
# Extraction of all ROIs from ATLAS
# 
# fslmaths /usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz -thr $roinum -uthr $roinum -bin roimask
# fslmaths roimask -mas mean_FA_skeleton_mask.nii.gz -bin
# roimask
# padroi=`$FSLDIR/bin/zeropad $roinum 3`
# fslmeants -i all_FA_skeletonised.nii.gz -m roimask -o meants_roi${padroi}.txt done

# (1)
# fslmaths JHU-ICBM-labels-1mm.nii.gz -thr 42 -uthr 42 l_slf.nii.gz
# fslmaths l_slf.nii.gz -mas mean_FA_skeleton_mask.nii.gz -bin l_slfmask.nii.gz
# fslmeants -i all_FA_skeletonised.nii.gz -o FA_l_slf_mean.txt -m l_slfmask.nii.gz
# fslstats -t all_FA_skeletonised.nii.gz -k l_slf.nii.gz -M -S | tee -a FA_l_slf_mean.txt



# extraction filenames
output_extraction <- paste0(output_BIDS, "/5_extraction")
output_extraction_ROI <- paste0(output_extraction, "/ROI")
# filenames - output
output_extraction_FA <- paste0(output_extraction, "/FA")
output_extraction_MD <- paste0(output_extraction, "/MD")
output_extraction_RD <- paste0(output_extraction, "/RD")
output_extraction_AD <- paste0(output_extraction, "/AD")

mean_FA_skeleton_mask <- paste0(output_tbss_nonfa, "/stats/mean_FA_skeleton_mask")

all_FA_skeletonised <- paste0(output_tbss_nonfa, "/stats/all_FA_skeletonised")
all_MD_skeletonised <- paste0(output_tbss_nonfa, "/stats/all_MD_skeletonised")
all_RD_skeletonised <- paste0(output_tbss_nonfa, "/stats/all_RD_skeletonised")
all_AD_skeletonised <- paste0(output_tbss_nonfa, "/stats/all_AD_skeletonised")



