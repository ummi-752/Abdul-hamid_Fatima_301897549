db.runCommand({
  collMod: "transaction_logs",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["transaction_id", "account_number", "event_type",
                 "amount", "currency", "timestamp", "schema_version"],
      properties: {
        transaction_id:  { bsonType: "string" },
        account_number:  { bsonType: "string" },
        event_type:      { bsonType: "string" },
        amount:          { bsonType: "decimal" },
        currency:        { bsonType: "string", pattern: "^[A-Z]{3}$" },
        timestamp:       { bsonType: "date" },
        metadata:        { bsonType: "object" },
        schema_version:  { bsonType: "int" }
      }
    }
  },
  validationAction: "error"
});
