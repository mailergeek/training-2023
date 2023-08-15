#!/bin/bash

# Validate email function
validate_email() {
    local email=$1
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    return 0
}

# Validate name function
validate_name() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z\s-]{2,}$ ]]; then
        return 1
    fi
    return 0
}

# File to process
INPUT_FILE="data/data.csv"

# Iterate over lines in the input file
while IFS= read -r line; do
    # Extract data from the line (modify this part according to your file's format)
    name=$(echo "$line" | cut -d',' -f1)
    email=$(echo "$line" | cut -d',' -f2)
    # Add more fields as needed

    # Validate name and email
    if [[ -z $name || -z $email ]]; then
        echo "Empty name or email field. Skipping line."
        continue
    fi

    if ! validate_name "$name"; then
        echo "Invalid name: $name. Skipping line."
        continue
    fi

    if ! validate_email "$email"; then
        echo "Invalid email: $email. Skipping line."
        continue
    fi

    # Construct the SQL query
    sql_query="INSERT INTO employee (name, email) VALUES ('$name', '$email');"
    
    # Execute the SQL query using the mysql command
    mysql --defaults-file=./config/mysql-config.cnf -e "$sql_query" 

    if [ $? -ne 0 ]; then 
        echo "Error executing SQL query: $sql_query"
        continue
    #else
    #    echo "Inserted data: $name, $email"
    fi
done < "$INPUT_FILE"

echo "Data insertion completed."