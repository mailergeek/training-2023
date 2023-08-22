start_time=$(date +%s%3N)
array_letter=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "u" "v" "z")
array_domain=("gmail.com" "yahoo" "outlook.com")
array_country=("usa" "india" "china" "uae" "thailand" "uk" "spain" "itali")
array_length=${#array_letter[@]}
b=0
data=""
for ((a=0 ; a<1000000 ; a++));do 
b=$((b+1))
echo $a
        # random name generation
  random_number=$(( (RANDOM % 6) + 1 ))
    for ((i = 0; i < random_number; i++)); do
        random_index=$(( RANDOM % array_length ))              
        random_character=${array_letter[random_index]}
        name+="${random_character}"
    done

    #  random email generation
    random_index1=$(( RANDOM % 3 ))
    random_domain=${array_domain[random_index1]}
    email="$name@$random_domain"
    # insert query stored in bach_data
    batch_data+="INSERT INTO contact (name, email) VALUES ('$name','$email');"
    batch_data+="SET @id = LAST_INSERT_ID();"
    #  clrear name and email
     name=""   
     email=""

    # loop to chose 1-10 campaign 
   for ((i = 1; i < 11; i++)); do
    random_number=$(( (RANDOM % 6) + 2 ))

      # loop to chose random campaign activity
     for ((j = 1; j <= random_number; j++)); do

   
       
        declare -A date
          date["1"]="2023-05-06"
          date["2"]="2023-05-13"
          date["3"]="2023-05-26"
          date["4"]="2023-06-04"
          date["5"]="2023-06-13"
          date["6"]="2023-06-17"
          date["7"]="2023-06-22"

        
        campaignID=$i
        activityType=$j
        activityDate="${date[$activityType]}"

      #  store values to string variable
       string+="(@id, '$campaignID','$activityType','$activityDate')," 
     done
        
  done
    # remove last ,
    string=${string%,} 
      batch_data+="INSERT INTO contact_activity (contactsID, campaignID, activityType,activityDate )  VALUES $string;"

     string=""
#  generate country
 random_index2=$(( RANDOM % 8 ))
 country=${array_country[random_index2]}

 city="$country"."$contactsID"
 random_year=$(( (RANDOM % (2023 - 2022 + 1)) + 2022 ))
 random_month=$(( (RANDOM % 12) + 1 ))
 random_date=$(( (RANDOM % 30) + 1 ))
 DOB="$random_year"."$random_month"."$random_month"
  batch_data+="INSERT INTO contact_details (contactsID, DOB, city, country) VALUES (@id, '$DOB','$city','$country');"
 

  if [[ $b -gt 1000 ]]; then
    
    # mysql insert
    mysql --defaults-file=~/.my.cnf -D vinam_data <<EOF
  START TRANSACTION;
  $batch_data
  COMMIT;
EOF
# clear bach_data
 batch_data=""

end_time=$(date +%s%3N)
execution_time=$((end_time - start_time))

echo "Script execution time: $execution_time milliseconds"
b=0
fi

done

end_time=$(date +%s%3N)
execution_time=$((end_time - start_time))

echo "Script execution time: $execution_time milliseconds"




# solution
# SELECT campaignID ,COUNT(activityType) AS count_of_abusive FROM `contact_activity` WHERE activityType=5 AND activityDate >= DATE_SUB(CURRENT_DATE,INTERVAL 3 MONTH)
# GROUP BY campaignID
# ORDER BY count_of_abusive DESC
# LIMIT 5 ;"
