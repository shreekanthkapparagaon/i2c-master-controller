# I2C Master Controller Architecture

## Overview

The I2C Master Controller is divided into independent modules to improve
reusability, verification, and maintainability.

```
                +------------------+
                |   i2c_master     |
                +--------+---------+
                         |
      +------------------+------------------+
      |                                     |
+-----v------+                    +---------v--------+
| Clock      |                    | Transaction FSM  |
| Divider    |                    +---------+--------+
+-----+------+                              |
      | Tick                                |
      |                                     |
      +----------------+--------------------+
                       |
               +-------v--------+
               | Shift Engine   |
               +-------+--------+
                       |
               +-------v--------+
               | Open Drain I/O |
               +-------+--------+
                       |
                  SDA / SCL
```

## Modules

### Clock Divider

Generates timing pulses for the controller.

### Transaction FSM

Controls:

- START
- STOP
- Read
- Write
- ACK/NACK
- Multi-byte transfers

### Shift Engine

Handles serial transmission and reception of data bits.

### Open Drain Driver

Implements the open-drain behavior required by the I2C bus.

## Design Goals

- Fully synthesizable
- Parameterized clock frequency
- Standard Mode (100 kHz)
- Extendable to Fast Mode (400 kHz)
- Modular RTL