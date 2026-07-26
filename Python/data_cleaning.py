import pandas as pd


# Load Dataset

file_path = "Dataset/online_retail_II.xlsx"

df_2009 = pd.read_excel(file_path, sheet_name="Year 2009-2010")
df_2010 = pd.read_excel(file_path, sheet_name="Year 2010-2011")

# Merge both years
df = pd.concat([df_2009, df_2010], ignore_index=True)


print("ORIGINAL DATASET")

print("Rows:", len(df))


# Remove Duplicate Rows


duplicates = df.duplicated().sum()
print("\nDuplicate Rows:", duplicates)

df = df.drop_duplicates()


# Remove Missing Description


missing_description = df["Description"].isna().sum()
print("Missing Description:", missing_description)

df = df.dropna(subset=["Description"])

# Remove Cancelled Orders


cancelled = df["Invoice"].astype(str).str.startswith("C").sum()
print("Cancelled Orders:", cancelled)

df = df[~df["Invoice"].astype(str).str.startswith("C")]


# Remove Invalid Quantity


invalid_quantity = (df["Quantity"] <= 0).sum()
print("Invalid Quantity:", invalid_quantity)

df = df[df["Quantity"] > 0]


# Remove Invalid Price


invalid_price = (df["Price"] <= 0).sum()
print("Invalid Price:", invalid_price)

df = df[df["Price"] > 0]


# Convert Date


df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

# Feature Engineering


df["Total Sales"] = df["Quantity"] * df["Price"]
df["Year"] = df["InvoiceDate"].dt.year
df["Month"] = df["InvoiceDate"].dt.month_name()
df["Month Number"] = df["InvoiceDate"].dt.month
df["Quarter"] = "Q" + df["InvoiceDate"].dt.quarter.astype(str)
df["Day"] = df["InvoiceDate"].dt.day
df["Weekday"] = df["InvoiceDate"].dt.day_name()
df["Hour"] = df["InvoiceDate"].dt.hour


# Final Report

print("CLEANED DATASET")


print("Rows:", len(df))
print("Columns:", len(df.columns))

print("\nMissing Values:")
print(df.isnull().sum())

df.rename(columns={
    "Invoice": "invoice",
    "StockCode": "stock_code",
    "Description": "description",
    "Quantity": "quantity",
    "InvoiceDate": "invoice_date",
    "Price": "price",
    "Customer ID": "customer_id",
    "Country": "country"
}, inplace=True)

# Export

output_path = "Dataset/retail_sales.csv"

df.to_csv(output_path, index=False)

print("\nClean dataset saved successfully!")
print(output_path)