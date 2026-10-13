# Tension Climbing SQL database
DISCLAIMER: (This project was worked on junction with Joshua Carr at Western Colorado University)

This project is a relational database built in MySQL that tracks the operations of the climbing/training brand "Tension Climbing". It tracks customers, orders, inventory, and the full production (saw -> machine -> finish -> prepack). This repo contains an ERD, a one file schema and sample dataset, 11 analytical queries, and 2 stored procedures. 

## Overview:
Tension sells wood products that are manufactured in house, and soft products that purchased and resold. Customers are either individuals or gyms, and employees are able to place orders at a discount as well. 

This database is designed to answer simple operational questions about the day to day of the business. 

## Schema
 
16 tables in three groups:
 
| Group | Tables | What they hold |
|---|---|---|
| **People** | `customer`, `gym`, `employee` | Customers (individuals and gyms), gym-specific details, and staff with their equipment specialty |
| **Sales & inventory** | `product`, `wood_product`, `soft_product`, `order`, `product_order`, `employee_order` | The product catalog, orders, line items, and employee purchases with discounts |
| **Production** | `wood`, `saw`, `machine`, `wood_machine`, `finish`, `wood_finish`, `prepack` | Wood batches moving through sawing, machining, and finishing, plus prepacked stock |

## Basic outline of how to run
 
**Requirements:** MySQL 8.0 or newer.
 
1. Create an empty database.
```sql
   CREATE DATABASE tension_climbing;
```
 
2. Load the schema and sample data, then the stored procedures.
```bash
   mysql -u <user> -p tension_climbing < "sql/Tension Database Dump.sql"
   mysql -u <user> -p tension_climbing < "sql/Tension Database Stored Procedures.sql"
```
 
3. Run the analytical queries
```bash
   mysql -u <user> -p tension_climbing < "sql/Tension Database Queries.sql"
```
 
All data is made up (all the names are some of my favorite pro climbers :) )

## Repository structure
 
```
.
├── README.md
├── docs/
│   ├── Tension Climbing Database ERD.pdf   # full ERD with design notes
└── sql/
    ├── Tension Database Dump.sql           # schema + sample data
    ├── Tension Database Queries.sql        # 11 analytical queries
    └── Tension Database Stored Procedures.sql # 2 stored procedures
