#  Olist E-commerce ETL Pipeline & Sales Intelligence Report

An automated ETL (Extract, Transform, Load) pipeline built on the real-world [Olist Brazilian E-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The pipeline ingests 8 raw CSV files, merges and cleans 100k+ orders, loads them into a SQLite database, and auto-generates a styled Excel KPI report — all scheduled to run automatically.

---

##  Project Structure

```
Olist E-commerce ETL Pipeline/
│
├── archive/                        # Raw Kaggle CSV files (8 datasets)
│   ├── olist_orders_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_customers_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
│
├── extract.py                      # E — Load all CSVs into memory
├── transform.py                    # T — Merge, clean & enrich data
├── load.py                         # L — Save to SQLite + Excel report
├── scheduler.py                    # Auto-run pipeline on a schedule
│
├── ecommerce.db                    # SQLite database (auto-generated)
└── olist_report.xlsx               # Excel KPI report (auto-generated)
```

---

##  ETL Pipeline Flow

```
EXTRACT     →     TRANSFORM     →     LOAD     →     SCHEDULE
  │                   │                 │                │
Load 8 CSVs      Merge 5 tables    Save to SQLite    Runs daily
into dict        Clean dates       Export Excel       at 08:00
                 Filter delivered  KPI Report         automatic
                 orders only
```

---

##  KPIs Generated

| KPI | Description |
|-----|-------------|
|  Total Revenue | Sum of all delivered order prices |
|  Top 5 Categories | Highest revenue product categories (English) |
|  Monthly Orders | Order volume trend month by month |
|  Avg Delivery Days | Mean days from purchase to delivery |

---

##  Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/frdwish/Data-Analysis.git
cd "Olist E-commerce ETL Pipeline & Sales Intelligence Report"
```

### 2. Install dependencies
```bash
pip install pandas openpyxl schedule
```

### 3. Download the dataset
Download from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place all CSV files inside an `archive/` folder.

### 4. Run the full pipeline manually
```bash
python load.py
```

### 5. Run on a schedule (auto daily at 8am)
```bash
python scheduler.py
```

---

##  Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

| File | Rows | Description |
|------|------|-------------|
| olist_orders_dataset | 99,441 | Order status & timestamps |
| olist_order_items_dataset | 112,650 | Products per order, price & freight |
| olist_customers_dataset | 99,441 | Customer location data |
| olist_products_dataset | 32,951 | Product details & categories |
| olist_order_payments_dataset | 103,886 | Payment method & value |
| olist_order_reviews_dataset | 99,224 | Customer review scores |
| olist_sellers_dataset | 3,095 | Seller location data |
| product_category_name_translation | 71 | Portuguese → English categories |

---

##  Key Concepts Used

- **ETL Pipeline** — Extract, Transform, Load architecture
- **Relational Data Merging** — Joining 5 tables via shared keys (`order_id`, `product_id`, `customer_id`)
- **Data Cleaning** — Date conversion, filtering, handling nulls
- **SQLite** — Lightweight database storage
- **Excel Automation** — `openpyxl` for styled multi-sheet reports
- **Task Scheduling** — `schedule` library for automated daily runs
- **Modular Design** — Each pipeline stage in its own file

---

##  Output

After running the pipeline you'll get:

- **`ecommerce.db`** — SQLite database with 110,197 cleaned delivered orders across 27 columns
- **`olist_report.xlsx`** — Styled Excel report with 3 sheets: Summary KPIs, Top Categories, Monthly Orders

---

##  Tech Stack

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-green?logo=pandas)
![SQLite](https://img.shields.io/badge/SQLite-Database-lightgrey?logo=sqlite)
![OpenPyXL](https://img.shields.io/badge/OpenPyXL-Excel%20Automation-brightgreen)
![Schedule](https://img.shields.io/badge/Schedule-Task%20Automation-orange)

---

##  Author

**frdwish** — [GitHub](https://github.com/frdwish)
