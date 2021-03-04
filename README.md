# Brididi

## Why ##

Because finding a name is way too hard...


docker exec -i "brididi_db_1" pg_restore --no-acl --no-owner -U postgres -d "brididi_dev" < "${LOCAL_DUMP_PATH}"
