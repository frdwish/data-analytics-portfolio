import schedule
import time
from extract import extract_all
from transform import transform
from load import load_to_db, export_excel

def run_pipeline():
    print("🚀 Pipeline starting...")
    try:
        data = extract_all("archive")
        master_df = transform(data)
        load_to_db(master_df)
        export_excel(master_df)
        print("✅ Pipeline complete!")
    except FileNotFoundError:
        print("❌ Error: archive folder not found")
    except Exception as e:
        print(f"❌ Error: {e}")

# ✅ Test mode — fires every 10 seconds
schedule.every(10).seconds.do(run_pipeline)
schedule.every().day.at("08:00").do(run_pipeline)
while True:
    schedule.run_pending()
    time.sleep(1)