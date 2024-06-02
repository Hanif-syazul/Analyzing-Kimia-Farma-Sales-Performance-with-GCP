/* INTRODUCTORY
This is SQL Script contains the process of querying or creating the analysis table in Challenge of Creating 
the Kimia Farma Business Performance Analysis.
Author: Hanif Sya Zul
*/

/*
First, we have to improve tables efficiency by adding their Primary key and Foreign key
*/

-- Adding Primary key
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.kf_final_transaction`
  ADD PRIMARY KEY(transaction_id) NOT ENFORCED
;
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.kf_kantor_cabang`
  ADD PRIMARY KEY(branch_id) NOT ENFORCED
;
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.kf_product`
  ADD PRIMARY KEY(product_id) NOT ENFORCED
;

-- Adding Foreign key
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.kf_final_transaction`
  ADD FOREIGN KEY(branch_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_kantor_cabang`(branch_id) NOT ENFORCED,
  ADD FOREIGN KEY(product_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_product`(product_id) NOT ENFORCED
;


/*
And the main query, create analysis table with columns were based on Rakamin Kimia Farma final task PDF.
*/

CREATE TABLE kimia_farma.analysis_table AS
SELECT 
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  ft.discount_percentage,
  CASE
    WHEN ft.price <= 50000 THEN 10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 25
    WHEN ft.price > 500000 THEN 30
  END AS persentase_gross_laba, -- Labeling each price ranges in percentages
  (ft.price - (ft.price * ft.discount_percentage / 100)) AS nett_sales, -- This calculate the real price after discount
  SUM(ft.price) OVER (PARTITION BY date ORDER BY EXTRACT(DAY FROM date)) AS nett_profit, -- The sum of price of every day profit
  ft.rating AS rating_transaksi 
FROM 
  `rakamin-kf-analytics-423804.kimia_farma.kf_final_transaction` AS ft
LEFT JOIN
  `rakamin-kf-analytics-423804.kimia_farma.kf_kantor_cabang` AS kc
  ON ft.branch_id = kc.branch_id
LEFT JOIN 
  `rakamin-kf-analytics-423804.kimia_farma.kf_product` AS p
  ON ft.product_id = p.product_id
ORDER BY
  ft.date DESC
;

-- Lastly, specify the analysis_table Primary key and Foreign key
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.analysis_table`
  ADD PRIMARY KEY(transaction_id) NOT ENFORCED,
  ADD FOREIGN KEY(branch_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_kantor_cabang`(branch_id) NOT ENFORCED,
  ADD FOREIGN KEY(product_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_product`(product_id) NOT ENFORCED
;



