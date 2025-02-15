mysql> CREATE TABLE Employees (
    ->     EmployeeID INT,
    ->     EmployeeName VARCHAR(100),
    ->     Department VARCHAR(50)
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE Sales (
    ->     SaleID INT,
    ->     EmployeeID INT,
    ->     SaleAmount DECIMAL(10, 2),
    ->     SaleDate DATE
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> INSERT INTO Sales VALUES (1, 101, 5000, '2025-01-01'), (2, 102, 7000, '2025-01-02');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Employees VALUES (101, 'John Doe', 'Sales'), (102, 'Jane Smith', 'Marketing');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> select * from Employees;
+------------+--------------+------------+
| EmployeeID | EmployeeName | Department |
+------------+--------------+------------+
|        101 | John Doe     | Sales      |
|        102 | Jane Smith   | Marketing  |
+------------+--------------+------------+
2 rows in set (0.00 sec)

mysql> select * from Sales;
+--------+------------+------------+------------+
| SaleID | EmployeeID | SaleAmount | SaleDate   |
+--------+------------+------------+------------+
|      1 |        101 |    5000.00 | 2025-01-01 |
|      2 |        102 |    7000.00 | 2025-01-02 |
+--------+------------+------------+------------+
2 rows in set (0.00 sec)

mysql> INSERT INTO Sales VALUES (1, 101, 5000, '2025-01-01'), (2, 102, 7000, '2025-01-02');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Employees VALUES (101, 'John Doe', 'Sales'), (102, 'Jane Smith', 'Marketing');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT 
    ->     EmployeeID, 
    ->     SUM(SaleAmount) AS TotalSales
    -> FROM Sales
    -> GROUP BY EmployeeID;
+------------+------------+
| EmployeeID | TotalSales |
+------------+------------+
|        101 |   10000.00 |
|        102 |   14000.00 |
+------------+------------+
2 rows in set (0.00 sec)

mysql> SET @rank = 0;
Query OK, 0 rows affected (0.00 sec)

mysql> SET @prev_amount = NULL;
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> SELECT 
    ->     SaleID, 
    ->     SaleAmount,
    ->     @rank := IF(@prev_amount = SaleAmount, @rank, @rank + 1) AS Rank,
    ->     @prev_amount := SaleAmount
    -> FROM Sales
    -> ORDER BY SaleAmount DESC;
+--------+------------+------+----------------------------+
| SaleID | SaleAmount | Rank | @prev_amount := SaleAmount |
+--------+------------+------+----------------------------+
|      2 |    7000.00 |    1 |                    7000.00 |
|      2 |    7000.00 |    1 |                    7000.00 |
|      1 |    5000.00 |    2 |                    5000.00 |
|      1 |    5000.00 |    2 |                    5000.00 |
+--------+------------+------+----------------------------+
4 rows in set (0.00 sec)

mysql> SELECT *
    -> FROM Sales
    -> WHERE SaleAmount = (SELECT MAX(SaleAmount) FROM Sales);
+--------+------------+------------+------------+
| SaleID | EmployeeID | SaleAmount | SaleDate   |
+--------+------------+------------+------------+
|      2 |        102 |    7000.00 | 2025-01-02 |
|      2 |        102 |    7000.00 | 2025-01-02 |
+--------+------------+------------+------------+
2 rows in set (0.00 sec)

mysql> 
mysql> SELECT 
    ->     MONTH(SaleDate) AS SaleMonth, 
    ->     SUM(SaleAmount) AS TotalMonthlySales
    -> FROM Sales
    -> GROUP BY MONTH(SaleDate);
+-----------+-------------------+
| SaleMonth | TotalMonthlySales |
+-----------+-------------------+
|         1 |          24000.00 |
+-----------+-------------------+
1 row in set (0.00 sec)

mysql> SELECT 
    ->     E.EmployeeName,
    ->     SUM(S.SaleAmount) AS TotalSales
    -> FROM Employees E
    -> JOIN Sales S ON E.EmployeeID = S.EmployeeID
    -> GROUP BY E.EmployeeName;
+--------------+------------+
| EmployeeName | TotalSales |
+--------------+------------+
| Jane Smith   |   28000.00 |
| John Doe     |   20000.00 |
+--------------+------------+
2 rows in set (0.00 sec)
