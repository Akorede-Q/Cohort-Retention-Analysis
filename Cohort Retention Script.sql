-- % OF CUSTOMERS THAT MADE A SECOND PURCHASE
WITH first_purchase AS (
	select
		CustomerID,
		min(InvoiceDate) AS
	first_purchase_date
	from Transactions
	where CustomerID is not null
	group by CustomerID
	),
	returning as (
		select
			t.CustomerID,
			case
				when count(case when t.InvoiceDate > f.first_purchase_date then 1 end) > 0
				then 1 else 0
				end as is_returning
				from Transactions t
			join first_purchase f
				on t.CustomerID = f.CustomerID
				group by t.CustomerID,
		f.first_purchase_date)
select
	count(*) as total_customers,
	sum(is_returning) as 
	returning_customers,
		ROUND(1.0 * sum(is_returning) /
		count(*), 4) as retention_rate
	from returning

-- DROP OFF TRENDS
WITH first_purchase as (
	select
		CustomerID,
		min(InvoiceDate) as
	first_purchase_date
		from Transactions
		where CustomerID is not null
		group by CustomerID
),
activity as(
	select 
	t.CustomerID,
	DATEDIFF(Month,
	f.first_purchase_date, t.InvoiceDate) as
	month_number
	from Transactions t
	join first_purchase f
	on t.CustomerID = f.CustomerID)
select
	month_number,
	count(distinct CustomerID) as
	active_customers
from activity
group by month_number
order by month_number

-- WHICH COHORT RETAIN BETTER? NEW OR OLD?
WITH first_purchase as (
	select
		CustomerID,
		min(InvoiceDate) as
	first_purchase_date
		from Transactions
		where CustomerID is not null
		group by CustomerID
),
base as(
	select 
	t.CustomerID,

DATEFROMPARTS(year(f.first_purchase_date),
		month(f.first_purchase_date), 1) as cohort_month,
	DATEDIFF(month, f.first_purchase_date, t.InvoiceDate) as cohort_index
	from Transactions t
	join first_purchase f
	on t.CustomerID = f.CustomerID),
cohort_counts as(
select
	cohort_month,
	cohort_index,
	count(distinct CustomerID) as
	active_customers
	from base
	group by cohort_month, cohort_index)
select
	c.cohort_month,
	c.cohort_index,
	c.active_customers,
	ROUND(1.0 * c.active_customers / s.active_customers, 2) as retention_rate
	from cohort_counts c
	join cohort_counts s
	on c.cohort_month = s.cohort_month
	and s.cohort_index = 0
	order by cohort_month, cohort_index

-- COHORT WTH STRONGEST LONG TERM RETENTION
WITH first_purchase as (
	select
		CustomerID,
		min(InvoiceDate) as
	first_purchase_date
		from Transactions
		where CustomerID is not null
		group by CustomerID
),
base as(
	select 
	t.CustomerID,

DATEFROMPARTS(year(f.first_purchase_date),
		month(f.first_purchase_date), 1) as cohort_month,
	DATEDIFF(month, f.first_purchase_date, t.InvoiceDate) as cohort_index
	from Transactions t
	join first_purchase f
	on t.CustomerID = f.CustomerID
),
cohort_counts as (
	select
		cohort_month,
		cohort_index,
		count(distinct CustomerID) as customers
		from base
		group by cohort_month,cohort_index),

cohort_size as (
	select
		cohort_month,
		customers as cohort_size
		from cohort_counts
		where cohort_index = 0
	),
retention as (
	select
		c.cohort_month,
		c.cohort_index,
		c.customers,
		s.cohort_size,
		ROUND(1.0 * c.customers / s.cohort_size, 4) as retention_rate
		from cohort_counts c
		join cohort_size s
		on c.cohort_month = s.cohort_month)
select
	cohort_month,
	retention_rate
from retention
where cohort_index = 6    --Can be changed to 12 for longer term
order by retention_rate desc