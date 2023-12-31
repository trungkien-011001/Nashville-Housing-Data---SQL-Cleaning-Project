# SQL DATA CLEANING OF NASHVILLE HOUSING DATASET
This project is about cleaning data by using SQL queries to standardize columns, update Null values remove duplicates,... for later using
## 1. About Project:
- The dataset contains information about Housing Sales, Sales date, Housing Value,... in Nashville City
- Data source: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx
- Platform: MS SQL Sever Management
## 2. Project Aim:
- To apply data cleaning techniques to make the dataset become cleaned, consistent in data format and type in order to use for later purposes
## 3. Step-to-step Process:
- Collecting data from the data source
- Importing downloaded data into MS SQL Sever Management Studio
- Using data cleaning techniques on imported data
- Exporting a .xlsx file for the after-cleaned data
## 4. Data Problems to clean:
- Standardizing format for 'Sale_Date' column
- Updating Null values in 'PropertyAddress' column
- Breaking out 'Address' and 'OwnerAddress' column into 'Address', 'City' and 'State' columns
- Change Y and N to Yes and No in "SoldAsVacant" column
- Remove Duplicates by using CTE and Windows Function
- Deleted unused columns
## 5. Products:
- SQL Code (MS SSMS) (uploaded file on Github)
- Cleaned Data in .xlsx file (uploaded file on Github)
