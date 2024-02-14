<ubuntu os, postgresql upgrade from version 12 to 16>


root@psql:~# dpkg -l | grep postgres
root@psql:~# su postgres
postgres@psql:/root$  psql 
postgres=# \l  #list all tables 
postgres=# exit
postgres@psql:/root$  exit
root@psql:~# wget --quiet -o - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
OK 
root@psql:~# sudo sh 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
root@psql:~# apt update 
root@psql:~# cd /etc/apt/sources.list.d/
root@psql:/etc/apt/sources.list.d# ls 
pgdg.list pgdg.list-
root@psql:/etc/apt/sources.list.d# rm -rf pgdg.list-
root@psql:/etc/apt/sources.list.d# cd 
root@psql:~# apt update 
root@psql:~# sudo apt install postgresql-16 postgresql-client-16 -y 
root@psql:~# clear 
root@psql:~# dpkg -l | grep postgresql
root@psql:~# pg_lsclusters
Ver	Cluster	Port	Status	Owner	Data directory	Log file 
12	main	5432	online	postgres	/var/lib/postgresql/12/main	/var/log/postgresql/postgresql-12-main.log
16	main	5433	online	postgres	/var/lib/postgresql/16/main	/var/log/postgresql/postgresql-16-main.log
root@psql:~# systemctl stop postgresql
root@psql:~# systemctl status postgresql
root@psql:~# sudo pg_dropcluster 16 main --stop 
root@psql:~# pg_lsclusters
Ver	Cluster	Port	Status	Owner	Data directory	Log file 
12	main	5432	down	postgres	/var/lib/postgresql/12/main	/var/log/postgresql/postgresql-12-main.log
root@psql:~# sudo pg_upgradecluster 12 main 
root@psql:~# systemctl start postgresql
root@psql:~# pg_lsclusters
Ver	Cluster	Port	Status	Owner	Data directory	Log file 
12	main	5433	down	postgres	/var/lib/postgresql/12/main	/var/log/postgresql/postgresql-12-main.log
16	main	5432	online	postgres	/var/lib/postgresql/16/main	/var/log/postgresql/postgresql-16-main.log
root@psql:~# pg_dropcluster 12 main 
root@psql:~# pg_lsclusters
Ver	Cluster	Port	Status	Owner	Data directory	Log file 
16	main	5432	online	postgres	/var/lib/postgresql/16/main	/var/log/postgresql/postgresql-16-main.log
root@psql:~# clear 
root@psql:~# su postgres
postgres@psql:/root$  psql 
postgres=# select version();  #check version of DB
                     version 
------------------------------------------------------
PostgreSQL 16.1
(1 row)
postgres=# \l  #list all tables 
postgres=# exit
postgres@psql:/root$  exit





< pg_upgrade from version 11 to 12 >

+ check version of db

```
[root@localhost /]# su - postgres
[postgres@localhost ~]$ psql 
postgres=# select version();
                     version 
------------------------------------------------------
PostgreSQL 11.9
(1 row)
postgres=# exit
```

+ install postgresql 12 

```
[root@localhost /]# sudo yum install postgresql12-server
...
Complete!
[root@localhost /]# /usr/pgsql-12/bin/postgresql-12-setup initdb 
Initializing database ... OK 
```

+ stop postgresql older version 

```
[root@localhost /]# sudo systemctl stop postgresql-11.service
[root@localhost /]# sudo systemctl status postgresql-11.service


```

[root@localhost /]# cd /usr/pgsql-12/bin/
[root@localhost /]# ls
[root@localhost /]# pwd
[root@localhost /]# /usr/pgsql-12/bin/pg_upgrade \
> -b /usr/pgsql-11/bin \
> -B /usr/pgsql-12/bin \
> -d /var/lib/pgsql/11/data \
> -D /var/lib/pgsql/12/data \
> --check 

pg_upgrade: cannot be run as root 
failure, exiting
[root@localhost bin]# sudo su - postgres
[postgres@localhost ~]$ pwd
/var/lib/pgsql 
[postgres@localhost ~]$ /usr/pgsql-12/bin/pg_upgrade \
> -b /usr/pgsql-11/bin \
> -B /usr/pgsql-12/bin \
> -d /var/lib/pgsql/11/data \
> -D /var/lib/pgsql/12/data \
> --check 

...
*Clusters are compatible*


[postgres@localhost ~]$ /usr/pgsql-12/bin/pg_upgrade \
> -b /usr/pgsql-11/bin \
> -B /usr/pgsql-12/bin \
> -d /var/lib/pgsql/11/data \
> -D /var/lib/pgsql/12/data 


Upgrade Complete
----------------
...
./analyze_new_cluster.sh

...
./delete_old_cluster.sh


[postgres@localhost ~]$ pwd
/var/lib/pgsql
[postgres@localhost ~]$ ls -ltrh
11
12
delete_old_cluster.sh
analyze_new_cluster.sh
[postgres@localhost ~]$ exit
logout

+ change port numbers

[root@localhost bin]# vi /var/lib/pgsql/12/data/postgresql.conf
/port 


