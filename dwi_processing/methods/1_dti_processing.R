if (topup == "on") {
  dwi_eddy(input_dwi = dwi_images, 
           input_bet = output7_bet, 
           input_index = index,
           input_acqparams = acqparams,
           input_bvec = dwi_bvec,
           input_bval = dwi_bval,
           input_topup = output4_topup,
           output = output8_eddy_unwarped)
  
} else if (topup == "off"){
  dwi_eddy_topup_off(input_dwi = dwi_images, 
           input_bet = output7_bet, 
           input_index = index,
           input_acqparams = acqparams,
           input_bvec = dwi_bvec,
           input_bval = dwi_bval,
           # input_topup = output4_topup,
           output = output8_eddy_unwarped)
}




# alternative using CUDA!

# dwi_eddy_cuda(input_dwi = dwi_images, 
#          input_bet = output7_bet, 
#          input_index = index,
#          input_acqparams = acqparams,
#          input_bvec = dwi_bvec,
#          input_bval = dwi_bval,
#          input_topup = output4_topup,
#          output = output8_eddy_cuda)

# BET
output9_eddy_maske <- str_replace(output8_eddy_unwarped_nii, ".nii", "_bet.nii")

dwi_bet(input = output8_eddy_unwarped,
        output = output9_eddy_maske)

# QC
dwi_eddy_qc_gif(output8_eddy_unwarped_nii) # this works


# DTIfit
# eddy normal
dwi_dtifit(input_eddy = output8_eddy_unwarped,
           input_bet = output9_eddy_maske,
           input_bvec = dwi_bvec,
           input_bval = dwi_bval,
           output = output9_fdt)