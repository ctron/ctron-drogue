SELECT 'CREATE DATABASE {{ .Values.keycloak.postgres.database }}'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{{ .Values.keycloak.postgres.database }}')\gexec

DO
$do$
    BEGIN
        IF EXISTS (
                SELECT FROM pg_catalog.pg_roles
                WHERE  rolname = '{{ .Values.keycloak.postgres.username}}') THEN
            RAISE NOTICE 'Role "{{ .Values.keycloak.postgres.username}}" already exists. Skipping.';
        ELSE
            CREATE ROLE {{ .Values.keycloak.postgres.username}} LOGIN PASSWORD '{{ .Values.keycloak.postgres.password }}';
        END IF;
    END
$do$;


GRANT ALL PRIVILEGES ON DATABASE "{{ .Values.keycloak.postgres.database }}" TO "{{ .Values.keycloak.postgres.username }}";
ALTER DATABASE "{{ .Values.keycloak.postgres.database }}" OWNER TO "{{ .Values.keycloak.postgres.username }}";
ALTER SCHEMA public OWNER TO "{{ .Values.keycloak.postgres.username }}";
