#!/bin/bash
start_time=$(date +%s%3N)

DB_HOST="localhost"

DB_NAME="mydatabase"

CSV_FILE="/home/user/emp.csv"
  
#Reading from CSV File and passing values to a variable using a while loop
cat $CSV_FILE>>output.txt| while IFS=',' read -r First_Name Last_Name Gender Birthdate Department Position Salary Email Password Phone_Number Address City State Postal_Code; do
    multi_values="('$First_Name', '$Last_Name', '$Gender', '$Birthdate', '$Department', '$Position', '$Salary', '$Email', '$Password', '$Phone_Number', '$Address', '$City', '$State', '$Postal_Code'),"

done 

#mysql query to insert the stored values to database
mysql --defaults-file=~/.my.cnf  -D "$DB_NAME" -e \ <<EOF
INSERT INTO your_table_name (First_Name, Last_Name, Gender, Birthdate, Department, Position, Salary, Email, Password, Phone_Number, Address, City, State, Postal_Code)
VALUES  "$multi_values";
EOF

end_time=$(date +%s%3N)

#calculating the execution time
execution_time=$((end_time - start_time))
echo "Script execution time: $execution_time ms"
echo "Data inserted successfully."



