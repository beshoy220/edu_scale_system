-- Get totle size of the table, data size and index size
select
  pg_total_relation_size('grades') as total_size,
  pg_relation_size('grades') as data_size,
  pg_indexes_size('grades') as index_size;

-- Get size of all tables in the database
select
  relname as table,
  pg_size_pretty(pg_total_relation_size(relid)) as total_size
from pg_catalog.pg_statio_user_tables
order by pg_total_relation_size(relid) desc;

-- Get average row size in bytes. Note: Includes a 24-byte row header
SELECT AVG(pg_column_size(t.*)) as avg_row_size_bytes
FROM grades AS t;

-- Get size of each row in bytes
SELECT pg_column_size(t.*) FROM grades t; 

-- Delete all tables from the public database (Try another query becuae this makes database problems)
DROP SCHEMA public CASCADE;
