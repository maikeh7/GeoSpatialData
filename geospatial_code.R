library(ggmap)
#you will need your own Google key!
register_google(key = "XXXXXXXXXXXXX")


boise = c(lon = -116.2023, lat = 43.615)

# Get map at zoom level 5: map_5
map_5 = get_map(boise, zoom = 5, scale = 1)

# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
boise_map = get_map(boise, zoom = 15, scale = 1)
ggmap(boise_map)

boise_map <- get_map(boise, zoom = 15, scale = 1, maptype = "satellite")
ggmap(boise_map)

#map of corvallis, OR
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Add a maptype argument to get a satellite map
corvallis_map_sat <- get_map(corvallis, zoom = 13)

sales = readRDS("01_corv_sales.rds")
head(sales)
# Add the points and color by year_built
ggmap(corvallis_map_sat) +
  geom_point(aes(lon, lat, color = year_built), data = sales)

wards = readRDS("01_corv_wards.rds")
head(wards)
ggplot(wards, aes(lon, lat)) +
  geom_polygon(aes(group = group, fill = ward))

corvallis_map_bw = get_map(corvallis, zoom = 12, maptype = "toner")
ggmap(corvallis_map_bw, 
      base_layer = ggplot(wards, aes(lon, lat)),
      extent = "normal", maprange = FALSE) +
  geom_polygon(aes(group = group, fill = ward))


library(raster)
library(sp)
counties = shapefile("tl_2013_16_cousub.shp")
#let's say we only want to plot some of the counties
idnames = as.character(0:25)
#need to fortify counties, creates a data.frame
f = fortify(counties)
#extract only the names we specified
f2  = filter(f, id %in% idnames)
ggmap(map_5) + 
  geom_polygon(data = f2,
               aes(long, lat, group = group, fill = id)) +
  theme(legend.position="none")

#read in raster
pop = raster("Pop.img")

spplot(mypop, xlab = "Lat", ylab = "Lon", col.regions = topo.colors(100))

#crop raster
extent(mypop)
extent(-74.758, -71.556, 43.39, 45.861)
new_extent = c(-75, -72, 37, 42)
mypop_crop = crop(mypop, new_extent)
spplot(mypop_crop)


library(fields)
data(ozone2)
out<- rdist.earth ( ozone2$lon.lat)
head(out)
#out is a 153X153 distance matrix
upper<-  col(out)> row( out)
upper
# histogram of all pairwise distances. 
hist( out[upper])

#get pairwise distances between first 10 and second 10 lon/lat points
x1 = ozone2$lon.lat[1:10,]
class(ozone2$lon.lat)
x2 = ozone2$lon.lat[11:20,]
dists = rdist.earth.vec(x1, x2)
print(dists)
