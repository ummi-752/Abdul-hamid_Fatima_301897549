db.transaction_logs.insertOne({
  transaction_id:  "TXN-002",
  account_number:  "ACC001",
  event_type:      "deposit",
  amount:          NumberDecimal("200.00"),
  timestamp:       new Date(),
  schema_version:  1
});
