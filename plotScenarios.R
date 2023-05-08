require(tidyverse)
require(cmocean)
require(mgcv)
require(ggpubr)

gfdl <- read.csv('DOY151-180-GFDL.csv') %>% 
  dplyr::select(-X)
hadl <- read.csv('DOY151-180-HAD.csv') %>% 
  dplyr::select(-X)
ipsl <- read.csv('DOY151-180-IPSL.csv') %>% 
  dplyr::select(-X)

all <- gfdl %>% 
  bind_rows(hadl) %>% 
  bind_rows(ipsl) %>% 
  group_by(year, depth) %>% 
  summarize_all(mean)


ggplot(hadl) + geom_point(aes(x=year,y=depth,color=temp)) + scale_color_cmocean()


deep <- 200
shal <- 20

tempPlot <- ggplot() +
  geom_smooth(data=dplyr::filter(gfdl,depth==-deep), 
            aes(x=year,y=temp),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-deep), 
            aes(x=year,y=temp),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-deep), 
            aes(x=year,y=temp),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(gfdl,depth==-shal), 
            aes(x=year,y=temp),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-shal), 
            aes(x=year,y=temp),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-shal), 
            aes(x=year,y=temp),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(all,depth==-deep), 
              aes(x=year,y=temp),color='black',size=2,alpha=0.5) +
  geom_smooth(data=dplyr::filter(all,depth==-shal), 
              aes(x=year,y=temp),color='black',size=2,alpha=0.5) 

oxyPlot <- ggplot() +
  geom_smooth(data=dplyr::filter(gfdl,depth==-deep), 
            aes(x=year,y=oxygen),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-deep), 
            aes(x=year,y=oxygen),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-deep), 
            aes(x=year,y=oxygen),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(all,depth==-deep), 
              aes(x=year,y=oxygen),color='black') +
  geom_smooth(data=dplyr::filter(gfdl,depth==-shal), 
            aes(x=year,y=oxygen),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-shal), 
            aes(x=year,y=oxygen),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-shal), 
            aes(x=year,y=oxygen),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(all,depth==-deep), 
              aes(x=year,y=oxygen),color='black',size=2,alpha=0.5) +
  geom_smooth(data=dplyr::filter(all,depth==-shal), 
              aes(x=year,y=oxygen),color='black',size=2,alpha=0.5) 

acidPlot <- ggplot() +
  geom_smooth(data=dplyr::filter(gfdl,depth==-deep), 
              aes(x=year,y=pH),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-deep), 
              aes(x=year,y=pH),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-deep), 
              aes(x=year,y=pH),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(all,depth==-deep), 
              aes(x=year,y=pH),color='black') +
  geom_smooth(data=dplyr::filter(gfdl,depth==-shal), 
              aes(x=year,y=pH),color='red',fill='red',alpha=0.2) +
  geom_smooth(data=dplyr::filter(hadl,depth==-shal), 
              aes(x=year,y=pH),color='blue',fill='blue',alpha=0.2) +
  geom_smooth(data=dplyr::filter(ipsl,depth==-shal), 
              aes(x=year,y=pH),color='green',fill='green',alpha=0.2) +
  geom_smooth(data=dplyr::filter(all,depth==-deep), 
              aes(x=year,y=pH),color='black',size=2,alpha=0.5) +
  geom_smooth(data=dplyr::filter(all,depth==-shal), 
              aes(x=year,y=pH),color='black',size=2,alpha=0.5) 

ggarrange(tempPlot, oxyPlot, acidPlot,
          nrow=1,ncol=3,align='h') %>% 
  print()
