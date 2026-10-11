# Portfolio 3 — Transactions and Concurrency

Case Study:TimaPay

## Contents
- `transfer.sql` — Full atomic fund transfer script
- `rollback-demo.sql` — Rollback demonstration
- `isolation-levels.sql` — Isolation level test scripts
- `locking-demo.sql` — SELECT FOR UPDATE pessimistic locking demo
- `reversal.sql` — Transaction reversal script
- Screenshots showing commit, rollback, phantom read, and lock behaviour

READ COMMITTED and SERIALIZABLE isolation levels were configured using SET SESSION CHARACTERISTICS. Both returned the same results in a single-session test. Under concurrent access, READ COMMITTED would permit phantom reads while SERIALIZABLE would prevent them.

Balance before rollback: X. Rollback executed. Balance after rollback: X. Rollback successfully reversed all changes

SELECT FOR UPDATE was used to lock the ACC001 row during a transaction. pgAdmin operates in autocommit mode, so the lock was acquired and released within the same statement. In a production scenario with two concurrent sessions, the second session would block until the first commits — preventing lost-update anomalies
