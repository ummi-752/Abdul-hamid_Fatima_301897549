# Failover Behaviour — TimaPay Distributed Cluster

## Normal Configuration
- 1 Primary node (handles all writes and some reads)
- 2 Replica nodes (handle read queries to reduce load on primary)
- Synchronous replication: every write is confirmed by at least 1 replica 
  before the client receives acknowledgement

## What Happens When the Primary Node Fails

1. Primary node becomes unavailable (hardware failure, network issue, crash)
2. Replica nodes detect the failure within seconds via heartbeat monitoring
3. Replicas hold an automatic election to choose a new primary
4. The replica with the most up-to-date data is promoted to primary
5. This process completes within **30 seconds**
6. The connection router updates to point clients to the new primary

## During the Failover Window
- Write requests receive a **connection error** — not silent failure
- Read requests may also temporarily fail
- Clients must implement retry logic (up to 3 retries)
- No write is applied without the client explicitly resubmitting it

## After Failover
- New primary accepts reads and writes normally
- Old primary (if recovered) rejoins as a replica
- Data is re-synchronised automatically

## Zero Data Loss Guarantee
Because synchronous replication is used, every committed write exists 
on at least one replica before acknowledgement. 
If the primary fails immediately after a commit, that write is not lost.
