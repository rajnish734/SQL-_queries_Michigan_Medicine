SELECT 'Table' AS object_type, owner, table_name
FROM all_tables
UNION ALL
SELECT 'View', owner, view_name
FROM all_views;