# CAP Theorem Analysis — TimaPay Distributed Database

## What is the CAP Theorem?
The CAP theorem states that a distributed database can only guarantee 
two of the following three properties at the same time:

- **C — Consistency:** Every read receives the most recent write
- **A — Availability:** Every request receives a response (not an error)
- **P — Partition Tolerance:** The system continues to operate even when 
  network communication between nodes fails

## TimaPay's CAP Choice: CP (Consistency + Partition Tolerance)

TimaPay prioritises **Consistency** over **Availability**.

### Why Consistency is Non-Negotiable for TimaPay
TimaPay is a financial platform. If a customer transfers money and 
two nodes show different balances due to a network partition, 
money could appear to exist in two places or disappear entirely.

This is unacceptable for a banking system. A wrong balance is far 
worse than a temporary error message.

### What This Means in Practice
- WHEN a network partition occurs, the minority partition REJECTS 
  write requests and returns an error to the client
- Clients on the majority partition continue to read and write normally
- Once the partition heals, all nodes re-synchronise

### Trade-off Accepted
- TimaPay accepts temporary **unavailability** during network partitions
- Clients may receive connection errors during failover (up to 30 seconds)
- This is acceptable because data correctness is more important than 
  continuous availability in financial systems

## Consistency vs Availability in TimaPay
| Scenario | Behaviour |
|----------|-----------|
| Normal operation | Full read + write availability |
| Network partition | Writes rejected on minority partition |
| Node failure | Replica promoted within 30 seconds |
| During failover | Writes return errors (not silently applied) |
