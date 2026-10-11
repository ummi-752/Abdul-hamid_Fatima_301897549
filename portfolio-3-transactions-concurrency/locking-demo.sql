-- ============================================================
-- TimaPay — Portfolio 3: Pessimistic Locking Demo
-- MIT 8103 Advanced Database Systems
-- ============================================================

-- WHAT IS PESSIMISTIC LOCKING?
-- Imagine two people trying to update the same bank account at the same time.
-- Without locking, both could read the same balance, both subtract money,
-- and the account ends up with the wrong balance.
-- SELECT FOR UPDATE locks the row so only ONE person can change it at a time.
-- The second person has to WAIT until the first one is done.

-- ============================================================
-- HOW TO DEMONSTRATE THIS IN PGADMIN:
-- Open TWO Query Tool tabs in pgAdmin (File > New Query Tool)
-- Run Session 1 commands in Tab 1
-- Run Session 2 commands in Tab 2
-- ============================================================


-- SESSION 1 (run this in Tab 1 first)
-- This locks the ACC001 row so nobody else can change it
BEGIN;
  SELECT Account_Number, Balance
  FROM Account
  WHERE Account_Number = 'ACC001'
  FOR UPDATE;
-- DO NOT COMMIT YET
-- Now go run Session 2 in Tab 2 and watch it wait


-- SESSION 2 (run this in Tab 2 while Session 1 is still open)
-- This tries to lock the same row but gets BLOCKED
-- It will just sit and wait until Session 1 commits
BEGIN;
  SELECT Account_Number, Balance
  FROM Account
  WHERE Account_Number = 'ACC001'
  FOR UPDATE;
-- This line will not complete until Session 1 runs COMMIT


-- BACK IN SESSION 1 (run this in Tab 1 to release the lock)
COMMIT;
-- As soon as you run this, Session 2 will unblock and complete


-- WHAT THIS PROVES:
-- PostgreSQL serialises concurrent updates to the same account
-- The final balance will always be correct — no lost updates
-- This satisfies the Isolation property of ACID


-- ============================================================
-- SIMPLER SINGLE-SESSION VERSION (run all at once for evidence)
-- Shows the FOR UPDATE syntax working correctly
-- ============================================================

BEGIN;
  SELECT Account_Number, Balance
  FROM Account
  WHERE Account_Number = 'ACC001'
  FOR UPDATE;
COMMIT;

-- Result: Row selected and lock released immediately
-- In a real concurrent scenario, another session would have waited
