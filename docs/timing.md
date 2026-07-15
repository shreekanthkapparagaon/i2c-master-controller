# I2C Timing

## Bus Signals

- SDA : Serial Data
- SCL : Serial Clock

## START Condition

SDA transitions HIGH → LOW while SCL is HIGH.

## STOP Condition

SDA transitions LOW → HIGH while SCL is HIGH.

## Data Transfer

- Data changes while SCL is LOW.
- Data is sampled while SCL is HIGH.

## ACK

The receiver drives SDA LOW during the ninth clock pulse.

## NACK

The receiver leaves SDA HIGH during the ninth clock pulse.