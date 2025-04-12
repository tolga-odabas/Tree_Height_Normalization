# Gerekli k??t??phaneleri y??kleme
library(lidR)
library(ggplot2)

# LAS dosyas??n?? y??kleme
las_file <- "G:/Doktora_Bitirme_TEZ/261124/ground-off-ground.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzc")

dtm_kriging <- rasterize_terrain(las, algorithm = kriging(k = 40))
nlas3 <- las - dtm_kriging


dtm_idw <- rasterize_terrain(las, res=0.3, algorithm = knnidw())
crs(dtm_idw) <- "EPSG:5258"
plot(dtm_idw, main="IDW ile Say??sal Arazi Modeli (DTM)")
writeRaster(dtm_idw, filename="G:/Doktora_Bitirme_TEZ/261124/nlas/dtm_idw.tif", filetype="GTiff", overwrite=TRUE)

dtm_tin <- rasterize_terrain(las, res=0.3, algorithm = tin())
crs(dtm_tin) <- "EPSG:5258"
plot(dtm_tin, main="TIN ile Say??sal Arazi Modeli (DTM)")
writeRaster(dtm_tin, filename="G:/Doktora_Bitirme_TEZ/261124/nlas/dtm_tin.tif", filetype="GTiff", overwrite=TRUE)

nlas <- las - dtm_tin
plot(nlas, main="IDW ile Kanopi Y??kseklik Modeli (KYM)", col = terrain.colors(50), legend.args = list(text = "Y??kseklik (m)", side = 4, line = 2.5))

# Verinin minimum ve maksimum y??kseklik de??erlerini kontrol et
z_range <- range(filter_ground(nlas)$Z, na.rm = TRUE)
print(z_range)  # Z'nin hangi aral??kta oldu??unu g??rmek i??in

# Histogram i??in breaks de??erini dinamik olarak ayarla
hist(filter_ground(nlas)$Z, 
     breaks = seq(z_range[1], z_range[2], length.out = 50),  # Otomatik break aral??????
     main = "Z Ekseni Histogram??", 
     xlab = "Elevation")

nlas <- normalize_height(las, knnidw())


nlas1 <- normalize_height(las, knnidw())
hist(filter_ground(nlas1)$Z, breaks = seq(-0.6, 0.6, 0.01), main = "", xlab = "Elevation")

nlas2 <- normalize_height(las, tin())
hist(filter_ground(nlas2)$Z, breaks = seq(-0.6, 0.6, 0.01), main = "", xlab = "Elevation")

nlas3 <- normalize_height(las, kriging())

output_path <- "G:/Doktora_Bitirme_TEZ/261124/nlas/nlas_kriging2.las"
writeLAS(nlas3, output_path)


# LAS dosyas??n?? y??kleme
las_file <- "G:/Doktora_Bitirme_TEZ/261124/nlas/nlas_colab/nlas-idw_R.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzc")
hist(filter_ground(las)$Z, main = "Zemin Noktalar??n??n Yukseklik Grafi??i", xlab = "Elevation")


las_file <- "G:/Doktora_Bitirme_TEZ/261124/nlas/nlas_colab/nlas-tin_R.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzc")
hist(filter_ground(las)$Z, main = "", xlab = "Elevation")


las_file <- "G:/Doktora_Bitirme_TEZ/261124/nlas/nlas_colab/nlas_knnidw_R.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzc")
hist(filter_ground(las)$Z, main = "Zemin Noktalar??n??n Yukseklik Grafi??i", xlab = "Elevation")


las_file <- "G:/Doktora_Bitirme_TEZ/261124/nlas/nlas_colab/nlas_tin_R.las"  # LAS dosyas??n??n yolu
las <- readLAS(las_file, select = "xyzc")
hist(filter_ground(las)$Z, main = "", xlab = "Elevation")
