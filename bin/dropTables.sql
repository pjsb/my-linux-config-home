SELECT 'DROP TABLE "' || table_name || '" CASCADE CONSTRAINTS;' FROM user_tables;
