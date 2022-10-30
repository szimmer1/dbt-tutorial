### About the project
This project follows the dbt labs [getting started guide](https://docs.getdbt.com/docs/get-started/getting-started/overview), but for a local postgres database.

### Install
MacOS requirements:

* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Homebrew](https://brew.sh/)
* dbt (`brew update && brew tap dbt-labs/dbt && brew install dbt-postgres`)

### Create the database and load the data
Create the postgres container with `docker-compose up -d`. This creates a persistent volume for postgres internal data, and mounts the raw data directory to be accessible by the postgres container.
This will also create an Adminer container accessible at http//localhost:8080. Your postgres server name is the container name `dbt_tutorial_postgres`.

Create the following schema. Either use the SQL console (`docker exec -it dbt_tutorial_postgres psql -U postgres`) or Adminer UI.
```
create schema if not exists jaffle_shop;
create schema if not exists stripe;

create table jaffle_shop.customers(
  id integer,
  first_name varchar(50),
  last_name varchar(50)
);

create table jaffle_shop.orders(
  id integer,
  user_id integer,
  order_date date,
  status varchar(50),
  _etl_loaded_at timestamp default current_timestamp
);

create table stripe.payment(
  id integer,
  orderid integer,
  paymentmethod varchar(50),
  status varchar(50),
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

```

Copy data from files into the tables:
```
COPY jaffle_shop.customers FROM '/var/lib/dbt-tutorial/data/jaffle_shop_customers.csv' CSV HEADER;
COPY jaffle_shop.orders (id, user_id, order_date, status) FROM '/var/lib/dbt-tutorial/data/jaffle_shop_orders.csv' CSV HEADER;
COPY stripe.payment (id, orderid, paymentmethod, status, amount, created) FROM '/var/lib/dbt-tutorial/data/stripe_payments.csv' CSV HEADER;
```

You should now be able to successfully run `dbt run` and see that table `analytics.customers` was created in postgres.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
