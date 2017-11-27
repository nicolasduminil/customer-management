set echo on
set timing on
prompt Please wait while users are created and configured
CREATE USER nicolas IDENTIFIED BY California1;
GRANT CONNECT,RESOURCE TO nicolas;
GRANT CREATE SESSION TO nicolas;
ALTER USER nicolas QUOTA UNLIMITED on USERS;
prompt Users were created and configured
exit;

