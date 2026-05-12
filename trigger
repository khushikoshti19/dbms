mysql> create database trigger_db;
Query OK, 1 row affected (0.13 sec)
mysql> use trigger_db;
Database changed
mysql> create table emp(empid int(20)Primary key,empname varchar(50),salary int(30));
Query OK, 0 rows affected, 2 warnings (1.15 sec)
mysql> insert into emp values(1,"Ram",50000),(2,"Gita",60000),(3,"Sham",55000);
Query OK, 3 rows affected (0.11 sec)
Records: 3 Duplicates: 0 Warnings: 0
mysql> select * from emp;
+-------+---------+--------+
| empid | empname | salary |
+-------+---------+--------+
| 1 | Ram | 50000 |
| 2 | Gita | 60000 |
| 3 | Sham | 55000 |
+-------+---------+--------+
3 rows in set (0.00 sec)
1. Trigger to Maintain Data Integrity:
mysql> drop trigger if exists chk_salary;
-> delimiter //
Query OK, 0 rows affected, 1 warning (0.04 sec)
mysql> create trigger chk_salary
-> before insert on emp
->
-> for each row
-> begin
-> if NEW.salary <= 0 then
-> signal sqlstate '45000'
-> set message_text="Salary can not be negative and zero!";
-> end if;
-> end;
-> //
Query OK, 0 rows affected (0.09 sec)
mysql> delimiter ;
mysql> insert into emp values(4,"Sita",0);
ERROR 1644 (45000): Salary can not be negative and zero!
2.Trigger to Prevent Deleting Employees with High Salary
/*Business Rule:Employees earning more than 50,000 cannot be deleted.*/
mysql> DELIMITER //
mysql>
mysql> CREATE TRIGGER high_salary
-> BEFORE DELETE ON emp
-> FOR EACH ROW
-> BEGIN
-> IF OLD.salary > 50000 THEN
-> SIGNAL SQLSTATE '45000'
-> SET MESSAGE_TEXT = 'Cannot delete employee with salary greater than 50000';
-> END IF;
-> END;
-> //
Query OK, 0 rows affected (0.15 sec)
mysql>
mysql> DELIMITER ;
mysql> delete from emp where salary=60000;
ERROR 1644 (45000): Cannot delete employee with salary greater than 50000
3.Trigger to Automatically Log Employee Inserts (Audit Integrity)
mysql> DROP TRIGGER IF EXISTS emp_insert;
Query OK, 0 rows affected, 1 warning (0.06 sec)
mysql>
mysql> DELIMITER //
mysql>
mysql> CREATE TRIGGER emp_insert
-> AFTER INSERT ON emp
-> FOR EACH ROW
-> BEGIN
-> INSERT INTO emp2 (empid, action, action_date)
-> VALUES (NEW.empid, 'INSERT', NOW());
-> END;
-> //
Query OK, 0 rows affected (0.16 sec)
mysql>
mysql> DELIMITER ;
mysql> insert into emp values(4,"Radha",50000);
Query OK, 1 row affected (0.09 sec)
mysql> select * from emp;
+-------+---------+--------+
| empid | empname | salary |
+-------+---------+--------+
| 2 | Gita | 60000 |
| 3 | Sham | 55000 |
| 4 | Radha | 50000 |
+-------+---------+--------+
3 rows in set (0.00 sec)
mysql> select * from emp2;
+-------+--------+---------------------+
| empid | action | action_date |
+-------+--------+---------------------+
| 4 | INSERT | 2026-04-22 13:57:01 |
+-------+--------+---------------------+
1 row in set (0.00 sec)
4. Trigger to Automatically Set Default Salary
mysql> CREATE TRIGGER default_salary
-> BEFORE INSERT ON emp
-> FOR EACH ROW
-> BEGIN
-> IF NEW.salary IS NULL THEN
-> SET NEW.salary = 30000;
-> END IF;
-> END;
-> //
Query OK, 0 rows affected (0.18 sec)
mysql>
mysql> DELIMITER ;
mysql> insert into emp values(7,"Raj",NULL);
Query OK, 1 row affected (0.08 sec)
mysql> select * from emp;
+-------+---------+--------+
| empid | empname | salary |
+-------+---------+--------+
| 2 | Gita | 60000 |
| 3 | Sham | 55000 |
| 7 | Raj | 30000 |
+-------+---------+--------+
3 rows in set (0.00 sec)
