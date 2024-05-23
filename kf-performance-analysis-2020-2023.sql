/* INTRODUCTORY
This is the Rakamin Kimia Farma final task of creating a performance 
dashboard of Kimia Farma from 2020 - 2023
*/

/*
Improve tables efficiency by adding Primary key and Foreign key
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
Create analysis table with columns were based on Rakamin Kimia Farma final task PDF.
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
  END AS persentase_gross_laba,
  (ft.price - (ft.price * ft.discount_percentage / 100)) AS nett_sales,
  SUM(ft.price) OVER (PARTITION BY date ORDER BY EXTRACT(DAY FROM date)) AS nett_profit,
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

-- Specify the analysis_table Primary key and Foreign key
ALTER TABLE `rakamin-kf-analytics-423804.kimia_farma.analysis_table`
  ADD PRIMARY KEY(transaction_id) NOT ENFORCED,
  ADD FOREIGN KEY(branch_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_kantor_cabang`(branch_id) NOT ENFORCED,
  ADD FOREIGN KEY(product_id) REFERENCES `rakamin-kf-analytics-423804.kimia_farma.kf_product`(product_id) NOT ENFORCED
;



