time1=$(date +%s%3N)
DB_NAME="mydatabase"

CSV_FILE="/home/arun/Downloads/employees - employee_details.csv"

while IFS="," read -r id username email password first_name last_name job_title company city state postal_code; do
mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "INSERT INTO Employee (id,username,email,password,first_name,last_name,job_title,company,city,state,postal_code) VALUES ('$id','$username','$email','$password','$first_name','$last_name','$job_title','$company','$city','$state','$postal_code');"
done < "$CSV_FILE"


time2=$(date +%s%3N)

difftime=$(($time2-$time1))
echo "$difftime ms"
