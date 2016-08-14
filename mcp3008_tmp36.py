#!/usr/bin/python
#--------------------------------------   
# This script reads data from a 
# MCP3008 ADC device using the SPI bus.
#
# Author : Valliappan
# Date   : 14/04/2016
#
# http://www.raspberrypi-spy.co.uk/
#
#--------------------------------------

import spidev
import time
import os
import array
import pylab as pl
ECG_volts=[]
# Open SPI bus
spi = spidev.SpiDev()
spi.open(0,0)

# Function to read SPI data from MCP3008 chip
# Channel must be an integer 0-7
def ReadChannel(channel):
  adc = spi.xfer2([1,(8+channel)<<4,0])
  data = ((adc[1]&3) << 8) + adc[2]
  return data

# Function to convert data to voltage level,
# rounded to specified number of decimal places. 
def ConvertVolts(data,places):
  volts = (data * 3.3) / float(1023)
  volts = round(volts,places)  
  return volts
  
# Function to calculate temperature from
# TMP36 data, rounded to specified
# number of decimal places.
def ConvertTemp(data,places):

  # ADC Value
  # (approx)  Temp  Volts
  #    0      -50    0.00
  #   78      -25    0.25
  #  155        0    0.50
  #  233       25    0.75
  #  310       50    1.00
  #  388       75    1.25
  #  465      100    1.50
  #  543      125    1.75
  #  620      150    2.00
  #  698      175    2.25
  #  775      200    2.50
  #  853      225    2.75
  #  930      250    3.00
  # 1008      275    3.25
  # 1023      280    3.30

  temp = ((data * 330)/float(1023))-50
  temp = round(temp,places)
  return temp
  
# Define sensor channels
ECG_channel = 0


# Define delay between readings
delay = 0.01
i = 0
while i<600:

  # Read the light sensor data
  ECG_level = ReadChannel(ECG_channel)
  ECG_volts.append(ConvertVolts(ECG_level,2))
 
  # Read the temperature sensor data
  #temp_level = ReadChannel(temp_channel)
  #temp_volts = ConvertVolts(temp_level,2)
  #temp       = ConvertTemp(temp_level,2)

  # Print out results
  print "--------------------------------------------"  
  print("ECG_volts : {} ({}V)".format(i,ECG_volts[i]))  
  #print("Temp  : {} ({}V) {} deg C".format(temp_level,temp_volts,temp))    
  i=i+1
  # Wait before repeating loop
  time.sleep(delay)
pl.plot(ECG_volts,label="ECG")
pl.legend()
pl.show()

