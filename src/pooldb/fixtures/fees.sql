PREPARE feeInsert (varchar, text, numeric, numeric, timestamptz, timestamptz) AS
  INSERT INTO fee (name, description, fractional_pct, flat, created, modified)
  VALUES ($1, $2, $3, $4, $5, $6);
EXECUTE feeInsert ('stripe-transaction', 'Transaction fee charged by stripe', 0.0290, 0.3000, now(), now());
EXECUTE feeInsert ('poold-transaction', 'Transaction fee charged by Poold Inc.', 0.0300, 0.0000, now(), now());
DEALLOCATE feeInsert;
