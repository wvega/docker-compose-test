cd /wp-core

wp plugin activate test-plugin

wp db export /project/tests/_data/dump.sql
