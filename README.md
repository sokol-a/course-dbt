# Analytics Engineering with dbt

## Week 1 Project Answers

### 1. How many users do we have?

- **Answer**: There are 130 users.

- **SQL Query**:
  ```sql
  SELECT COUNT(*) as NUM_OF_USERS
  FROM DEV_DB.DBT_ALEKSEEVADDGMAILCOM.STG_POSTGRES__USERS;
  ```

### 2. On average, how many orders do we receive per hour?

- **Answer**: We receive 7.68 orders per hour.

- **SQL Query**:
  ```sql
  WITH TimeRange AS (
      SELECT
          MIN(CREATED_AT) AS StartTimestamp,
          MAX(CREATED_AT) AS EndTimestamp
      FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_ORDERS
  ),
  TotalHours AS (
      SELECT
          TIMESTAMPDIFF(HOUR, StartTimestamp, EndTimestamp) AS HoursDifference
      FROM TimeRange
  )
  SELECT
      (SELECT COUNT(*) FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_ORDERS) / HoursDifference AS AverageOrdersPerHour
  FROM TotalHours;
  ```

### 3. On average, how long does an order take from being placed to being delivered?

- **Answer**: It takes 93.4 hours on average.

- **SQL Query**:
  ```sql
  SELECT
      AVG(TIMESTAMPDIFF(HOUR, CREATED_AT, DELIVERED_AT)) AS AverageDeliveryTimeInHours
  FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_ORDERS
  WHERE DELIVERED_AT IS NOT NULL;
  ```

### 4. How many users have only made one purchase? Two purchases? Three+ purchases?

- **Answer**: 
  - 25 users who made 1 purchase
  - 28 users who made 2 purchases
  - 71 users who made 3+ purchases

- **SQL Query**:
  ```sql
  WITH UserPurchaseCount AS (
      SELECT
          USER_ID,
          COUNT(ORDER_ID) AS NumberOfPurchases
      FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_ORDERS
      GROUP BY USER_ID
  )
  SELECT
      SUM(CASE WHEN NumberOfPurchases = 1 THEN 1 ELSE 0 END) AS OnePurchaseUsers,
      SUM(CASE WHEN NumberOfPurchases = 2 THEN 1 ELSE 0 END) AS TwoPurchaseUsers,
      SUM(CASE WHEN NumberOfPurchases >= 3 THEN 1 ELSE 0 END) AS ThreeOrMorePurchaseUsers
  FROM UserPurchaseCount;
  ```

### 5. On average, how many unique sessions do we have per hour?

- **Answer**: We have 10.14 unique sessions per hour.

- **SQL Query**:
  ```sql
  WITH TimeRange AS (
      SELECT
          MIN(CREATED_AT) AS StartTimestamp,
          MAX(CREATED_AT) AS EndTimestamp
      FROM YourTableName
  ),
  TotalHours AS (
      SELECT
          TIMESTAMPDIFF(HOUR, StartTimestamp, EndTimestamp) AS HoursDifference
      FROM TimeRange
  ),
  UniqueSessions AS (
      SELECT
          COUNT(DISTINCT SESSION_ID) AS TotalUniqueSessions
      FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_POSTGRES__EVENTS
  )
  SELECT
      TotalUniqueSessions / HoursDifference AS UniqueSessionsPerHour
  FROM UniqueSessions, TotalHours;
  ```


## License

GPL-3.0
