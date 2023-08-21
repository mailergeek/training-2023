array_letter=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "u" "v" "z")
array_domain=("gmail.com" "yahoo" "outlook.com")
array_country=("usa" "india" "china" "uae" "thailand" "uk" "spain" "itali")
array_length=${#array_letter[@]}
echo $array_length
for ((j=0 ; j<1000000 ; j++));do
  random_number=$(( (RANDOM % 6) + 1 ))
    for ((i = 0; i < random_number; i++)); do
        random_index=$(( RANDOM % array_length ))
        random_character=${array_letter[random_index]}
        name+="${random_character}"
    done

  echo "$name "
    random_index1=$(( RANDOM % 3 ))
    random_domain=${array_domain[random_index1]}
    email="$name@$random_domain"
    echo "$email"
    last_inserted_id=$(mysql --defaults-file=~/.my1.cnf "vinam_data" -se "INSERT INTO contact (name, email) VALUES ('$name','$email');  SELECT LAST_INSERT_ID();")
     
      result=${last_inserted_id##*)}
     id=$((result))

    echo "$id"

    
    
     name=""
     email=""


   for ((i = 1; i < 11; i++)); do
    random_number=$(( (RANDOM % 6) + 2 ))

     for ((j = 1; j <= random_number; j++)); do

   
       
        declare -A date
          date["1"]="2023-05-06"
          date["2"]="2023-05-13"
          date["3"]="2023-05-26"
          date["4"]="2023-06-04"
          date["5"]="2023-06-13"
          date["6"]="2023-06-17"
          date["7"]="2023-06-22"

        contactID=$id
        campaignID=$i
        activityType=$j
        activityDate="${date[$activityType]}"

       
        insert_table2="INSERT INTO contact_activity (contactsID, campaignID, activityType,activityDate ) VALUES ('$contactsID', '$campaignID','$activityType','$activityDate');"
        echo "$insert_table2" |   mysql --defaults-file=~/.my1.cnf "vinam_data"
        echo "$contactsID.$campaignID.$activityType.$activityDate"
     done
  done

 
 contactsID="$last_inserted_id"
 random_index2=$(( RANDOM % 8 ))
 country=${array_country[random_index2]}
 echo "$country"
 city="$country"."$contactsID"
 random_year=$(( (RANDOM % (2023 - 2022 + 1)) + 2022 ))
 random_month=$(( (RANDOM % 12) + 1 ))
 random_date=$(( (RANDOM % 30) + 1 ))
 DOB="$random_year"."$random_month"."$random_month"

  insert_table3="INSERT INTO contact_details (contactsID, DOB, city, country) VALUES ('$contactsID', '$DOB','$city','$country');"
  echo "$insert_table3" |   mysql --defaults-file=~/.my1.cnf "vinam_data"
  echo "DOB"
  
done


