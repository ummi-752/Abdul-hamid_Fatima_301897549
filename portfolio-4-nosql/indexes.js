db.transaction_logs.createIndex(
  { account_number: 1, timestamp: 1 },
  { name: "idx_account_timestamp" }
);

