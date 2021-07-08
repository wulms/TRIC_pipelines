path_to_folder <- function(list_of_files) {
  paths_folder <- sub("[/][^/]+$", "", list_of_files)
  paths_folder <- unique(paths_folder)
  paths_folder <- paths_folder[!dir.exists(paths_folder)]
  lapply(paths_folder,
         dir.create,
         recursive = TRUE,
         showWarnings = FALSE)
}

initialize_parallel <- function(not_use = cores_not_to_use) {
  # Calculate the number of cores
  no_cores <- detectCores() - not_use
  
  # Initiate cluster
  cl <- makeCluster(no_cores, type = "FORK", outfile = "")
  
  registerDoParallel(cl)
  getDoParWorkers()
  return(cl)
}

dwi_fslroi <- function(input, output){
  command <- paste0("fslroi ", input, 
                    " ", output, " 0 1")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input)) %dopar% {
      
      path_to_folder(output[j])
      cat("\014")

      if(!file.exists(output[j])) {
        system("clear")
        system(command[j])
      }
    }
    stopCluster(cl)
    system("notify-send \"R script finished running\"")
}


dwi_fslmerge <- function(input1, input2, output){
  command <- paste0("fslmerge -t ", output,
                    " ", input1,
                    " ", input2)
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input1)) %dopar% {
    
    path_to_folder(output[j])
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}

