
#!/bin/bash

start_time=$(date +%s%3N)

DB_NAME="employee"
TABLE_NAME="employee"

CSV_FILE="employee_details.csv"

validate_username() {
    local uname=$1
    if [[ ! $uname =~ ^[a-zA-Z\s-]+ ]]; then
        return 1
    fi
    return 0
}

# Validate email function
validate_email() {
    local email=$1
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Invalid email format: $email"
        return 1
    fi
    return 0
}

validate_password() {
    local password="$1"

    if [[ ! $password =~ ^[a-zA-Z0-9_\!\@\#\$\%\^\&\*]{4,40}$ ]]; then

        return 1

    fi

    return 0
}


# Validate name function
validate_name() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z\s-]+ ]]; then
        return 1
    fi
    return 0
}

validate_postal_code() {
    local postal_code="$1"
    # Check if the postal code is a valid format (assuming a 5-digit format)
    if [[ ! $postal_code =~ ^[a-zA-Z0-9\s-]+ ]]; then
        echo "Invalid postal code format: $postal_code"
        return 1
    fi

    return 0
}

declare -a valid_data



while IFS= read -r line; do
    username=$(echo "$line" | cut -d',' -f1)
    email=$(echo "$line" | cut -d',' -f2)
    password=$(echo "$line" | cut -d',' -f3) 
    first_name=$(echo "$line" | cut -d',' -f4) 
    last_name=$(echo "$line" | cut -d',' -f5)
    job_title=$(echo "$line" | cut -d',' -f6) 
    company=$(echo "$line" | cut -d',' -f7)
    city=$(echo "$line" | cut -d',' -f8) 
    state=$(echo "$line" | cut -d',' -f9) 
    postal_code=$(echo "$line" | cut -d',' -f10)

    if [[ -z $username || -z $email || -z $password || -z $first_name || -z $last_name || -z $job_title || -z $company || -z $city || -z $state || -z $postal_code ]]; then
        echo "Empty field(s) in line with username: $username. Skipping line."
        continue
    fi

    if ! validate_name "$username"; then
        echo "Invalid username: $username. Skipping line."
        continue
    fi

    if ! validate_email "$email"; then
        continue
    fi

    if ! validate_password "$password"; then
        continue
    fi

    if ! validate_name "$first_name"; then
        continue
    fi

    if ! validate_postal_code "$postal_code"; then
        continue
    fi

    valid_data+=("'$username', '$email', '$password', '$first_name', '$last_name', '$job_title', '$company', '$city', '$state', '$postal_code'")
done < "$CSV_FILE"

if [ ${#valid_data[@]} -gt 0 ]; then
    data_to_insert=$(printf "(%s)," "${valid_data[@]}")
    data_to_insert=${data_to_insert%,}

    mysql --defaults-file=~/.my.cnf $DB_NAME <<EOF
INSERT INTO $TABLE_NAME (username, email, password, first_name, last_name, job_title, company, city, state, postal_code)
VALUES $data_to_insert;
EOF

    if [ $? -eq 0 ]; then
        end_time=$(date +%s%3N)
        execution_time=$((end_time - start_time))
        echo "Insertion completed successfully in $execution_time milliseconds."
    else
        echo "Insertion failed."
    fi
else
    echo "No valid data to insert."
fi

