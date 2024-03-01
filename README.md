# SQL Data Analysis and Reporting

## Table of Contents
1. [Project Description](#project-description)
2. [How to Install and Run the Project](#how-to-install-and-run-the-project)
3. [How to Use the Project](#how-to-use-the-project)
4. [Credentials](#credentials)
5. [Conclusion](#conclusion)

## Project Description
This project focuses on SQL data transformation processes commonly performed by data analysts. It includes the creation of tables, queries, functions, triggers, and stored procedures to streamline the analysis process. The main goal is to answer a specific business question regarding movie rental revenue and provide insights through detailed and summary reports.
### Business Question
The main goal of this project is to answer a specific business question regarding movie rental revenue. 

### SQL Functions
The project includes the creation of SQL functions such as `update_rental_info()`, `update_detailed()`, and `update_summary()` to automate data updates and aggregation.

### Tables
Various tables are created to store rental data, including `rental_info`, `detailed_table`, and `summary_table`, each serving different levels of granularity and aggregation.

### Triggers
A trigger named `update_summary_trigger()` is created to update the `summary_table` automatically when data is added to the `detailed_table`.

### Stored Procedure
The `refresh_tables()` stored procedure is provided to refresh all tables by extracting raw data and updating them accordingly.

## How to Install and Run the Project
- Ensure PostgreSQL is installed on your system.
- Copy and execute the provided SQL script in your PostgreSQL environment.
- Use SQL client tools to interact with the created tables, functions, triggers, and stored procedures.

## How to Use the Project
- Execute the `refresh_tables()` stored procedure to update all tables.
- Analyze rental data using the provided tables and functions.
- Utilize the summary table to identify top-performing movies by rental revenue.

## Credentials
- No authentication credentials required for this project.

## Conclusion
This SQL script demonstrates how to transform raw rental data into actionable insights by creating tables and functions tailored to a specific business question. By automating data updates and aggregation, it streamlines the analysis process and provides valuable insights for decision-making in the movie rental business.

