# Analytics Engineering with dbt

## Week 2 Project Answers
### What is our user repeat rate?

- **Answer**: There are 0.798 repeat orders per user.
- - **SQL Query**:
  ```sql
  WITH UserPurchaseCounts AS (
      -- Count the number of unique orders for each user
      SELECT 
          USER_ID, 
          COUNT(DISTINCT ORDER_ID) AS PurchaseCount
      FROM 
          STG_POSTGRES__ORDERS
      GROUP BY 
          USER_ID
  )

  -- Calculate the repeat rate
  SELECT 
      CAST(SUM(CASE WHEN PurchaseCount >= 2 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(USER_ID) AS RepeatRate
  FROM 
      UserPurchaseCounts;
  ```

### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
Indicators of a User Likely to Purchase Again:
- Repeat Purchases: Users who have made multiple purchases in the past are generally more likely to purchase again.
- High Engagement: Users who frequently visit the website, spend more time on it, or engage with marketing emails (open rates, click-through rates) are more engaged and thus more likely to make a purchase.
- Positive Reviews/Feedback: Users who leave positive reviews or feedback have had a satisfactory experience and are more likely to return

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
