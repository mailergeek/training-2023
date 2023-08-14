time1=$(date +%s%3N)
DB_NAME="mydatabase"
CSV_FILE="/home/arun/Downloads/employees - employee_details.csv"
TABLE_NAME="Employee"  # Replace with your actual table name


mult_value=""

while IFS="," read -r id username email password first_name last_name job_title company city state postal_code; 
do
 mult_value+="('$id','$username','$email','$password','$first_name','$last_name','$job_title','$company','$city','$state','$postal_code'),"
done < "$CSV_FILE"

# Remove the trailing comma from mult_values
mult_value="${mult_value%,}"

# mult_value=$(echo "$mult_value" | sed 's/,$//')

# Connect to the database and insert the values
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "
INSERT INTO $TABLE_NAME(id,username,email,password,first_name,last_name,job_title,company,city,state,postal_code)
VALUES  $mult_value;
"


time2=$(date +%s%3N)

difftime=$(($time2-$time1))
echo "$difftime ms"
