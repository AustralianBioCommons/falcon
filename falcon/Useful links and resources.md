#### how-to guide on de novo assemlby with long reads
https://youtu.be/poHozFha7mI

#### HGAP from PacBio 
https://github.com/PacificBiosciences/Bioinformatics-Training/wiki/HGAP-in-SMRT-Analysis

Both Falcon and HGAP use the same underlying method for their assembly. Falcon unzip was developed by PacBio as an extension to Falcon. It is intended to be used on the outputs from Falcon

#### how to download data from Oz Mammals
Register and log in. Go to 'Data portal' then 'Oz Mammals'. Search for the data you want (e.g PacBio Dunnart). When you have the files you want on the search page, click 'bulk download'. This will generate a zip folder with the files you need to download the data. There's a download.sh script, and a urls.txt file. when you run downloads.sh, it will give you instructions to set up you API key. do that (very easy) and then run downloads.sh again. This will download the data! 
