********************************************************
  # The Goal of this Kernel is to analyze the bitcoin close price 
  # predict a 14 day forecast 
  
  
  ******************************************************
  
library(tidyverse)
library(forecast)
library(aTSA)

#******************************************************************
#reading csv file  The data is big and lot of Nan
#**************************************************************
data=read.csv(choose.files())
dim(data)

# dim(data)
# [1] 4857377       8
# > 

glimpse(data)


# > glimpse(data)
# Rows: 4,857,377
# Columns: 8
# $ Timestamp         <int> 1325317920, 1325317980, 1325318040, 1325318100, 1325318160, 1325~
#   $ Open              <dbl> 4.39, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~
#   $ High              <dbl> 4.39, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~
#   $ Low               <dbl> 4.39, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~
#   $ Close             <dbl> 4.39, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~
#   $ Volume_.BTC.      <dbl> 0.4555809, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~
#   $ Volume_.Currency. <dbl> 2, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, N~
#   $ Weighted_Price    <dbl> 4.39, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN~


# *************************************************************
# Best practice is to convert orginal into new object so we donot change any variable 
# **************************************************************


df=data


# ***********************************
# stripping time 1325317920  to date format 

# ************************************

df$date<- strptime(as.POSIXct(df$Timestamp,origin="1970-01-01 00:00.00"),"%Y-%m-%d")
