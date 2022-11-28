SELECT 'CREATE DATABASE {{ .db.name }}'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{{ .db.name }}')\gexec

DO
$do$
    BEGIN
        IF EXISTS (
                SELECT FROM pg_catalog.pg_roles
                WHERE  rolname = '{{ .db.username }}') THEN
            RAISE NOTICE 'Role "{{ .db.username }}" already exists. Skipping.';
        ELSE
            CREATE ROLE {{ .db.username }} LOGIN PASSWORD '{{ .db.password }}';
        END IF;
    END
$do$;


GRANT ALL PRIVILEGES ON DATABASE "{{ .db.name }}" TO "{{ .db.username }}";
ALTER DATABASE "{{ .db.name }}" OWNER TO "{{ .db.username }}";
ALTER SCHEMA public OWNER TO "{{ .db.username }}";
