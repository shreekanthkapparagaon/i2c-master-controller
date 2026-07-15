# I2C Timing Diagrams

This document illustrates the basic timing requirements of the I2C protocol using WaveDrom.

---

# Bus Idle

Both **SCL** and **SDA** remain HIGH.

```wavedrom
{ signal: [
  { name: "SCL", wave: "1111111" },
  { name: "SDA", wave: "1111111" }
]}
```

---

# START Condition

A START condition occurs when **SDA transitions HIGH → LOW while SCL is HIGH**.

```wavedrom
{ signal: [
  { name: "SCL", wave: "1111111" },
  { name: "SDA", wave: "10....." }
]}
```

---

# STOP Condition

A STOP condition occurs when **SDA transitions LOW → HIGH while SCL is HIGH**.

```wavedrom
{ signal: [
  { name: "SCL", wave: "1111111" },
  { name: "SDA", wave: "01....." }
]}
```

---

# Write Transaction

The master transmits one byte followed by an ACK.

```wavedrom
{ signal: [
  { name: "SCL", wave: "p........" },
  { name: "SDA", wave: "x=222222=0", data:["D7","D6","D5","D4","D3","D2","D1","D0","ACK"] }
]}
```

---

# Read Transaction

The slave transmits one byte.

```wavedrom
{ signal: [
  { name: "SCL", wave: "p........" },
  { name: "SDA", wave: "x=222222=0", data:["D7","D6","D5","D4","D3","D2","D1","D0","ACK"] }
]}
```

---

# ACK

The receiver acknowledges by pulling SDA LOW during the ninth clock pulse.

```wavedrom
{ signal: [
  { name: "SCL", wave: "p........" },
  { name: "SDA", wave: "x=222222=0", data:["D7","D6","D5","D4","D3","D2","D1","D0","ACK"] }
]}
```

---

# NACK

The receiver does not acknowledge and leaves SDA HIGH during the ninth clock pulse.

```wavedrom
{ signal: [
  { name: "SCL", wave: "p........" },
  { name: "SDA", wave: "x=222222=1", data:["D7","D6","D5","D4","D3","D2","D1","D0","NACK"] }
]}
```

---

# Standard Mode

| Parameter | Value |
|-----------|------:|
| Bus Frequency | 100 kHz |
| Clock Period | 10 µs |
| Address Width | 7-bit |
| Data Width | 8-bit |