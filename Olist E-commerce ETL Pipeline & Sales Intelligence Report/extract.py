import pandas as pd
import os

def extract_all(folder_path):
    datasets = {}
    
    files = os.listdir(folder_path)
    for file in files:
        if file.endswith(".csv"):
            full_path = os.path.join(folder_path, file)
            name = file.replace(".csv", "")  # use filename as key
            datasets[name] = pd.read_csv(full_path)
            print(f" Loaded: {file} — {len(datasets[name])} rows")
    
    return datasets  # {"olist_orders_dataset": df, "olist_order_items_dataset": df, ...}

# Calling it
if __name__ == "__main__": #the code will run only when main file is running not when imported
    data = extract_all("archive")
    print(data["olist_orders_dataset"].head())