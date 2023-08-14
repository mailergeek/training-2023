start=$(date +%s%3N)
DB_NAME="mydatabase"
CSV_FILE="/home/shamnas/Documents/employee_details.csv"
TABLE_NAME="employee" 


my_value=""

while IFS="," read -r id username email password firstname lastname jobtitle company city state postalcode; 
do
 my_value+="('$id','$username','$email','$password','$firstname','$lastname','$jobtitle','$company','$city','$state','$postalcode'),"
done < "$CSV_FILE"

# Remove the trailing comma from my_values
my_value="${my_value%,}"

# my_value=$(echo "$my_value" | sed 's/,$//')

# Connect to the database and insert the values
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "
INSERT INTO $TABLE_NAME(id,username,email,password,firstname,lastname,jobtitle,company,city,state,postalcode)
VALUES  $my_value;
"
end=$(date +%s%3N)
execution_time=$((end - start))
echo "Execution time: $execution_time ms"
