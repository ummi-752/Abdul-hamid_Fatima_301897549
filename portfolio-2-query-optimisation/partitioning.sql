-- ============================================================
-- TimaPay — Portfolio 2: Table Partitioning
-- MIT 8103 Advanced Database Systems
-- ============================================================

-- WHY PARTITIONING?
-- When the Transaction table has millions of rows, queries slow down
-- because PostgreSQL reads every row to find the ones you want.
-- Partitioning splits the table by year — so a query for 2026 data
-- only reads the 2026 partition, ignoring all other years.

-- STEP 1: Create a new partitioned version of the Transaction table
CREATE TABLE Transaction_Partitioned (
    Transaction_ID      SERIAL,
    Account_Number      VARCHAR(20)     NOT NULL,
    transaction_type    VARCHAR(20)     NOT NULL,
    amount              DECIMAL(18,2)   NOT NULL,
    transaction_ts      TIMESTAMPTZ     NOT NULL,
    Post_Balance        DECIMAL(18,2)   NOT NULL,
    Transfer_Reference  VARCHAR(36),
    Idempotency_Key     VARCHAR(64)
) PARTITION BY RANGE (transaction_ts);


-- STEP 2: Create the 2025 partition
-- Stores all transactions from Jan 2025 to Dec 2025
CREATE TABLE Transaction_2025
PARTITION OF Transaction_Partitioned
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


-- STEP 3: Create the 2026 partition
-- Stores all transactions from Jan 2026 to Dec 2026
CREATE TABLE Transaction_2026
PARTITION OF Transaction_Partitioned
FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');


-- STEP 4: Create the 2027 partition
CREATE TABLE Transaction_2027
PARTITION OF Transaction_Partitioned
FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');


-- STEP 5: Insert a sample row into the partitioned table
INSERT INTO Transaction_Partitioned
    (Account_Number, transaction_type, amount, transaction_ts, Post_Balance)
VALUES
    ('ACC001', 'deposit', 1000.00, '2026-01-05 10:00:00+00', 6000.00);


-- STEP 6: Run EXPLAIN ANALYSE to prove partition pruning works
-- This query only scans Transaction_2026 — it ignores 2025 and 2027
EXPLAIN ANALYSE
SELECT * FROM Transaction_Partitioned
WHERE transaction_ts >= '2026-01-01'
  AND transaction_ts <  '2027-01-01';

-- In the output you should see:
-- Partitions selected: 1 (Transaction_2026)
-- Partitions pruned: 2 (Transaction_2025, Transaction_2027)
-- This proves partitioning is working
