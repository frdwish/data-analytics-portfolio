import schedule
import time
from clean_data import clean_data
from export_report import export_report

def run_pipeline():
    import pandas as pd
    print("🚀 Pipeline starting...")
    try:
        df_raw = pd.read_csv('sales_raw.csv')
        df_clean = clean_data(df_raw)
        export_report(df_clean)
        print("✅ Pipeline complete!")
    except FileNotFoundError:
        print("❌ Error: sales_raw.csv not found")
    except Exception as e:
        print(f"❌ Error: {e}")

schedule.every(10).seconds.do(run_pipeline)

while True:
    schedule.run_pending()
    time.sleep(1)