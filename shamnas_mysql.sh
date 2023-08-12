start=$(date +%s%3N)

DB_USER="root"

DB_PASSWORD="newpassword"

DB_NAME="mydatabase"

 

CSV_FILE="/home/shamnas/Documents/employee_details.csv"

while IFS="," read -r id username email password firstname lastname jobtitle company city state postalcode; do

mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "INSERT INTO employee (id,username,email,password,firstname,lastname,jobtitle,company,city,state,postalcode) VALUES ('$id','$username','$email','$password','$firstname','$lastname','$jobtitle','$company','$city','$state','$postalcode');"

done < "$CSV_FILE"
end=$(date +%s%3N)
execution_time=$((end - start))
echo "Execution time: $execution_time ms"
