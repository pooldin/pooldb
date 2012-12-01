PREPARE userMetaInsert (int8, varchar, varchar, timestamptz, timestamptz) AS
    INSERT INTO user_meta (user_id, key, value, created, modified)
    VALUES ($1, $2, $3, $4, $5);
EXECUTE userMetaInsert (1, 'email', 'brian@poold.in', now(), now());
EXECUTE userMetaInsert (2, 'email', 'kevin@poold.in', now(), now());
EXECUTE userMetaInsert (3, 'email', 'patrick@poold.in', now(), now());
EXECUTE userMetaInsert (4, 'email', 'collin@poold.in', now(), now());
EXECUTE userMetaInsert (5, 'email', 'greg@poold.in', now(), now());
EXECUTE userMetaInsert (6, 'email', 'sung@poold.in', now(), now());
DEALLOCATE userMetaInsert;
