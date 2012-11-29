PREPARE userInsert (bool, bool, varchar, varchar, varchar, timestamptz, timestamptz) AS
  INSERT INTO %(schema)s.user (enabled, verified, username, password, name, created, modified)
  VALUES ($1, $2, $3, $4, $5, $6, $7);
EXECUTE userInsert (true, false, 'brian', 'sha1$vbA4Nfb4$6019dede821080f161eaa146fe371c9d1ee45b56', 'Brian Oldfield', now(), now());
EXECUTE userInsert (true, false, 'kevin', 'sha1$A73Pi4X1$6e32639f0d94441f3ab3b3fa5de7e24e520bb6ff', 'Kevin Berger', now(), now());
EXECUTE userInsert (true, false, 'patrick', 'sha1$oxoQffUW$ede1c817d861dbbaaf93e8b10b7a61b23763842e', 'Patrick Murck', now(), now());
EXECUTE userInsert (true, false, 'collin', 'sha1$xOYkd2JQ$c577cb30a5a1caa495c47ccbbd5c93879b6e9baf', 'Collin Watson', now(), now());
EXECUTE userInsert (true, false, 'greg', 'sha1$hArcm785$63862694aecf77d62db911ea8cfc104c5891c66f', 'Greg Egan', now(), now());
EXECUTE userInsert (true, false, 'sung', 'sha1$WVbm3phl$192d706a995484ba671fa1942310fdf4d1511e09', 'Sung Kim', now(), now());
DEALLOCATE userInsert;
