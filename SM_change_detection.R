

library(raster)
library(rgdal)

files <- Sys.glob('/home/satyukt/Projects/1001/IMPRINT/sm_change_detection/out/tif_file/*.tif')

stack.file <- stack(files)

#ras.temp[ras.temp < 20] <- 0  #How you will change all the values in a raster ?

max.file <- max(stack.file, na.rm = T)
min.file <- min(stack.file, na.rm = T)


# Lopp through file
  # read the file as raster and apply sm formula

out.path <- '/home/satyukt/Projects/1001/IMPRINT/sm_change_detection/out/Soil_moisture/'

for (file in files){
  #print(file)
  out.sm.file <- file.path(out.path,  substr( basename(file),18,25))
  out.sm.file <- sprintf('%s_sm.tif',out.sm.file)
  if(!file.exists(out.sm.file)){
  
    input.ras <- raster(file)
    #urban mask
    input.ras[input.ras > -6] <- NA
    #water_mask
    input.ras[input.ras < -17] <- NA
    
    subtract.file = max.file - min.file
    correctedStartValue = input.ras - min.file
    sm = (correctedStartValue * 100) / subtract.file
    
    writeRaster(sm,out.sm.file)
    print(out.sm.file)
  }
}



