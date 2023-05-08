require(tidyverse)
require(googledrive)
require(ncdf4)
require(cmocean)
require(ggpubr)



targetDays <- c(151,180);

for (ClimateMod in c('GFDL','HAD','IPSL')) {



# ncFiles <- list.files('C:\\BJORKSTEDT\\BigData\\HumboldtKrillClimateScenarios\\ROMS-GFDL',
#                       full.names = TRUE)
ncFiles <- list.files(paste0('C:/BJORKSTEDT/BigData/HumboldtKrillClimateScenarios/ROMS-',ClimateMod,'/'),
                      full.names = TRUE)
h_ncFile <- list.files('C:/BJORKSTEDT/BigData/HumboldtKrillClimateScenarios',
                       full.names = TRUE)[1]

# ncid <- nc_open(ncFiles[2])
# print(ncid)


convertToXLevels <- function(data,layerDepths,interpDepths) {
  newData <- array(NA,dim=c(length(interpDepths),dim(data)[2]))
  for (i in seq(dim(data)[2])) {
    newData[,i] <- spline(x=layerDepths,y=data[,i],xout=interpDepths, method='natural')$y
  }
   newData <- data.frame(day = rep(seq(dim(data)[2]),each=length(interpDepths)),
                         depth = rep(interpDepths,dim(data)[2]),
                         data = c(newData))
   return(newData)
}


extractScenario <- function(ncFile, h_ncFile,
                            interpDepths = -seq(10,250,5),
                            targetBathymetry = c(300, 1000),
                            targetDays = c(151,180), 
                            parameters = c('temp', 'oxygen', 'pH')) {
  
  year <- str_sub(ncFile,nchar(ncFile)-6,nchar(ncFile)-3) %>% 
    as.numeric()
  
  ncid <- nc_open(ncFile)
  s <- ncvar_get(ncid,'s_rho')
  lat <- ncvar_get(ncid,'lat_rho')
  lon <- ncvar_get(ncid,'lon_rho')
  h <- nc_open(h_ncFile) %>% 
    ncvar_get('h')
  
  targetGridCells <- which(h > min(targetBathymetry) & 
                             h < max(targetBathymetry),
                           arr.ind = TRUE)
  
  temp <- data.frame(day=NA,depth=NA,data=NA)
  gridcell <- oxygen <- pH <- temp <- temp[-1,]

  for (i in seq(dim(targetGridCells)[1])) {
    
    depth <- s * h[targetGridCells[1],targetGridCells[2]]
    junk <- ncvar_get(ncid,'temp',
                      c(targetGridCells[1],targetGridCells[2],1,targetDays[1]),
                      c(1,1,length(s),diff(targetDays))) %>% 
      convertToXLevels(depth,interpDepths)
    temp <- temp %>% bind_rows(junk)
    junk <- ncvar_get(ncid,'oxygen',
                      c(targetGridCells[1],targetGridCells[2],1,targetDays[1]),
                      c(1,1,length(s),diff(targetDays))) %>% 
      convertToXLevels(depth,interpDepths)
    oxygen <- oxygen %>% bind_rows(junk)    
    junk <- ncvar_get(ncid,'pH',
                      c(targetGridCells[1],targetGridCells[2],1,targetDays[1]),
                      c(1,1,length(s),diff(targetDays))) %>% 
      convertToXLevels(depth,interpDepths)
    pH <- pH %>% bind_rows(junk)    
    
    junk$data <- i
    gridcell <- gridcell %>% bind_rows(junk)    
    
  }

  names(gridcell)[3] <- 'cell'
  names(temp)[3] <- 'temp'
  names(oxygen)[3] <- 'oxygen'
  names(pH)[3] <- 'pH'
  
  gridcell <- gridcell %>% 
    dplyr::select(-day)%>% 
    dplyr::select(-depth)
  
  temp <- temp %>% bind_cols(gridcell) %>% relocate(cell)
  oxygen <- oxygen %>% bind_cols(gridcell) %>% relocate(cell)
  pH <- pH %>% bind_cols(gridcell) %>% relocate(cell)

  data <- temp %>%
    left_join(oxygen,by=c('cell','day','depth')) %>%
    left_join(pH,by=c('cell','day','depth'))
  
  data$day <- data$day + targetDays[1] - 1
  data$year <- year
  data <- data %>% dplyr::relocate(day) %>% dplyr::relocate(year)
  
  return(data)
  
}


ScenarioData <- data.frame(year = NA,
                           day = NA,
                           depth = NA,
                           temp = NA,
                           oxygen = NA,
                           pH = NA)
ScenarioData <- ScenarioData[-1,]


for (y in seq(length(ncFiles))) {

print(ncFiles[y])
  
z <-extractScenario(ncFile=,ncFiles[y], h_ncFile=h_ncFile, targetDays = targetDays) %>% 
  dplyr::group_by(depth) %>% 
  dplyr::summarize(year = mean(year),
                   day = mean(day),
                   temp = mean(temp),
                   oxygen = mean(oxygen),
                   pH = mean(pH)) %>% 
  dplyr::relocate(day)%>% 
  dplyr::relocate(year)

ScenarioData <- ScenarioData %>% 
  bind_rows(z)

}

write.csv(ScenarioData, file=paste0('DOY',targetDays[1],'-',targetDays[2],'-',ClimateMod,'.csv'))

}
