#!/bin/bash
time1=$(date +%s%3N)
csv_file="/home/user/Downloads/insert.csv"

string=""
while IFS=, read -r  name city country dob username password age designation #!read file
do
string+="('$name', '$city', '$country', '$dob', '$username', '$password', '$age', '$designation'),"   #!stored in variable
done < "$csv_file"

string=$(echo "$string" | sed 's/,$//') #! Remove the trailing comma from batch_sql

insert="INSERT INTO file (name, city, country, dob, username, password, age, designation) VALUES $string"
echo "$insert" |   mysql --defaults-file=~/.my.cnf "vinam_data"




time2=$(date +%s%3N)
time_taken=$(echo "$time2-$time1" |bc)   #!diffrence in time
echo $time_taken "ms"



#!exicuted in 30ms
