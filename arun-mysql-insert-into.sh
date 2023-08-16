time1=$(date +%s%3N)


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
#validate username
validate_username() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z0-9]*$ ]]; then
         return 1
    fi
    return 0
}

#validate job_title function
validate_job_title() {
    local title=$1
    if [[ ! $title =~ ^[A-Za-z[:space:]()\,/]*$ ]]; then
        return 1
    fi
    return 0
}
#validate postal_code function

validate_postal_code() {
    local postal_code=$1
    if [[ ! $postal_code =~ ^[0-9]+$ ]]; then
        return 1
    fi
    return 0
}
#validate password function
validate_password(){
    local password=$1
    if [[ ! $password =~ ^[A-Za-z0-9,\?\@\!\#\$\%\^\&\*()-_\+\=\\]{8,}*$ ]]; then
       return 1
    fi
    return 0   
}

DB_NAME="mydatabase"  # mydatabase name
CSV_FILE="/home/arun/Downloads/employees - employee_details.csv"  #my csv file path
TABLE_NAME="Employee"  # Replace with your actual table name
error_file="/home/arun/Downloads/error.txt"   #error file path


# Iterate over lines in the input file

while IFS="," read -r username email password first_name last_name job_title company city state postal_code; 
do
 
 #validating all fields
 if [[ -z $username || -z $email || -z $password || -z $first_name || -z $last_name || -z $job_title || -z $company || -z $city || -z $state || -z $postal_code ]]; then
        echo "Empty id,username, email , password ,first_name,lastname_name,job_title ,company ,city ,state or postal_code  field. Skipping line." >> "$error_file"
        continue
    fi


 if ! validate_username "$username"; then
        echo "Invalid username: $username. Skipping line." >> "$error_file"
        continue
    fi

 if ! validate_email "$email"; then
        echo "Invalid email: $email. Skipping line." >> "$error_file"
        continue
    fi
 if ! validate_password "$password"; then
        echo "Invalid email: $password. Skipping line." >> "$error_file"
        continue
    fi
 if ! validate_name "$first_name";then
      echo "invalid first_name :$first_name.Skipping line." >> "$error_file"
       continue
    fi
  if ! validate_name "$last_name";then
      echo "invalid last_name :$last_name.Skipping line." >> "$error_file"
       continue
    fi 
  if !  validate_job_title "$job_title" ;then
      echo "invalid job_title :$job_title .skipping line." >> "$error_file"
      continue
    fi
  if ! validate_job_title "$city" ;then
     echo "invalid city :$city .Skipping line." >> "$error_file"
     continue
    fi
    if ! validate_job_title "$state" ;then
     echo "invalid state :$state.Skipping line." >> "$error_file"
     continue
    fi
    if ! validate_postal_code "$postal_code" ;then 
     echo "invalid postal_code :$postal_code .Skipping line." >> "$error_file" 
    continue
    fi  

     # Construct the SQL query
    sql_query="INSERT INTO Employee (username,email,password,first_name,last_name,job_title,company,city,state,postal_code) VALUES ('$username','$email','$password','$first_name','$last_name','$job_title','$company','$city','$state','$postal_code');"
      # Connect to the database and insert the values
      mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_query"
    if [ $? -ne 0 ]; then 
        echo "Error executing SQL query: $sql_query" >> "$error_file"
        continue
    fi
done < "$CSV_FILE"




time2=$(date +%s%3N)

difftime=$(($time2-$time1))
echo "$difftime ms"

