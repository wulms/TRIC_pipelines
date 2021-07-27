[![DOI](https://zenodo.org/badge/284987410.svg)](https://zenodo.org/badge/latestdoi/284987410)


Common errors:

Depending on your FSL version, after Eddy the tbss pipeline can wield some errors based on the chaotic renaming of files to FA or otherwise.

FSL 6.0.3. the files need to end on "_fdt.nii.gz". In other FSL versions, they need to end on "_fdt_FA.nii.gz", even if they are MD, RD, or AD....

Then you need to edit the argument "end_on_fdt". Turn it "on" or "off".