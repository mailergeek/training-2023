#!/bin/bash
time1=$(date +%s%3N)
csv_file="/home/user/Downloads/insert.csv"


sql_string=""
while IFS=, read -r  name city country dob username password age designation
do
   
  sql_string+="INSERT INTO file( name, city, country, dob, username, password, age, designation) VALUES ('$name', '$city', '$country', '$dob', '$username', '$password', '$age', '$designation');"

done < "$csv_file"
echo " $sql_string" |mysql --defaults-file=~/.my.cnf "vinam_data" 
time2=$(date +%s%3N)
time_taken=$(echo "$time2-$time1" |bc)
echo $time_taken
