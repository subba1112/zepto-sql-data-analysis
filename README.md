# Zepto SQL Data Analysis

## 📌 Project Overview

This project analyzes a Zepto product catalogue using SQL to uncover insights related to **product categories, pricing, discounts, stock availability, product weights, and price positioning**.

The project demonstrates how SQL can be used to transform product-level data into meaningful business insights that can support pricing, inventory, assortment, and promotional decisions.

---

## 🎯 Business Objectives

The analysis focuses on answering questions such as:

- How concentrated is the product assortment across categories?
- Which categories have the highest stockout rates?
- Which categories rely most heavily on discounts?
- How does the listed price compare with the actual selling price?
- Which categories contain the highest- and lowest-priced products?
- Does pricing scale consistently across different product pack sizes?
- What proportion of products falls into low, medium, and high price bands?
- Which discount levels are associated with higher stockout rates?
- Are fresh products supported by reliable weight information?
- Which categories have the highest dependency on deep discounts?

---

## 🗄️ Database Structure

The project creates a database named:

```sql
zepto_db
```

and a table named:

```sql
zepto
```

The table contains the following fields:

| Column | Description |
|---|---|
| `Category` | Product category |
| `name` | Product name |
| `mrp` | Listed/MRP price |
| `discountPercent` | Discount percentage |
| `availableQuantity` | Available quantity |
| `discountedSellingPrice` | Discounted selling price |
| `weightInGms` | Product weight in grams |
| `outOfStock` | Product stock availability |
| `quantity` | Product quantity/pack information |

---

## 🔍 Analysis Performed

### 1. Category Assortment Concentration

Analyzes the number of products listed in each category to understand whether the catalogue is balanced or concentrated in a few categories.

### 2. Category-Level Stockout Analysis

Calculates:

- Total products
- Out-of-stock products
- Stockout rate percentage

This helps identify categories with higher availability risk.

### 3. Discount Strategy by Category

Measures:

- Average discount
- Maximum discount
- Number of discounted products
- Share of products receiving discounts

This helps understand category-level promotional strategies.

### 4. Listed Price vs Selling Price

Compares the average listed price with the average discounted selling price and calculates the average markdown.

### 5. Category Price Positioning

Analyzes:

- Average selling price
- Lowest selling price
- Highest selling price
- Price range

This provides a view of how different categories are positioned by price.

### 6. Pack-Size and Price Consistency

Examines products available in different weights and calculates **price per kilogram** to compare pricing across pack sizes.

### 7. Category Price Band Distribution

Classifies products into:

- Low-price products
- Medium-price products
- High-price products

and calculates their percentage distribution by category.

### 8. Discount Band and Stockout Analysis

Groups products into discount bands:

- No Discount
- Low Discount (<10%)
- Medium Discount (10–19%)
- Deep Discount (20%+)

and compares their stockout rates.

### 9. Fresh Product Pricing and Weight Quality

For the **Fruits & Vegetables** category, the analysis evaluates:

- Total listings
- Invalid or missing weights
- Invalid weight percentage
- Average price per 100g
- Stockout rate

### 10. Deep-Discount Dependency

Identifies categories with a high proportion of products receiving discounts of **20% or more** and compares their average discount percentage.

---

## 🛠️ SQL Concepts Used

This project demonstrates practical use of:

- `CREATE DATABASE`
- `CREATE TABLE`
- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `ROUND()`
- `CASE WHEN`
- `NULLIF()`
- `DISTINCT`
- Aggregate calculations
- Percentage calculations
- Price and discount
