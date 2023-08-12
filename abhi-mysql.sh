#!/bin/bash
start_time=$(date +%s%3N)
DB_NAME="new"
TABLE_NAME="employee"
csv_file="employee_details.csv"


awk -F, 'NR>1 { printf "INSERT INTO employee (username, email, password, first_name, last_name, job_title, company, city, state, postal_code) VALUES (\x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27);\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 }' $csv_file > insert_data.sql

mysql --defaults-file=~/.my.cnf $DB_NAME < insert_data.sql

end_time=$(date +%s%3N) 
execution_time=$(( end_time - start_time ))  

if [ $? -eq 0 ]; then
    echo "Insertion completed successfully in $execution_time milliseconds."
else
    echo "Insertion failed."
fi

