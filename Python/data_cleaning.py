import pandas as pd

# ============================
# Load Both Sheets
# ============================

file_path = r"Dataset/online_retail_II.xlsx"

df_2009 = pd.read_excel(file_path, sheet_name=0)
df_2010 = pd.read_excel(file_path, sheet_name=1)

print("2009-2010 Rows:", len(df_2009))
print("2010-2011 Rows:", len(df_2010))

# ============================
# Merge Both Sheets
# ============================

df = pd.concat([df_2009, df_2010], ignore_index=True)

print("Total Rows:", len(df))

# ============================
# Remove Duplicate Rows
# ============================

duplicates = df.duplicated().sum()
print("Duplicate Rows:", duplicates)

df = df.drop_duplicates()

# ============================
# Remove Cancelled Orders
# Invoice starts with C
# ============================

df = df[~df["Invoice"].astype(str).str.startswith("C")]

# ============================
# Remove Invalid Quantity
# ============================

df = df[df["Quantity"] > 0]

# ============================
# Remove Invalid Price
# ============================

df = df[df["Price"] > 0]

# ============================
# Convert Date
# ============================

df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

# ============================
# Feature Engineering
# ============================

df["Total Sales"] = df["Quantity"] * df["Price"]

df["Year"] = df["InvoiceDate"].dt.year

df["Month"] = df["InvoiceDate"].dt.month_name()

df["Month Number"] = df["InvoiceDate"].dt.month

df["Quarter"] = "Q" + df["InvoiceDate"].dt.quarter.astype(str)

df["Day"] = df["InvoiceDate"].dt.day

df["Weekday"] = df["InvoiceDate"].dt.day_name()

df["Hour"] = df["InvoiceDate"].dt.hour

# ============================
# Missing Customer ID
# Keep It
# ============================

missing_customer = df["Customer ID"].isna().sum()

print("Missing Customer IDs:", missing_customer)

# ============================
# Final Shape
# ============================

print("\nFinal Dataset")

print(df.shape)

# ============================
# Export CSV
# ============================

output_file = "Dataset/retail_sales.csv"

df.to_csv(output_file, index=False)

print("\nClean dataset saved successfully!")

print(output_file)