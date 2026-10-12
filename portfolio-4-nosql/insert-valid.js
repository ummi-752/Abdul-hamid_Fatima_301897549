db.transaction_logs.insertOne({
  transaction_id:  "TXN-001",
  account_number:  "ACC001",
  event_type:      "transfer_debit",
  amount:          NumberDecimal("500.00"),
  currency:        "NGN",
  timestamp:       new Date(),
  metadata:        { channel: "mobile_app" },
  schema_version:  1
});
