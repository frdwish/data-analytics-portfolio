import pandas as pd
from faker import Faker
import random

fake = Faker()

def generate_sales_data (rows = 200):
    products = ["Laptop", "Monitor", "Keyboard", "Mouse", "Headset"]
    regions = ["North", "South", "East", "West"]
    reps = [fake.name() for _ in range(10)]  # 10 sales reps


    data = []
    for _ in range(rows):
        data.append({
            "date": fake.date_between(start_date="-1y", end_date="today"),
            "sales_rep": random.choice(reps),
            "product": random.choice(products),
            "region": random.choice(regions),
            "units_sold": random.randint(1, 50),
            "unit_price": random.choice([299, 199, 49, 29, 79]),
            "returned": random.choice([True, False, False, False])  # 25% return rate
        })

    df = pd.DataFrame(data)
    df.to_csv("sales_raw.csv", index=False)
    print(f"✅ Generated {rows} rows → saved to sales_raw.csv")

generate_sales_data()        