#!/bin/bash
start_time=$(date +%s%3N)

DB_NAME="mydatabase"
CSVDATA="/home/user/main_sql/employee-table.csv"

# Initialize the _values string
_values=""

errors="/home/user/main_sql/errors.txt"

# Validate email function
validate_email() {
    local email=$1
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    return 0
}

# Validate name function - can be used for first name, last name, department
validate_name() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z.\s-]{2,100}$ ]]; then
        return 1
    fi
    return 0
}

# Validate salary function
validate_salary(){
    local salary=$1
    if [[ ! $salary =~ ^[0-9]+$ ]]; then
        return 1
    fi
    return 0
}
# Validate phone function

validate_phone(){
    local phone=$1
    if [[ ! $phone =~ ^[0-9-]+$ ]]; then
        return 1
    fi
    return 0
}

# Validate postal function

validate_postal(){
    local postal=$1
    if [[ ! $postal =~ ^[0-9]+$ ]]; then
        return 1
    fi
    return 0
}

# Validate address function

validate_address(){
    local address=$1
    if [[ ! $address =~ ^[a-zA-Z0-9,.[:space:]]*$ ]]; then
        return 1
    fi
    return 0
}
# Validate date function

validate_date() {
    local date=$1
    if ! [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        return 1
    fi
    return 0
}

# Validate password function

validate_password(){

local password=$1

    if [[ ! $password =~ ^[a-zA-Z0-9_\!\@\#\$\%\^\&\*]{8,40}$ ]]; then
        return 1
    fi
    return 0
}

# Validate position function
validate_position() {
    local position=$1
    if [[ ! $position =~ ^[a-zA-Z[:space:]]*$ ]]; then
        return 1
    fi
    return 0
}






# Reading from CSV File and concatenating values
while IFS=',' read -r First_Name Last_Name Gender Birthdate Department Position Salary Email Password Phone_Number Address City State Postal_Code; 
do
    #Checking for empty fields 
    if [[ -z "$First_Name" || -z "$Last_Name" || -z "$Gender" || -z "$Birthdate" || -z "$Department" || -z "$Position" || -z "$Salary" || -z "$Email" || -z "$Password" || -z "$Phone_Number" || -z "$Address" || -z "$City" || -z "$State" || -z "$Postal_Code" ]]; then
        echo "Empty field detected. Skipping this line." >> $errors
        continue
    fi

    #validate name

    if ! validate_name "$First_Name" && ! validate_name "$Last_Name"; then
        echo "Invalid name: $First_Name $Last_Name. Skipping line." >> $errors
        continue
    fi

    #validate email

    if ! validate_email "$Email"; then
        echo "Invalid email: $Email. Skipping line."  >> $errors
        continue
    fi

     #validate password

    if ! validate_password "$Password"; then
        echo "Invalid password: $Password. Skipping line." >> $errors
        continue
    fi   

    #validate phone

    if ! validate_phone "$Phone_Number"; then
        echo "Invalid phone number: $Phone_Number. Skipping line." >> $errors
        continue
    fi

    #validate postal code

    if ! validate_postal "$Postal_Code"; then
        echo "Invalid postal code: $Postal_Code. Skipping line." >> $errors
        continue
    fi

    #validate date

    if ! validate_date "$Birthdate"; then
        echo "Invalid date format: $Birthdate. Skipping line."  >> $errors
        continue
    fi


    #validate dept
    if ! validate_name "$Department"; then
        echo "Invalid department: $Department. Skipping line." >> $errors
        continue
    fi

    #validate position
    if ! validate_position "$Position"; then
        echo "Invalid position: $Position. Skipping line." >> $errors
        continue
    fi

    #validate address

    if ! validate_address "$Address"; then
        echo "Invalid address format: $Address. Skipping line." >> $errors
        continue
    fi
    
    #validate city
    if ! validate_name "$City"; then
        echo "Invalid city: $City. Skipping line." >> $errors
        continue
    fi

    #validate state
    if ! validate_name "$State"; then
        echo "Invalid city: $State. Skipping line." >> $errors
        continue
    fi


    _values+="('$First_Name', '$Last_Name', '$Gender', '$Birthdate', '$Department', '$Position', '$Salary', '$Email', '$Password', '$Phone_Number', '$Address', '$City', '$State', '$Postal_Code'), "
done < "$CSVDATA"

# Remove trailing comma and space from multi_values
_values="${_values%, }"

# MySQL query to insert the stored values into the database
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "
    INSERT INTO company(First_Name, Last_Name, Gender, Birthdate, Department, Position, Salary, Email, Password, Phone_Number, Address, City, State, Postal_Code)
    VALUES $_values;
"

end_time=$(date +%s%3N)

# Calculating the execution time
execution_time=$((end_time - start_time))
echo "Script execution time: $execution_time ms"
echo "Data inserted successfully."


