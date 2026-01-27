/*
基本语法：
SELECT 
    列1, 列2,
    窗口函数() OVER (
        [PARTITION BY 分区列]
        [ORDER BY 排序列]
        [窗口框架]
    ) AS 新列名
FROM 表名;
*/

-- 常用窗口函数分类
-- 1. 排名函数
-- ROW_NUMBER()：连续唯一编号（1,2,3...）
SELECT name, salary, ROW_NUMBER() OVER (ORDER BY salary DESC) as rank FROM employees;
-- RANK()：有间隔的排名（1,2,2,4...）
SELECT name, salary, RANK() OVER (ORDER BY salary DESC) as rank FROM employees;
-- DENSE_RANK()：无间隔的排名（1,2,2,3...）
SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank FROM employees;

-- 2. 聚合函数作为窗口函数
-- 计算累计值、移动平均等
SELECT 
    date, sales,
    SUM(sales) OVER (ORDER BY date) as running_total,
    AVG(sales) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg,
    MAX(sales) OVER () as max_overall
FROM sales_data;

-- 3. 取值函数
-- LAG()：取前一行的值
SELECT 
    date, sales,
    LAG(sales) OVER (ORDER BY date) as prev_day_sales
FROM sales;
-- LEAD()：取后一行的值
SELECT 
    date, sales,
    LEAD(sales) OVER (ORDER BY date) as next_day_sales
FROM sales;
-- FIRST_VALUE()：窗口第一行的值
-- LAST_VALUE()：窗口最后一行的值
SELECT 
    name, department, salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) as dept_max
FROM employees;

-- 窗口定义详解
-- 1. PARTITION BY（分区）
-- 按部门分区，在每个部门内单独计算
SELECT 
    name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary
FROM employees;

-- 2. ORDER BY（排序）
-- 控制窗口内行的顺序，影响排名和累计计算
SELECT 
    date, sales,
    SUM(sales) OVER (ORDER BY date) as cumulative_sales
FROM daily_sales;

-- 3. 窗口框架（Window Frame）
-- ROWS：按物理行数
SELECT 
    date, sales,
    AVG(sales) OVER (
        ORDER BY date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as 3_day_moving_avg;
-- RANGE：按数值范围
SELECT 
    salary,
    COUNT(*) OVER (
        ORDER BY salary 
        RANGE BETWEEN 1000 PRECEDING AND 1000 FOLLOWING
    ) as similar_salary_count;

-- 实际应用场景
-- 场景1：获取每组前N名
-- 每个部门工资最高的3名员工
SELECT * FROM (
    SELECT 
        name, department, salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as rn
    FROM employees
) t WHERE rn <= 3;

-- 场景2：计算同比/环比
-- 月销售额环比增长率
SELECT 
    year_month, sales,
    LAG(sales) OVER (ORDER BY year_month) as prev_month,
    (sales - LAG(sales) OVER (ORDER BY year_month)) / LAG(sales) OVER (ORDER BY year_month) * 100 as growth_rate
FROM monthly_sales;

-- 场景3：计算累计百分比
-- 产品销售额累计占比
SELECT 
    product, sales,
    SUM(sales) OVER (ORDER BY sales DESC) as running_total,
    SUM(sales) OVER () as total,
    SUM(sales) OVER (ORDER BY sales DESC) * 100.0 / SUM(sales) OVER () as cumulative_percent
FROM products;

-- 与传统方法的对比
-- 传统GROUP BY方法（会合并行）
SELECT department, AVG(salary) 
FROM employees 
GROUP BY department;
-- 窗口函数方法（保留所有行）
SELECT name, department, salary,
       AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees;