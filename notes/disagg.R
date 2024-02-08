#alternative way to read and clean liu.  Trying to figure out why there are no zeroes
library(terra)
library(targets)
library(sf)
tar_load(esa_agb)
file <- "data/rasters/Liu/Aboveground_Carbon_1993_2012.nc"

liu_raw <- rast(file)
nlyr(liu_raw) #20 layers of years, 21st layer is somethign about data quality
plot(liu_raw[[21]])
#lets just get rid of that for now
liu_raw <- liu_raw[[1:20]]

#need to flip
liu_flipped <- rev(trans(liu_raw))
ext(liu_raw)
ext(liu_flipped)
ext(rev(liu_flipped[[1]]))
plot(liu_flipped[[1]])

ext(liu_flipped) <- c(-180, 180, -90, 90) #lol, this doesn't seem like it should work
liu_flipped <- flip(liu_flipped)


#set crs manually
crs(liu_flipped) <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
liu_flipped

plot(liu_flipped[[18]])

#get just 2010
liu_2010 <- liu_flipped[[18]]
liu_2010

plot(liu_2010 == 0)

#crop early for testing purposes
az_sf <- 
  maps::map("state", "arizona", plot = FALSE, fill = TRUE) |> 
  st_as_sf() |> 
  st_transform(crs(liu_2010))

liu_az <- crop(liu_2010, az_sf, mask = TRUE)

liu_az 

# multiply by 2.2

liu_az <- liu_az * 2.2
min(values(liu_az)[!is.na(values(liu_az))])

#TODO project to ESA
liu_az_proj <- liu_az |>
  project(esa_agb, method = "cubicspline")

# bilinear gives a min of 9.5
# cubic gives a min of -11.32
# cubicspline gives a min of 9.8
# lanczos gives a min of -30.6
plot(liu_az_proj)
plot(liu_az)

#try disagg() instead?
liu_proj <- project(liu_2010, crs(esa_agb))
liu_proj

res(liu_2010) / 
res(esa_agb)
plot(liu_proj[[1]])
plot(esa_agb[[1]])

liu_disagg <- disagg(liu_proj, fact = 280, method = "near")
plot(liu_disagg)
res(liu_disagg)
liu_disagg
#TODO crop to AZ

tar_read(esa_agb)
