# Analytics Engineering with dbt

## Week 3 Project Answers
### What is our overall conversion rate?
- **Answer**: around 62.5% 
- **Query**
    ```sql
    SELECT 
        (SELECT COUNT(DISTINCT session_id) 
        FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.FACT_PURCHASE_EVENTS) 
        /
        (SELECT COUNT(DISTINCT session_id) 
        FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_POSTGRES__EVENTS) 
    AS ratio;
    ```
### What is the conversion rate by product?
| PRODUCT_NAME         | PURCHASE_SESSIONS | VIEW_SESSIONS | PURCHASE_RATIO  |
|----------------------|------------------|---------------|-----------------|
| Pothos               | 21               | 61            | 0.3442622951    |
| Bamboo               | 36               | 67            | 0.5373134328    |
| Philodendron         | 30               | 62            | 0.4838709677    |
| Monstera             | 25               | 49            | 0.5102040816    |
| String of pearls     | 39               | 64            | 0.609375        |
| ZZ Plant             | 34               | 63            | 0.5396825397    |
| Snake Plant          | 29               | 73            | 0.397260274     |
| Orchid               | 34               | 75            | 0.4533333333    |
| Birds Nest Fern      | 33               | 78            | 0.4230769231    |
| Calathea Makoyana    | 27               | 53            | 0.5094339623    |
| Peace Lily           | 27               | 66            | 0.4090909091    |
| Bird of Paradise     | 27               | 60            | 0.45            |
| Fiddle Leaf Fig      | 28               | 56            | 0.5             |
| Ficus                | 29               | 68            | 0.4264705882    |
| Pilea Peperomioides  | 28               | 59            | 0.4745762712    |
| Angel Wings Begonia  | 24               | 61            | 0.393442623     |
| Jade Plant           | 22               | 46            | 0.4782608696    |
| Arrow Head           | 35               | 63            | 0.5555555556    |
| Majesty Palm         | 33               | 67            | 0.4925373134    |
| Spider Plant         | 28               | 59            | 0.4745762712    |
| Money Tree           | 26               | 56            | 0.4642857143    |
| Cactus               | 30               | 55            | 0.5454545455    |
| Devil's Ivy          | 22               | 45            | 0.4888888889    |
| Alocasia Polly       | 21               | 51            | 0.4117647059    |
| Pink Anthurium       | 31               | 74            | 0.4189189189    |
| Dragon Tree          | 29               | 62            | 0.4677419355    |
| Aloe Vera            | 32               | 65            | 0.4923076923    |
| Rubber Plant         | 28               | 54            | 0.5185185185    |
| Ponytail Palm        | 28               | 70            | 0.4             |
| Boston Fern          | 26               | 63            | 0.4126984127    |

**SQL**
```sql
WITH PurchaseSessions AS (
    SELECT DISTINCT
        product_id,
        session_id
    FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.FACT_PURCHASE_EVENTS
),
ViewSessions AS (
    SELECT DISTINCT
        product_id,
        session_id
    FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.FACT_PAGE_VIEWS
),
PurchaseRatios AS (
    SELECT
        v.product_id,
        COUNT(DISTINCT p.session_id) AS purchase_sessions,
        COUNT(DISTINCT v.session_id) AS view_sessions
    FROM ViewSessions v
    LEFT JOIN PurchaseSessions p ON v.product_id = p.product_id AND v.session_id = p.session_id
    GROUP BY v.product_id
)
SELECT
    pr.product_id,
    p.name as product_name,
    pr.purchase_sessions,
    pr.view_sessions,
    CASE
        WHEN pr.view_sessions = 0 THEN NULL
        ELSE pr.purchase_sessions / pr.view_sessions::FLOAT
    END AS purchase_ratio
FROM PurchaseRatios pr
JOIN DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.STG_POSTGRES__PRODUCTS p ON pr.PRODUCT_ID = p.PRODUCT_ID  
```

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

Indicators of a User Likely to NOT Purchase Again
- Negative Reviews/Feedback: Users who have had a bad experience are less likely to return.
- Long Periods of Inactivity: If a user hasn't visited the site or engaged with the brand in a long time, they might have lost interest.
- Abandoned Carts: Frequently adding products to the cart but not purchasing might indicate hesitation or issues with the purchasing process.

