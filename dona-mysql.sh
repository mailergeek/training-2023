#!/bin/bash
start_time=$(date +%s%3N)

DB_NAME="mydatabase"
CSV_FILE="/home/user/main_sql/employee-table.csv"

# Initialize the multi_values string
multi_values=""

# Reading from CSV File and concatenating values
while IFS=',' read -r First_Name Last_Name Gender Birthdate Department Position Salary Email Password Phone_Number Address City State Postal_Code; do
    multi_values+="('$First_Name', '$Last_Name', '$Gender', '$Birthdate', '$Department', '$Position', '$Salary', '$Email', '$Password', '$Phone_Number', '$Address', '$City', '$State', '$Postal_Code'), "
done < "$CSV_FILE"

# Remove trailing comma and space from multi_values
multi_values="${multi_values%, }"

# MySQL query to insert the stored values into the database
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "
    INSERT INTO company(First_Name, Last_Name, Gender, Birthdate, Department, Position, Salary, Email, Password, Phone_Number, Address, City, State, Postal_Code)
    VALUES $multi_values;
"

end_time=$(date +%s%3N)

# Calculating the execution time
execution_time=$((end_time - start_time))
echo "Script execution time: $execution_time ms"
echo "Data inserted successfully."


