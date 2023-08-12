#!/bin/bash


start_time=$(date +%s%3N)


DB_NAME="new"
TABLE_NAME="employee"

# Process the CSV file using awk
awk -F, -v total_rows=$(wc -l < employee_details.csv) 'NR>1 {
    # Print the header line just above the data
    if (NR == 2) {
        printf "INSERT INTO employee (username, email, password, first_name, last_name, job_title, company, city, state, postal_code) VALUES ";
    } else {
        printf ", ";
    }
    
    # Print formatted values for each column
    printf "(\x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27, \x27%s\x27)", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10;
}

# Print the semicolon at the end if there is data
END {
    if (NR > 1) {
        printf ";\n";
    }
}' employee_details.csv | mysql --defaults-file=~/.my.cnf $DB_NAME    # Passing the output using piipeline

end_time=$(date +%s%3N)

execution_time=$(( end_time - start_time ))


if [ $? -eq 0 ]; then
    echo "Insertion completed successfully in $execution_time milliseconds."
else
    echo "Insertion failed."
fi