### Queries on `fact_page_views`
 - Daily Page Views
   ```sql
   SELECT 
     f.date_key AS date,
     f.product_id,
     COUNT(f.page_view_id) AS daily_page_views
   FROM DEV_DB.DBT_ALEKSANDERSOKOL9GMAILCOM.FACT_PAGE_VIEWS f
   GROUP BY f.date_key, f.product_id
   ORDER BY f.date_key, daily_page_views DESC;
   ```

### Explain the product mart models you added. Why did you organize the models in the way you did?
I have added 3 models, `fact_page_views`, `dim_user` and `dim_date`. This is how I've organised them:
- `fact_page_views` is located in product since we can use this table to find out about how our products are performing (traffic etc.)
- `dim_user` is located in the core folder because it's a table that will likely be used by many other fact tables
- `dim_date` is also located in core for the same reason

### DAG
![dbt-dag](https://github.com/sokol-a/course-dbt/assets/62120019/687b88c1-e642-4fb0-a28a-96a1da696aed)

### Tests
- `fact_page_views`:
    Assumption: Every page view should have a unique identifier.
    Test: Uniqueness test on page_view_id.
    Assumption: Essential attributes of a page view event (like the user, session, page URL, and timestamp) should always be recorded.
    Test: Not NULL checks on these columns.
    Assumption: The data in this table should relate to valid users and valid dates.
    Test: Foreign key relationships for user_id and date_key.
- `dim_user`:
    Assumption: Each user should have a unique identifier.
    Test: Uniqueness test on user_id.
    Assumption: Basic user details (like name and email) should always be recorded.
    Test: Not NULL checks.
    Assumption: Email should follow the standard email format.
    Test: Email format validation.
    Assumption: There's an association between users and addresses.
    Test: Foreign key relationship check on address_id (based on the content provided).

- `dim_date`:
    Assumption: Each date should have a unique entry.
    Test: Uniqueness test on the date.
    Assumption: Essential date attributes like year, quarter, month, etc., should always be populated.
    Test: Not NULL checks on these columns.

- `stg_postgres__users`:
    Assumption: Each user in the staging table should have a unique identifier.
    Test: Uniqueness test on user_id.
    Assumption: Basic user details should always be recorded.
    Test: Not NULL checks.
    Assumption: Email should adhere to the standard format.
    Test: Email format validation.
- `stg_postgres__promos`:
    Assumption: Each promo should have a unique identifier.
    Test: Uniqueness test on promo_id.
    Assumption: Essential promo details like discount and status should always be recorded.
    Test: Not NULL checks.

- `stg_postgres__products`:
    Assumption: Each product should have a unique identifier.
    Test: Uniqueness test on product_id.
    Assumption: Essential product details like name and price should always be recorded.
    Test: Not NULL checks.

- `stg_postgres__orders`:
    Assumption: Each order should have a unique identifier.
    Test: Uniqueness test on order_id.
    Assumption: Essential order details like user, creation timestamp, and total should always be recorded.
    Test: Not NULL checks.

- `stg_postgres__order_items`:
    Assumption: Essential details like quantity should always be recorded.
    Test: Not NULL checks.
    Assumption: The data should relate to valid orders and valid products.
    Test: Foreign key relationships.

- `stg_postgres__events`:
    Assumption: Each event should have a unique identifier.
    Test: Uniqueness test on event_id.
    Assumption: Essential event details like session, user, and timestamp should always be recorded.
    Test: Not NULL checks.

- `stg_postgres__addresses`:
    Assumption: Each address should have a unique identifier.
    Test: Uniqueness test on address_id.
### Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

**Automate Test Execution:**

Scheduled Runs: Use dbt's scheduler or a tool like Apache Airflow to run dbt run (for transformations) and dbt test (for data tests) on a daily basis or at the desired frequency. This ensures that tests are executed consistently.
Continuous Integration: Integrate dbt within your CI/CD pipeline. Every time there's a change to the dbt models or tests, automatically run the tests to ensure nothing breaks.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Monitoring and Alerts:**

Integration with Monitoring Tools: Tools like Datadog, Prometheus, or others can be integrated with dbt runs to monitor the success or failure of the jobs.
Notification on Failure: If a dbt test fails, set up immediate notifications. This can be achieved using:
- Email Alerts: Send automated emails to the data team or designated stakeholders.
- Slack Notifications: Use webhooks to send messages to specific Slack channels.
- PagerDuty: For critical data issues, integrate with incident management platforms.

### Which products had their inventory changed?
- Pothos
- Bamboo
- Philodendron
- Monstera
- String of pearls
- ZZ Plant

  
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
