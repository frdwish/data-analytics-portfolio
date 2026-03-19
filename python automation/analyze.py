import pandas as pd

def data_health_check(filepath):
    df = pd.read_csv(filepath)

    print("=== DATA HEALTH CHECK ===")
    print(f"Rows: {df.shape[0]}, Columns: {df.shape[1]}")
    print(f"\nMissing values:\n{df.isnull().sum()}")
    print(f"\nDate range: {df['date'].min()} → {df['date'].max()}")
    print(f"\nUnique sales reps: {df['sales_rep'].nunique()}")

data_health_check("sales_raw.csv")
