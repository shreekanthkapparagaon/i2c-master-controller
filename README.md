# I2C Master Controller

![License](https://img.shields.io/github/license/shreekanthkapparagaon/i2c-master-controller?style=for-the-badge) 
![Version](https://img.shields.io/github/v/tag/shreekanthkapparagaon/i2c-master-controller?style=for-the-badge)
![Language](https://img.shields.io/github/languages/top/shreekanthkapparagaon/i2c-master-controller?style=for-the-badge)
![Build](https://img.shields.io/badge/Simulation-Icarus%20Verilog-blue?style=for-the-badge)

A synthesizable **I2C Master Controller** written in Verilog with a complete verification environment using **Icarus Verilog** and **GTKWave**.

---

## Features

### Current

- Parameterized Clock Divider
- Top-Level I2C Master Interface
- Moore FSM Architecture
- Integrated Clock Divider with FSM
- Open-Drain SDA Interface
- START Condition Generation
- START_HOLD State
- SCL_LOW State
- Address Loading Framework
- Address Transmission Framework
- Datapath Separation (FSM + Datapath)
- Self-checking Verification Environment
- 22 Automated Functional Tests
- Project Documentation

### Planned

- Address Bit Transmission Engine
- ACK / NACK Detection
- STOP Condition Generation
- Single-byte Write
- Single-byte Read
- Multi-byte Transfer
- Protocol-level Verification

---

## Project Structure

```text
i2c-master-controller/
├── docs/
│   ├── architecture.md
│   ├── state_machine.md
│   └── timing.md
│
├── rtl/
│   ├── clock_divider.v
│   └── i2c_master.v
│
├── tb/
│   ├── tb_clock_divider.v
│   └── tb_i2c_master.v
│
├── scripts/
│
├── wave/
│
├── CHANGELOG.md
├── LICENSE
├── README.md
└── .gitignore
```

---

## Architecture

For detailed design information, see:

* `docs/architecture.md`
* `docs/state_machine.md`
* `docs/timing.md`

---

## Current FSM

```text

IDLE
 ↓
START
 ↓
START_HOLD
 ↓
SCL_LOW
 ↓
LOAD_ADDRESS
 ↓
SEND_ADDRESS
 ↓
DONE
 ↓
IDLE

```

## Development Roadmap

| Version | Status | Description |
| ------- | :----: | ------------------------------------------------------------ |
| v0.1.0 | ✅ | Initial project structure |
| v0.2.0 | ✅ | Top-level interface and programmable clock divider |
| v0.3.0 | ✅ | Moore FSM framework |
| v0.4.0 | ✅ | Bus engine, START generation, address loading framework |
| v0.5.0 | ⏳ | Address bit transmission engine |
| v0.6.0 | ⏳ | ACK / NACK handling |
| v0.7.0 | ⏳ | Single-byte read/write |
| v0.8.0 | ⏳ | Multi-byte transfer |
| v0.9.0 | ⏳ | Protocol-level verification |

---

## Simulation

Compile:

```bash
iverilog -Wall -o sim \
rtl/clock_divider.v \
rtl/i2c_master.v \
tb/tb_i2c_master.v
```

Run:

```bash
vvp sim
```

Open GTKWave:

```bash
gtkwave wave/i2c_master.vcd
```

> **Note:** During simulation, the testbench overrides `CLK_FREQ` and `I2C_FREQ` with smaller values to accelerate verification. The synthesized design continues to use the default parameters (50 MHz system clock and 100 kHz I²C bus).

---
## Verification Status

Current simulation results:

```text
======================================
Total Tests : 22
Passed      : 22
Failed      : 0
RESULT      : PASS
======================================
```

The verification environment includes automated checks for:

- Reset sequence
- FSM state transitions
- Busy signal
- Done signal
- START condition timing
- SCL_LOW timing
- Address loading
- Address transmission framework

--- 

## Tools

* Verilog (IEEE 1364)
* Icarus Verilog
* GTKWave
* Git
* GitHub

---

## Documentation

The project includes detailed design documentation:

- Architecture — Overall module organization.
- FSM Framework — Moore finite state machine implementation.
- State Machine — Transaction state flow.
- Timing — I²C timing diagrams using WaveDrom.

---

## Changelog

See `CHANGELOG.md` for the complete version history.

---

## License

This project is licensed under the MIT License.
