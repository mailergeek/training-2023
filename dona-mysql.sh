#!/bin/bash
start_time=$(date +%s%3N)


DB_NAME="mydatabase"


CSV_FILE="/home/user/emp.csv"
cat $CSV_FILE>>output.txt| while IFS=',' read -r First_Name Last_Name Gender Birthdate Department Position Salary Email Password Phone_Number Address City State Postal_Code; do
  
    mysql  --defaults-file=~/.my.cnf  -D "$DB_NAME" -e \
    "INSERT INTO company(First_Name, Last_Name, Gender, Birthdate, Department, Position, Salary, Email, Password, Phone_Number, Address, City, State, Postal_Code) VALUES ('$First_Name', '$Last_Name', '$Gender', '$Birthdate', '$Department', '$Position', '$Salary', '$Email', '$Password', '$Phone_Number', '$Address', '$City', '$State', '$Postal_Code');"
done
end_time=$(date +%s%3N) 
execution_time=$((end_time - start_time))
echo "Script execution time: $execution_time ms"
echo "Data inserted successfully."


