const session = db.getMongo().startSession();
session.startTransaction();

try {
  db.transaction_logs.insertOne({
    transaction_id:  "TXN-003",
    account_number:  "ACC001",
    event_type:      "transfer_debit",
    amount:          NumberDecimal("300.00"),
    currency:        "NGN",
    timestamp:       new Date(),
    metadata:        {},
    schema_version:  1
  }, { session });

  db.transaction_logs.insertOne({
    transaction_id:  "TXN-004",
    account_number:  "ACC002",
    event_type:      "transfer_credit",
    amount:          NumberDecimal("300.00"),
    currency:        "NGN",
    timestamp:       new Date(),
    metadata:        {},
    schema_version:  1
  }, { session });

  session.commitTransaction();
  print("Transaction committed successfully");
} catch(e) {
  session.abortTransaction();
  print("Transaction aborted: " + e);
}
