# Radio WCS platform (rwp)

docker exec -i "wsdjs_db_1" pg_restore --no-acl --no-owner -U postgres -d "wsdjs_dev" < "${LOCAL_DUMP_PATH}"
