# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by Keep a Changelog and the project follows Semantic Versioning.

---

## [v0.3.0] - 2026-07-15

### Added

- Moore Finite State Machine (FSM) framework.
- Separate state register and next-state logic.
- Self-checking verification environment.
- Automatic PASS / FAIL test reporting.
- FSM state transition monitoring.

### Changed

- Refactored controller from a single-process FSM to a two-process Moore FSM.
- Integrated the clock divider with the FSM.
- Testbench overrides clock parameters for faster simulation.

### Tested

- Reset sequence.
- IDLE state.
- START state.
- DONE state.
- Busy signal.
- Done signal.
- Clock-divider driven FSM operation.

### Notes

- SDA and SCL currently use placeholder assignments.
- START/STOP signal generation will be implemented in **v0.4.0**.
- Address transmission and ACK/NACK handling are not yet implemented.

---

## [v0.2.0] - 2026-07-15

### Added
- Initial top-level `i2c_master` module.
- Configurable clock divider module.
- Basic top-level testbench.
- Clock divider testbench.
- Project version tagged as `v0.2.0`.

### Changed
- Established the initial project architecture for the I2C Master Controller.

### Tested
- Clock divider simulation using Icarus Verilog.
- Waveform verification using GTKWave.

### Notes
- This version provides the project foundation.
- No complete I2C transactions are supported yet.

---

## [v0.1.0] - 2026-07-14

### Added
- Initial project structure.
- RTL, testbench, documentation, scripts, and waveform directories.
- README.
- LICENSE.
- `.gitignore`.

### Notes
- Initial repository setup.