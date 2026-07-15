# I2C Master State Machine

## State Diagram

```mermaid
stateDiagram-v2

    [*] --> IDLE

    IDLE --> START : start

    START --> SEND_ADDRESS

    SEND_ADDRESS --> ADDRESS_ACK

    ADDRESS_ACK --> WRITE_BYTE : Write

    ADDRESS_ACK --> READ_BYTE : Read

    WRITE_BYTE --> DATA_ACK

    READ_BYTE --> DATA_ACK

    DATA_ACK --> STOP

    STOP --> DONE

    DONE --> IDLE
```

---

## Transaction Flow

```mermaid
sequenceDiagram

    participant M as Master
    participant S as Slave

    M->>S: START

    M->>S: 7-bit Address + R/W

    S-->>M: ACK

    alt Write

        M->>S: Data Byte

        S-->>M: ACK

    else Read

        S->>M: Data Byte

        M-->>S: ACK / NACK

    end

    M->>S: STOP
```

---

# State Description

## IDLE

Wait until `start` is asserted.

---

## START

Generate the START condition.

---

## SEND_ADDRESS

Transmit the 7-bit slave address followed by the R/W bit.

---

## ADDRESS_ACK

Sample the ACK bit from the slave.

---

## WRITE_BYTE

Transmit one byte.

---

## READ_BYTE

Receive one byte.

---

## DATA_ACK

Handle the acknowledgment after each transferred byte.

---

## STOP

Generate the STOP condition.

---

## DONE

Assert `done` and return to `IDLE`.