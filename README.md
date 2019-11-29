                                                         Tools Script
1.clickhouse-attrestore : Restore freeze part table backup from attached directory  
>example:clickhouse-attrestore.sh -h 127.0.0.1 -P 9000 -u default [-p]|[-p 123456] -d test -t test/var/lib/clickhouse/data/test/test/detached

2.clickhouse-import: Restore data to table from backup file or directory
>example:clickhouse-import -h 127.0.0.1 -P 9000 -u root -p|-p 123456 -d test backup_directory|table  
/*警告：执行命令前建议备份原数据，导入数据前将删除原数据!*/  
3.clickhouse-dump:Remote backup clickhouse database or tables to local,include metadata and data('TabSeparated' format)
>clickhouse-dump -h 127.0.0.1 -P 9000 -u  default [-p]|[-p 123456] -d test [-t table1,table2] [-n 2]

4.clickhouse-load：Import data to table split N rows
>clickhouse-load -h 127.0.0.1 -P 9000 -u default -p -d test -t test -n 100000 file
