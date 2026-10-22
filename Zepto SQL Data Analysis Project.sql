# data base creation
CREATE DATABASE zepto_db;
USE zepto_db;
# table creation
CREATE TABLE zepto (
    Category TEXT,
    name TEXT,
    mrp TEXT,
    discountPercent TEXT,
    availableQuantity TEXT,
    discountedSellingPrice TEXT,
    weightInGms TEXT,
    outOfStock TEXT,
    quantity TEXT
);
#analysis begins


/* 1. Category assortment concentration - Is the product catalogue balanced across 
categories, or is the assortment heavily concentrated in a few categories? */

select Category, count(*) as 'Category Count' from zepto
group by Category
order by count(*) DESC;

/* 2. Catalogue availability and stockout exposure - categories where unavailable 
products could weaken the customer shopping experience. out of stock proportion 
in accordance to its total availability*/

SELECT
    Category,
    COUNT(*) AS Total_Products,
    SUM(CASE
        WHEN outOfStock = 'TRUE' THEN 1
        ELSE 0
    END) AS Out_Of_Stock_Count,
    ROUND(
        SUM(CASE
            WHEN outOfStock = 'TRUE' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Stockout_Rate_Percentage
FROM zepto
GROUP BY Category
ORDER BY Stockout_Rate_Percentage DESC;

/* 3. Discount strategy by category, to find which categories rely most heavily on discounts.*/

SELECT
    Category,
    COUNT(*) AS total_products,
    ROUND(AVG(discountPercent), 2) AS avg_discount_percent,
    MAX(discountPercent) AS max_discount_percent,
    SUM(CASE
        WHEN discountPercent > 0 THEN 1
        ELSE 0
    END) AS discounted_products,
    ROUND(
        SUM(CASE WHEN discountPercent > 0 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS discounted_product_share
FROM zepto
GROUP BY Category
ORDER BY avg_discount_percent DESC;

/* 4. Category level - product listed price vs actual SP */
select * from zepto;
select Category, 
round(avg(mrp/100), 2)as 'Avg listed Price', 
round(avg(discountedSellingPrice/100),2) as 'Avg Selling Price',
round(avg(mrp - discountedSellingPrice)/100,2) as 'Avg Price Difference',
round(avg((mrp - discountedSellingPrice) * 100.0/ NULLIF(mrp, 0)),2) AS 'Avg Markdown %'
FROM zepto
GROUP BY Category
ORDER BY 'Avg Price Difference' DESC;

/* 5. which category has the higher and lower end products, Category price positioning */

SELECT Category,
ROUND(AVG(discountedSellingPrice / 100), 2)AS avg_selling_price,
ROUND(MIN(discountedSellingPrice / 100), 2)AS lowest_price,
ROUND(MAX(discountedSellingPrice / 100), 2)AS highest_price,
ROUND((MAX(discountedSellingPrice) -MIN(discountedSellingPrice)) / 100,2) AS price_range
FROM zepto
GROUP BY Category
ORDER BY avg_selling_price DESC;
/* 6. the same product appears in multiple pack sizes, do prices scale consistently with size */

SELECT Distinct Category,name,weightInGms,
ROUND(discountedSellingPrice / 100.0, 2) AS selling_price,
ROUND((discountedSellingPrice / 100.0)/ NULLIF(weightInGms, 0) * 1000,2) AS price_per_kg
FROM zepto
WHERE weightInGms > 0
ORDER BY Category, name, weightInGms;

/* 7. Category wise price band distribution (low/mid/high) */
SELECT Category, COUNT(*) AS total_products,
ROUND(SUM(CASE WHEN discountedSellingPrice < 10000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
AS low_price_pct,
ROUND(SUM(CASE WHEN discountedSellingPrice >= 10000 AND discountedSellingPrice < 50000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
AS medium_price_pct,
ROUND(SUM(CASE WHEN discountedSellingPrice >= 50000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
AS high_price_pct
FROM zepto
GROUP BY Category
ORDER BY total_products DESC;

/* 8. Which categories have the highest proportion of products offered at steep discounts */
select * from zepto;
SELECT CASE
WHEN discountPercent = 0 THEN 'No Discount'
WHEN discountPercent < 10 THEN 'Low Discount (<10%)'
WHEN discountPercent < 20 THEN 'Medium Discount (10-19%)'
ELSE 'Deep Discount (20%+)' 
END AS discount_band,
COUNT(*) AS total_products,
SUM(CASE WHEN outOfStock = 'TRUE' THEN 1 ELSE 0 END) AS out_of_stock_count,
ROUND(SUM(CASE WHEN outOfStock = 'TRUE' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS stockout_rate_pct
FROM zepto
GROUP BY discount_band
ORDER BY stockout_rate_pct DESC;

/* 9. Are fresh-product listings priced consistently and supported by reliable weight information? */
SELECT Category, COUNT(*) AS total_listings,
SUM(CASE WHEN weightInGms IS NULL OR weightInGms <= 0 THEN 1 ELSE 0
    END) AS invalid_weight_listings,
ROUND(SUM(CASE WHEN weightInGms IS NULL OR weightInGms <= 0 THEN 1 ELSE 0
	END) * 100.0 / COUNT(*),2) AS invalid_weight_pct,
ROUND(AVG(CASE WHEN weightInGms > 0 THEN discountedSellingPrice * 10.0 / weightInGms ELSE NULL
	END),2) AS avg_price_per_100g,
ROUND(SUM(CASE WHEN outOfStock = 'TRUE' THEN 1 ELSE 0
     END) * 100.0 / COUNT(*),2) AS stockout_rate_pct
FROM zepto
WHERE Category = 'Fruits & Vegetables'
GROUP BY Category;

/* 10.Deep-discount dependency by category   */
SELECT Category, COUNT(*) AS total_products,
SUM(CASE WHEN discountPercent >= 20 THEN 1 ELSE 0
    END) AS deeply_discounted_products,
ROUND( SUM(CASE WHEN discountPercent >= 20 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2
    ) AS deep_discount_share_pct,
ROUND(AVG(discountPercent), 2) AS avg_discount_pct
FROM zepto
GROUP BY Category
ORDER BY deep_discount_share_pct DESC;






