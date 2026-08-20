\set ON_ERROR_STOP on
DROP DATABASE IF EXISTS taskbridge_verify;
CREATE DATABASE taskbridge_verify;
\connect taskbridge_verify
\i /home/ubuntu/taskbridge-erd-fix/schema.sql

INSERT INTO users (name, email) VALUES ('Asha Rao', 'asha@example.com');
INSERT INTO projects (name, description) VALUES ('Launch Plan', 'TaskBridge launch work');
INSERT INTO tasks (title, user_id, project_id) VALUES ('Prepare schema demo', 1, 1);

-- These catalog queries verify primary keys, uniqueness, and foreign keys.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT tc.table_name, tc.constraint_type, tc.constraint_name
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;

SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid IN ('users'::regclass, 'projects'::regclass, 'tasks'::regclass)
ORDER BY conrelid::text, conname;

-- Expected failure: the referenced user does not exist.
INSERT INTO tasks (title, user_id, project_id) VALUES ('Invalid task', 9999, 1);
