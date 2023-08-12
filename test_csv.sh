

#!/bin/bash
time1=$(date +%s%3N)
csv_file="/home/user/Downloads/insert.csv"

batch_sql=()


while IFS=, read -r  name city country dob username password age designation
do
   batch_sql+=(   
    "INSERT INTO file( name, city, country, dob, username, password, age, designation)
    VALUES ('$name', '$city', '$country', '$dob', '$username', '$password', '$age', '$designation');")
          if(( ${#batch_sql[@]} >= batch_size )); then 
		  echo "${batch_sql[@]}" |   mysql --defaults-file=~/.my.cnf "vinam_data"
		  batch_sql=()
	  fi
done < "$csv_file"
time2=$(date +%s%3N)
time_taken=$(echo "$time2-$time1" |bc)
echo $time_taken "ms"
