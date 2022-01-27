setwd("C:/Users/USER/R studio/Flying")

#access data
data(World)

ggplot(data = World) +
  theme_void()+
  theme(panel.grid = element_line(color = "slategray1", size= .25))+
  geom_sf(fill = "olivedrab", size= .25, col = "grey80") +
  coord_sf(crs = "+proj=laea +lat_0=35 +lon_0=25 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")

fly <- tibble(x = 0, y = 50)
fly_sf <- st_as_sf(fly, coords = c("x", "y"), crs = 4326)

# firts frame
ggplot(data = World) +
  theme_void()+
  theme(panel.grid = element_line(color = "slategray1", size= .25))+
  geom_sf(fill = "olivedrab", size= .25, col = "grey80") +
  geom_sf(data= fly_sf, col = "red", size= 2)+
  coord_sf(crs = "+proj=laea +lat_0=35 +lon_0=25 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")


#create 360 frames
for(i in 1: 360){
  if (nchar(i) == 1){
    prefix <- "00"
  }else if (nchar(i) == 2){
    prefix <- "0"
  }else{
    prefix <- NA
  }
  fly <- tibble(x = 0 + i, y = 50)
  fly_sf <- st_as_sf(fly, coords = c("x", "y"), crs = 4326)
  ggplot(data = World) +
    theme_void()+
    theme(panel.grid = element_line(color = "slategray1", size= .25))+
    geom_sf(fill = "olivedrab", size= .25, col = "grey80") +
    geom_sf(data= fly_sf, col = "red", size= 2)+
    coord_sf(crs = "+proj=laea +lat_0=35 +lon_0=25 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")
  frame_name <- paste0("airplane_",prefix, i , ".png")
  ggsave(filename = frame_name, dpi = 200, height = 3, width = 4.5) 
}

list.files(pattern = "airplane_") %>% 
  map(image_read) %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps = 25) %>% # create animation
  image_write("Earth_UFO.gif") # write to current dir


