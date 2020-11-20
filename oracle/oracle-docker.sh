docker run -d --name=oracle -p 8181:8080 -p 1521:1521 -v /oracle/data:/u01/app/oracle mybook2019/oracle-ee-11g:v1.0
sqlplus system/oracle@//192.168.8.24:1521/EE.oracle.docker
