*******************************************************
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
# stripping time 1325317920  to
# date format  by giving origin date and time to format we need

# ************************************

df$date<- strptime(as.POSIXct(df$Timestamp,origin="1970-01-01 00:00.00"),"%Y-%m-%d")


  # ***********************************
  # convert date as factor 
  # ************************************

df$date=as.factor(df$date)
# ******************************************************
# Creating new data to focus on Close prices per day
# **********************************************
df_close=df %>% 
  group_by(date) %>% 
  summarise(Close=mean(Close,na.rm=T))

df_close$date <- as.Date(df_close$date)
df_close <- as.data.frame(df_close)

row.names(df_close) <- df_close$date

plot(df_close, ylab="Close Price Bitcoin", type="l")


# removing days for future prediction
forecast_time=14
df_input <- head(df_close, -forecast_time)
df_test <- tail(df_close, forecast_time)

# Creating time series for modeling and future comparing of prediction

input_ts <- ts(df_input$Close,start=c(2012,01,01),frequency=365)
test_ts <- ts(df_test$Close,start=end(input_ts)+c(0,1),frequency=365)

# Modeling Holt-Winter
input_ts.hw <- HoltWinters(input_ts, seasonal = "add")
input_ts.hw
# Modeling auto arimar
input_ts.arima <- auto.arima(input_ts, seasonal = T,approximation=F,stepwise=F)

input_ts.arima

# Using arima model ARIMA(2,2,3) 
bitforc=forecast::forecast(input_ts.arima,h=14)
bitforc
summary(bitforc)
bitforchw=forecast::forecast(input_ts.hw,h=14)
summary(bitforchw)

plot(bitforc)
plot(bitforchw,start="2021-03-01")
autoplot(bitforchw,start="2021-03-01")


