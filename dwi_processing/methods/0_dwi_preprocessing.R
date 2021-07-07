dwi_fslroi(dwi_images, output1_AP_blip)


if (topup == "on") {
  
  dwi_fslroi(dwi_b0_images, output2_PA_blip)

  dwi_fslmerge(input1 = output1_AP_blip,
               input2 = output2_PA_blip,
               output = output3_AP_PA_blips)
  
  dwi_topup(input_APPA = output3_AP_PA_blips,
            input_acqparams = acqparams,
            input_cnf = b02b0_cnf,
            output_topup = output4_topup,
            output_field = output5_field,
            output_hifib0 = output6_hifi_b0)
  
  dwi_fslmaths(input = output6_AP_blip,
               output = output6_AP_blip_tmean)
  
  dwi_bet(input = output6_AP_blip_tmean,
          output = output7_bet) 
  
  
} else if (topup == "off") {
  
  dwi_fslmaths(input = output1_AP_blip,
               output = output6_AP_blip_tmean)
  
  dwi_bet(input = output6_AP_blip_tmean,
          output = output7_bet) 
}



