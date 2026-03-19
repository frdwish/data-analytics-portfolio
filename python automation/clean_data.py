import pandas as pd

def clean_data(df):
    df = df.copy()
    df['date'] = pd.to_datetime(df['date'])
    df['returned'] = df['returned'].astype(int)
    df = df[df['units_sold'] >= 1]
    df['revenue'] = df['units_sold'] * df['unit_price']
    print(f"✅ Cleaning done — {len(df)} rows remaining")
    return df
# most important kpi
def analyze(df):
    print("===== SALES KPI REPORT =====")
    total = df['revenue'].sum()
    print(f"💰 Total Revenue: ₹{total:,.0f}")
    best_product = df.groupby('product')['revenue'].sum().idxmax()
    print(f"🏆 Best Product: {best_product}")
    top_reps = df.groupby('sales_rep')['revenue'].sum().nlargest(3)
    print(f"👑 Top 3 Reps:\n{top_reps}")
    trend = df.groupby(df['date'].dt.to_period('M'))['revenue'].sum()
    print(f"📈 Monthly Trend:\n{trend}")
    rate = df['returned'].mean() * 100
    print(f"🔁 Return Rate: {rate:.1f}%")

# --- Run the pipeline ---
df_raw = pd.read_csv("sales_raw.csv")
df_clean = clean_data(df_raw)
analyze(df_clean)