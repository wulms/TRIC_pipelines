# TBSS processing

#dtifit -k data -m nodif_brain_mask -r bvecs -b bvals -o dti
# Add L2 and L3 together and divide by two to create a measure of 
# radial (perpendicular) diffusivity 
# fslmaths ${dir}/FDT/${sub}\_L2.nii.gz -add ${dir}/FDT/${sub}\_L3.nii.gz -div 2\
#${dir}/FDT/${sub}\_L23.nii.gz \# Re-orientate the FA map to standard space 
# note that you aren't resampling, just spinning it around a bit.
#fslreorient2std ${dir}/TBSS/${sub}\_FA.nii.gz ${dir}/TBSS/${sub}\_FA.nii.gz \# fslreorient2std sub-001_T1w sub-001_T1w_reoriented

# create folder
path_to_folder(FA_out)

# copy files
file.copy(FA, FA_out)


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


