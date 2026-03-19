import pandas as pd
from extract import extract_all
def transform(data):
    
    # Step 1 — orders + items
    df = data["olist_orders_dataset"].merge(
        data["olist_order_items_dataset"], on="order_id", how="left"
    )

    # Step 2 — + products (builds on step 1)
    df = df.merge(
        data["olist_products_dataset"], on="product_id", how="left"
    )

    # Step 3 — + category translation (builds on step 2)
    df = df.merge(
        data["product_category_name_translation"], on="product_category_name", how="left"
    )

    # Step 4 — + customers (builds on step 3)
    df = df.merge(
        data["olist_customers_dataset"], on="customer_id", how="left"
    )

    # Step 5 — convert dates
    date_cols = ["order_purchase_timestamp", "order_delivered_customer_date", "order_estimated_delivery_date"]
    for col in date_cols:
        df[col] = pd.to_datetime(df[col])

    # Step 6 — delivered orders only
    df = df[df['order_status'] == 'delivered']

    print(f" Transform done — {len(df)} delivered orders")
    print(f" Shape: {df.shape}")
    return df

if __name__ == "__main__":
   data = extract_all("archive")
   master_df = transform(data)
   print(master_df.shape)
   print(master_df.head())