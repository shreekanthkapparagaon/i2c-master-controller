# Transaction State Machine

## Planned States

```
IDLE
 ↓
START
 ↓
SEND_ADDRESS
 ↓
ADDRESS_ACK
 ↓
WRITE_DATA / READ_DATA
 ↓
DATA_ACK
 ↓
STOP
 ↓
DONE
```

## State Description

### IDLE

Wait for the start signal.

### START

Generate the START condition.

### SEND_ADDRESS

Transmit the 7-bit slave address and R/W bit.

### ADDRESS_ACK

Sample the ACK bit from the slave.

### WRITE_DATA

Transmit one data byte.

### READ_DATA

Receive one data byte.

### DATA_ACK

Transmit or receive ACK/NACK.

### STOP

Generate the STOP condition.

### DONE

Assert the done signal and return to IDLE.