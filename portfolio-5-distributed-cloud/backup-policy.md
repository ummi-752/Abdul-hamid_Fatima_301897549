# Backup and Recovery Policy — TimaPay

## Backup Schedule
- **Frequency:** Automated full backup every 24 hours
- **Timing:** Backups run during off-peak hours (2:00 AM server time)
- **Scope:** All database nodes backed up (primary + replicas)
- **Retention:** Backup artefacts retained for a minimum of 30 days

## Point-in-Time Recovery
- TimaPay supports point-in-time recovery (PITR) using WAL archiving
- Recovery is possible to any one-minute interval within the 30-day window
- Example: If data is corrupted at 3:47 PM, the database can be restored 
  to its state at 3:46 PM

## How Backups Are Stored
- Backups are stored on separate storage nodes from the database nodes
- This ensures a node failure does not affect backup availability
- Backup files are compressed and checksummed for integrity verification

## Recovery Process
1. Identify the target recovery point (date and time)
2. Restore the most recent full backup before that point
3. Apply WAL logs up to the exact recovery timestamp
4. Verify data integrity after recovery
5. Redirect client connections to the recovered instance

## Why This Matters for TimaPay
Financial regulations require that transaction data be recoverable.
The 30-day retention window ensures TimaPay can respond to disputes, 
audits, or regulatory requests for historical transaction data.
