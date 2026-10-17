# SQL vs NoSQL Comparison — TimaPay

## 1. Data Duplication
- **PostgreSQL:** No duplication. Customer data is stored once in the Customer 
  table and linked via foreign keys.
- **MongoDB:** Data is often duplicated across documents for faster reads. 
  For example, account_number appears in every transaction_log document.
- **Trade-off:** MongoDB reads faster but uses more storage. PostgreSQL saves 
  space but requires JOINs.

## 2. Query Flexibility
- **PostgreSQL:** Excellent for complex JOINs across multiple tables. 
  Easy to query relationships (e.g. Customer → Account → Transaction).
- **MongoDB:** Better for queries on a single document or collection. 
  Complex multi-collection queries require aggregation pipelines.
- **Trade-off:** PostgreSQL wins for relational queries. MongoDB wins for 
  document-centric queries.

## 3. Schema Evolution
- **PostgreSQL:** Adding a new column requires ALTER TABLE, which can lock 
  the table on large datasets.
- **MongoDB:** New fields can be added to documents without any migration. 
  Old documents simply don't have the new field.
- **Trade-off:** MongoDB is more flexible for evolving requirements. 
  PostgreSQL enforces consistency but is harder to change.

## 4. Horizontal Scalability
- **PostgreSQL:** Vertical scaling (bigger server) is the default. 
  Horizontal sharding is complex to set up.
- **MongoDB:** Built-in sharding support. Easy to add nodes and distribute 
  data across multiple servers.
- **Trade-off:** MongoDB scales out more easily. PostgreSQL requires more 
  effort for distributed setups.

## Summary
For TimaPay's core financial data (accounts, balances, transactions), 
PostgreSQL is the better choice due to ACID guarantees and relational integrity.
MongoDB is better suited for flexible event logs and audit data where 
schema flexibility and scale matter more than strict consistency.