#port = 5432  
--> 
port = 5432

:wq

[root@localhost bin]# vi /var/lib/pgsql/11/data/postgresql.conf
/port 


port = 5432 
--> 
port = 5433

:wq


+ start latest postgresql server version 

[root@localhost /]# sudo systemctl start postgresql-12.service
[root@localhost /]# sudo systemctl status postgresql-12.service

[root@localhost /]# su - postgres
[postgres@localhost ~]$ psql 
postgres=# select version();
                     version 
------------------------------------------------------
PostgreSQL 12.4
(1 row)
postgres=# \l  #check table 
postgres=# select datname from pg_database;
postgres=# \du 
postgres=# exit

[postgres@localhost ~]$ cd /var/lib/pgsql/
[postgres@localhost ~]$ ls -ltrh 
11
12
delete_old_cluster.sh
analyze_new_cluster.sh
[postgres@localhost ~]$ ./analyze_new_cluster.sh
...
Done 

[postgres@localhost ~]$ exit
logout

[root@localhost bin]# yum list --installed | grep postgresql
この時、バージョン11と12両方が存在する。
[root@localhost bin]# sudo yum remove postgresql11*
...
Complete!
[root@localhost bin]# yum list --installed | grep postgresql
この時、バージョン12のみが存在する。

[root@localhost bin]# cd /var/lib/pgsql/
[root@localhost pgsql]# ls 
11
12
delete_old_cluster.sh
analyze_new_cluster.sh
[root@localhost pgsql]# rm -rf 11
[root@localhost pgsql]# sudo su postgres
bash-4.4$ pwd
/var/lib/pgsql
bash-4.4$ ./delete_old_cluster.sh
bash-4.4$ exit
exit
[root@localhost pgsql]# cd /etc/profile.d/
[root@localhost profile.d]# ls 
[root@localhost profile.d]# vi postgresqlprofile.sh 
export PATH=/usr/pgsql-12/bin:$PATH
:wq 
[root@localhost ~]# su - postgres
bash-4.4$ psql 
could not change directory to "/root" : Permission denied
postgres=# select version();
                     version 
------------------------------------------------------
PostgreSQL 12.4
(1 row)
postgres=# \l 
postgres=# exit 

終わり


参考URL：
https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-11-to-12/
https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-10-to-11/
https://www.postgresql.r2schools.com/
https://www.postgresql.r2schools.com/how-to-start-stop-postgresql-server-using-pg_ctl/
https://www.postgresql.r2schools.com/how-to-install-postgresql-13-on-redhat/
https://www.postgresql.r2schools.com/how-to-install-and-configure-postgresql-16-on-oracle-linux/
https://www.server-world.info/
https://www.postgresql.r2schools.com/how-to-install-postgis-in-rhel/
https://www.postgresql.r2schools.com/how-to-install-or-create-pg_stat_statements-extension-in-postgresql/
https://www.postgresql.r2schools.com/how-to-install-postgresql-14-on-redhat-linux-step-by-step/
https://www.postgresql.r2schools.com/postgresql-error-could-not-open-extension-control-file/
https://www.postgresql.r2schools.com/postgresql-pg_dump-error-aborting-because-of-server-version-mismatch/
https://www.postgresql.r2schools.com/how-to-install-postgresql-and-pgadmin-on-rhel-9/
https://www.postgresql.r2schools.com/how-to-install-postgresql-on-kali-linux/
https://www.postgresql.r2schools.com/how-to-install-postgresql-and-pgadmin-on-rhel-9/
https://www.postgresql.r2schools.com/how-to-install-postgresql-14-on-redhat-linux-step-by-step/
https://www.postgresql.r2schools.com/how-to-restart-postgresql-on-centos-7/
https://www.postgresql.r2schools.com/how-to-install-postgresql-and-pgadmin-on-rhel-9/
https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-10-to-11/
https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-11-to-12/
https://www.postgresql.r2schools.com/how-to-install-postgresql-14-on-redhat-linux-step-by-step/
https://www.postgresql.r2schools.com/how-to-install-postgresql-13-on-redhat/
https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-10-to-11/
https://www.postgresql.r2schools.com/how-to-take-backup-and-restore-a-postgresql-database/
https://www.postgresql.r2schools.com/how-to-take-backup-and-restore-a-postgresql-table/
https://www.postgresql.r2schools.com/how-to-start-and-stop-postgresql-server-on-linux/
https://www.postgresql.r2schools.com/how-to-restart-postgresql-on-centos-7/
https://www.postgresql.r2schools.com/install-postgresql-11-on-redhat-linux-operating-system/

https://www.postgresql.r2schools.com/how-to-install-postgresql-13-on-redhat/

https://www.postgresql.r2schools.com/install-postgresql-11-on-redhat-linux-operating-system/
https://www.postgresql.r2schools.com/how-to-install-postgresql-13-on-redhat/


https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-11-to-12/
https://www.postgresql.r2schools.com/how-to-install-postgresql-13-on-redhat/

https://www.postgresql.r2schools.com/how-to-upgrade-from-postgresql-10-to-11/



