dwi_topup <- function(input_APPA, input_acqparams, input_cnf, 
                      output_topup, output_field, output_hifib0){
  command <- paste0("topup --imain=", input_APPA, 
         " --datain=", input_acqparams, 
         " --config=", input_cnf, 
         " --out=", output_topup, 
         " --fout=", output_field, 
         " --iout=", output_hifib0, 
         " -v")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_APPA)) %dopar% {
    
    path_to_folder(output_topup[j])
    cat("\014")
    
    if(!file.exists(output_field[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


dwi_fslmaths <- function(input, output){
  command <- paste0("fslmaths ", input, 
                    " -Tmean ", output)
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input)) %dopar% {
    
    path_to_folder(input[j])
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


dwi_bet <- function(input, output){
  command <- paste0("bet ", input, 
                    " ", output,
                    " -m -f 0.2")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input)) %dopar% {
    
    path_to_folder(input[j])
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


dwi_eddy <- function(input_dwi, input_bet, input_index, input_acqparams, 
                     input_bvec, input_bval, input_topup, 
                     output){
  command <- paste0("eddy --imain=", input_dwi, 
                    " --mask=", input_bet, 
                    " --index=", input_index, 
                    " --acqp=", input_acqparams, 
                    " --bvecs=", input_bvec, 
                    " --bvals=", input_bval, 
                    " --fwhm=0 --topup=", input_topup, 
                    " --flm=quadratic --out=", output, 
                    " -v --repol")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  
  foreach(j = 1:length(input_dwi)) %dopar% {
    
    path_to_folder(output[j])
    cat("\014")
    
    if(!file.exists(paste0(output[j], ".nii.gz"))) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}

dwi_eddy_topup_off <- function(input_dwi, input_bet, input_index, input_acqparams, 
                     input_bvec, input_bval, #input_topup, 
                     output){
  command <- paste0("eddy --imain=", input_dwi, 
                    " --mask=", input_bet, 
                    " --index=", input_index, 
                    " --acqp=", input_acqparams, 
                    " --bvecs=", input_bvec, 
                    " --bvals=", input_bval, 
                    " --fwhm=0", # --topup=", input_topup, 
                    " --flm=quadratic --out=", output, 
                    " -v --repol")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_dwi)) %dopar% {
    
    path_to_folder(output[j])
    cat("\014")
    
    if(!file.exists(paste0(output[j], ".nii.gz"))) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


# time eddy_cuda8.0 \
# --imain=dwi_xc.nii.gz \
# --acqp=acqparams.txt \
# --index=index.txt \
# --mask=dwi_bse_mask.nii.gz \
# --bvecs=dwi_xc.bvec \
# --bvals=dwi_xc.bval \
# --out=dwi_eddy \
# --cnr_maps \
# --repol \
# --mporder=16 \
# --estimate_move_by_susceptibility \
# --verbose

dwi_eddy_cuda <- function(input_dwi, input_bet, input_index, input_acqparams, 
                     input_bvec, input_bval, input_topup, 
                     output){
  command <- paste0("eddy_cuda8.0 --imain=", input_dwi, 
                    " --mask=", input_bet, 
                    " --index=", input_index, 
                    " --acqp=", input_acqparams, 
                    " --bvecs=", input_bvec, 
                    " --bvals=", input_bval, 
                    " --fwhm=0 --topup=", input_topup, 
                    " --flm=quadratic --out=", output, 
                    " -v --repol --cnr_maps --mporder=16 --estimate_move_by_susceptibility")
  print(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_dwi)) %dopar% {
    
    path_to_folder(input_dwi[j])
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}

dwi_eddy_bidirect <- function(input_dwi, input_bet, input_index, input_acqparams, 
                     input_bvec, input_bval, input_topup, 
                     output){
  command <- paste0("eddy --imain=", input_dwi, 
                    " --mask=", input_bet, 
                    " --index=", input_index, 
                    " --acqp=", input_acqparams, 
                    " --bvecs=", input_bvec, 
                    " --bvals=", input_bval, 
                #    " --fwhm=0 --topup=", input_topup, 
                    " --flm=quadratic --out=", output, 
                    " -v --repol")
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_dwi)) %dopar% {
    
    path_to_folder(input_dwi[j])
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


dwi_eddy_qc_gif <- function(input){
  output_gif = str_replace(input, ".nii", ".gif") %>%
    str_replace("eddy", "eddy_qc")
  output_png = str_replace(input, ".nii", "%02d.png") %>%
    str_replace("eddy", "eddy_qc")
  output_folder <- sub("[/][^/]+$", "", output_png)
  
  path_to_folder(output_gif)
  
  cl <- initialize_parallel(not_use = cores_not_to_use)
  
  foreach(i = 1:length(input)) %dopar% {
    if(!file.exists(output_gif[i])){
      
      img <- readNIfTI(input[i], reorient = FALSE)
      png(file=output_png[i], width=200, height=200)
      
      for(j in 1:img@dim_[5]) {
        oro.nifti::image(robust_window(img),
                         z = 35,
                         w = j,
                         plot.type = "single")
        
      }
      dev.off()
      system(paste0("cd ", output_folder[i], " && convert -delay 8 *.png ", output_gif[i]))
    }
    file.remove(list.files(path = output_folder[i], pattern = ".png", full.names = TRUE))
    
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}


dwi_dtifit <- function(input_eddy, input_bet, input_bvec, input_bval, 
                       output){
  command <- paste0("dtifit ",
                    "-k ", input_eddy,
                    " -m ", input_bet,
                    " -r ", input_bvec,
                    " -b ", input_bval,
                    " -o ", output)
  path_to_folder(output9_fdt)
  head(command)
  
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_eddy)) %dopar% {
    
    
    cat("\014")
    
    if(!file.exists(output[j])) {
      system("clear")
      system(command[j])
    }
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
}

tbss_all <- function(input_directory, input_command){
  command <- paste0("cd ", input_directory, " && ", input_command)
  print(head(command))
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_command)) %dopar% {
  
  # path_to_folder(input_command[j])
  cat("\014")
    system(command[j])
}
stopCluster(cl)
system("notify-send \"R script finished running\"")
}


fsl_randomise <- function(input_directory, input_command){
  command <- paste0("cd ", input_directory, " && ", input_command)
  head(command)
  cl <- initialize_parallel(not_use = cores_not_to_use)
  foreach(j = 1:length(input_command)) %dopar% {
    
    path_to_folder(input_command[j])
    cat("\014")
    system(command[j])
  }
  stopCluster(cl)
  system("notify-send \"R script finished running\"")
  
}
