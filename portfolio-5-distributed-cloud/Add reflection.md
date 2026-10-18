Individual Technical Reflection

Student: Fatima Abdulhamid Course: 

MIT 8103 Advanced Database Systems Case Study: TimaPay -  Digital Banking Platform. 

**Portfolio 1** - Database Design Decisions

I designed the TimaPay relational schema with four core tables: Customer, Account, Transaction, and Audit_Log.

The key design decision was separating Customer and Account into distinct tables rather than embedding account details inside the customer record. This enforces Third Normal Form (3NF) and ensures that when a customer opens a second account, no customer data is duplicated.

I chose DECIMAL(18,2) for all monetary amounts because floating-point types like FLOAT or DOUBLE introduce rounding errors which are entirely unacceptable in a financial system where every kobo matters.

The savings_no_overdraft check constraint was the most critical integrity rule. I learned that PostgreSQL enforces check constraints within the committing transaction, meaning any violation immediately rolls back the operation.

Challenge: Encountering a foreign key violation error when attempting to insert transactions before accounts taught me that insert order matters strictly parent rows must always be inserted before child rows.

**Portfolio 2** - Query Optimisation

The most valuable takeaway from this portfolio was understanding the practical difference between a Sequential Scan (Seq Scan) and an Index Scan in EXPLAIN ANALYSE output.

Before adding the composite index on (Account_Number, transaction_ts), PostgreSQL performed a full sequential scan of the Transaction table for every statement query. After adding the index, it executed an efficient Index Scan, drastically reducing execution time for large datasets.

I chose a composite index rather than two separate indexes because statement queries invariably filter by both Account_Number AND a timestamp range; a composite index covers both filter conditions in a single index lookup.

Challenge: Initially struggling to determine the optimal column ordering for the composite index. I learned that the leading column in a composite index must match the primary filtering or equality column (Account_Number) to maximize b-tree traversal efficiency before filtering by the range (transaction_ts).

**Portfolio 3** - Transactions and Concurrency

The ACID properties transitioned from abstract database theory into tangible mechanics during this portfolio.

The most important demonstration was executing a fund transfer, proving that both the debit and credit updates commit atomically. If one leg fails, both are rolled back entirely, preventing money from mysteriously disappearing or being created.

I tested READ COMMITTED and SERIALIZABLE isolation levels. The key distinction is that SERIALIZABLE prevents phantom readsâ€”if a second query runs in the same transaction, it views a perfectly consistent snapshot of data, even if another concurrent transaction successfully inserted rows in the interim.

The savings_no_overdraft constraint violation vividly demonstrated the Consistency property: the database rejected an invalid balance state and rolled back the entire operation cleanly.

Challenge: pgAdmin operates in autocommit mode by default, which caused BEGIN and COMMIT blocks to behave differently than they would in a command-line terminal. I adapted by managing execution scripts carefully and verifying state changes step-by-step using explicit checks.

**Portfolio 4** - NoSQL Design

The defining design decision in MongoDB was implementing strict JSON Schema validation rules. I chose to enforce mandatory fields (transaction_id, account_number, amount, currency, timestamp, schema_version) at the database level rather than relying solely on application-level validation, mirroring the NOT NULL constraints used in PostgreSQL.

The key trade-off I identified between PostgreSQL and MongoDB lies in schema evolution. Adding a new metadata field in MongoDB requires zero schema migrationâ€”documents simply adopt the new field organically going forward. In contrast, altering a PostgreSQL table requires a blocking or non-blocking ALTER TABLE migration.

Challenge: Multi-document transactions require a replica set architecture in MongoDB; a standalone instance does not support them natively. Recognizing this constraint highlighted that in a production environment, TimaPays MongoDB tier must be deployed as at least a 3-node replica set.

**Portfolio 5** - Distributed Database

The most profound concept mastered here was navigating the fundamental trade-offs of the CAP theorem. TimaPay cannot guarantee Consistency, Availability, and Partition Tolerance simultaneously.

I chose a CP (Consistency + Partition Tolerance) architecture because TimaPay is a financial platform where data accuracy is paramount. A wrong balance is infinitely worse than a temporary service error. If a network partition occurs, the system must reject writes on the minority partition rather than allowing split-brain scenarios where two nodes display diverging balances.

Synchronous replication guarantees zero data loss on single-node failures, ensuring every committed write is acknowledged by at least one replica before the client receives confirmation.

Challenge: Visualizing and reasoning through split-brain scenarios and network partition recovery. Configuring synchronous replication parameters correctly required careful tuning to balance write-latency overhead against strict durability requirements.

Overall Lessons Learned :

Database constraints are the ultimate line of defense. Application code can contain bugs, but a well-designed relational schema rejects invalid data regardless of how or where it was submitted.
Theory versus practice. The gap between reading about a concept and running EXPLAIN ANALYSE to see an Index Scan replace a Seq Scan makes database performance optimization concrete and understandable.
SQL and NoSQL complement each other. They are not competitors; they solve entirely different architectural problems. PostgreSQL is ideal for TimaPays core structured financial ledgers, while MongoDB excels at handling flexible, semi-structured event logs and audit records.

**AI Use Declaration**

I utilized Kiro (AI assistant) as a technical reference and debugging partner throughout this portfolio. Specifically, I used the tool for:

Reviewing syntax structures for initial PostgreSQL schemas and MongoDB validation rules.

Troubleshooting error messages and understanding underlying database behaviors (such as foreign key constraints and transaction handling in pgAdmin).

Exploring best practices for query optimization and index design.


All scripts were executed personally in pgAdmin and MongoDB Compass. Every output was verified, screenshots were captured as evidence, and the logic of each script was thoroughly reviewed to ensure full comprehension of its functionality and underlying mechanisms.

I remain fully responsible for the accuracy, originality, and understanding of all submitted work.

