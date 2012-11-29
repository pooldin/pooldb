PREPARE currencyInsert (varchar, varchar, int4, varchar, varchar, varchar, timestamptz, timestamptz, bool) AS
  INSERT INTO currency (title, code, number, unit, unit_plural, sign, created, modified, enabled)
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);
EXECUTE currencyInsert ('United States Dollar', 'USD', 840, 'dollar', 'dollars', '$', now(), now(), true);
DEALLOCATE currencyInsert;
