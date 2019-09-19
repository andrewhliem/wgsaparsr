library(lubridate)
library(stringr)
library(readr)
a <- read_csv("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/AA_chip_run_times_raw_only.txt", 
              col_names = FALSE)
a_1 <- read_table2("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/RUNTIME_stats/AA_chip_run_times_raw_only.txt", 
                   col_names = FALSE)
head(a); head(a_1)
colnames(a_1) = c("dayname", "month", "day", "time", "timezone", "year")
# A tibble: 6 x 1
    # X1                          
    # <chr>                       
    #   1 Fri Jun 21 21:51:33 UTC 2019
    # 2 Fri Jun 21 21:51:33 UTC 2019
    # 3 Fri Jun 21 21:51:39 UTC 2019
    # 4 Sat Jun 22 00:33:15 UTC 2019
    # 5 Sat Jun 22 00:40:14 UTC 2019
    # 6 Sat Jun 22 00:41:00 UTC 2019

# convert raw to lubridate format -----------------------------------------
head(a_1)
    # A tibble: 6 x 6
    # dayname   month   day time timezone  year
    # <chr> <chr> <dbl> <drtn>   <chr>    <dbl>
    # 1 Fri   Jun      21 21:51    UTC       2019
    # 2 Fri   Jun      21 21:51    UTC       2019
    # 3 Fri   Jun      21 21:51    UTC       2019
    # 4 Sat   Jun      22 00:33    UTC       2019
    # 5 Sat   Jun      22 00:40    UTC       2019
    # 6 Sat   Jun      22 00:41    UTC       2019
b_1 = str_c(a_1$day, a_1$month, a_1$year, a_1$time, sep = " ")
c_1 = dmy_hms(b_1) ##E.G. dmy_hms("1 Jan 2017 23:59:59")


# computing time ----------------------------------------------------------
  #I did this on EXCEL
Time_per_each_component <- read_csv("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/Time_per_each_component_SNV.csv", 
                                        comment = "#")
# [1] "step"                               "Raw"                               
  # [3] "Component_2"                        "Component"                         
  # [5] "Time_AA"                            "Raw_AA"                            
  # [7] "Converted_to_Minutes_AA"            "percent_AA"                        
  # [9] "Raw_clinvarsubset"                  "Converted_to_Minutes_clinvarsubset"
  # [11] "percent_clinvarsubset"              "Raw_full"                          
  # [13] "Converted_to_Minutes_full"          "percent_full"                      
  # 
  # 



# visualizing individually ------------------------------------------------


#sorted by descending order runtime AA
ggplot(Time_per_each_component, aes(x = reorder(Component, Converted_to_Minutes_AA), Converted_to_Minutes_AA, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,360), 
                     breaks = seq(0,360, 20)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)

#order by step in pipeline AA
ggplot(Time_per_each_component, aes(x = reorder(Component, -step), Converted_to_Minutes_AA, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,360), 
                     breaks = seq(0,360, 20)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)


# by percent --------------------------------------------------------------
  #AA
ggplot(Time_per_each_component, aes(x = reorder(Component, percent_AA), percent_AA, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)
ggplot(Time_per_each_component, aes(x = reorder(Component, -step), percent_AA, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)

  #clinvarsubset
ggplot(Time_per_each_component, aes(x = reorder(Component, percent_clinvarsubset), percent_clinvarsubset, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)
ggplot(Time_per_each_component, aes(x = reorder(Component, -step), percent_clinvarsubset, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)

#full
ggplot(Time_per_each_component, aes(x = reorder(Component, percent_full), percent_full, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)
ggplot(Time_per_each_component, aes(x = reorder(Component, -step), percent_full, fill = Component)) + 
  geom_col() +
  theme_bw() + 
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") + 
  labs(x = "", y = "time (minutes)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,50), 
                     breaks = seq(0,50, 10)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 60)

#analyzing in aggregate for percent (compute mean and std)
nm1 <- c('percent_AA', 'percent_full', 'percent_clinvarsubset')
Time_per_each_component <- Time_per_each_component %>% 
  dplyr::mutate(percent_MEAN = rowMeans(.[nm1], na.rm = TRUE),
                percent_SD = rowSds(as.matrix(.[nm1], na.rm = TRUE)))

ggplot(Time_per_each_component, aes(x=reorder(Component, -step), y=percent_MEAN, fill = Component)) +
  geom_bar(stat="identity") +
  geom_errorbar( aes(x=Component, ymin=percent_MEAN-percent_SD, ymax=percent_MEAN+percent_SD), width=0.4, colour="orange", alpha=0.9, size=1.3) +
  coord_flip() + 
  theme_bw() +
  labs(x = "", y = "Percent (%)") + 
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 30, hjust = 1)) + 
  scale_y_continuous(limits = c(0,25), 
                     breaks = seq(0,25, 2)) + 
  scale_fill_hue(l=40, c=35) + 
  geom_hline(yintercept = 10)



##################################################################################
##################################################################################
##################################################################################


# for clinvarsubset -------------------------------------------------------


a_1 <- read_table2("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/RUNTIME_stats/clinvarsubset_run_times_only_raw.txt", 
                   col_names = FALSE)
colnames(a_1) = c("dayname", "month", "day", "time", "timezone", "year")
b_1 = str_c(a_1$day, a_1$month, a_1$year, a_1$time, sep = " ")
c_1 = dmy_hms(b_1) ##E.G. dmy_hms("1 Jan 2017 23:59:59")
    #time computed on Excel
write.csv(c_1, "C:/Users/Andre/Documents/test.csv", quote=FALSE, row.names=FALSE)


# for full  -------------------------------------------------------
a_1 <- read_table2("D:/OneDrive - BOOZ ALLEN HAMILTON/Projects/MVP - GENISIS, Annotation/Projects/2019-06-03_wgsa/RUNTIME_stats/full_run_times_only_raw.txt", 
                   col_names = FALSE)
colnames(a_1) = c("dayname", "month", "day", "time", "timezone", "year")
b_1 = str_c(a_1$day, a_1$month, a_1$year, a_1$time, sep = " ")
c_1 = dmy_hms(b_1) ##E.G. dmy_hms("1 Jan 2017 23:59:59")
hea#time computed on Excel
write.csv(c_1, "C:/Users/Andre/Documents/test.csv", quote=FALSE, row.names=FALSE)
