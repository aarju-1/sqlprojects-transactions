SELECT amount FROM first_database.transactions_data;

ALTER TABLE transactions_data
add column amount_numeric INT;
set sql_safe_updates = 0;
UPDATE transactions_data
set amount_numeric = cast(cast(replace(amount,'$','') AS DECIMAL(10,2)) AS signed);

set sql_safe_updates = 1;

alter table transactions_data
drop column amount;

ALTER TABLE transactions_data
CHANGE amount_numeric amount INT;

-- average spending on which category
select avg(amount) as average_amount,mcc
from transactions_data
group by mcc
order by average_amount desc ;

-- frequent transaction on which category
select count(*) as frequency, mcc
from transactions_data
group by mcc
order by frequency desc;

-- client with most spending
select sum(amount) as total_sum, avg(amount) as avg_amount,client_id
from transactions_data
group by client_id
order by avg_amount desc;

-- frequency of transaction by customers
select count(*) as frequency, client_id
from transactions_data
group by client_id
order by frequency desc;

SELECT mcc, COUNT(DISTINCT client_id) AS unique_clients
FROM transactions_data
GROUP BY mcc
ORDER BY unique_clients DESC;

select client_id, count(distinct(mcc)) as counting
from transactions_data
group by client_id
order by counting desc;

-- percentage of people who made repetitive purchase where threshold is 10 purchase
SELECT (multiple_mcc_clients * 100.0 / total_unique_clients) AS percentage_multiple_mcc_clients 
FROM (
    SELECT COUNT(*) AS multiple_mcc_clients
    FROM (
        SELECT client_id
        FROM transactions_data
        GROUP BY client_id
        HAVING COUNT(DISTINCT mcc) > 10
    ) AS clients_with_multiple_mccs
) AS multiple_clients,
(
    SELECT COUNT(DISTINCT client_id) AS total_unique_clients
    FROM transactions_data
) AS total_clients;

-- client who interacted with more purchase (highvalue customers)
SELECT client_id
FROM transactions_data
group by client_id
HAVING COUNT(DISTINCT mcc) > 20;

-- client who interacted with less purchase
SELECT client_id
FROM transactions_data
group by client_id
HAVING COUNT(DISTINCT mcc) <  10;

CREATE TABLE first_database.negative_transactions AS
SELECT distinct(mcc)
FROM transactions_data
WHERE amount < 0;

CREATE TABLE first_database.positive_transactions AS
SELECT distinct(mcc)
FROM transactions_data
WHERE amount > 0;

-- refunds in these categories
select count(mcc) as frequency, mcc
from transactions_data
where amount < 0
group by mcc
order by frequency desc;

select count(*),client_id,errors,mcc,date,amount
from transactions_data
WHERE errors like '%Tec%'
group by errors,client_id,mcc,date,amount;





