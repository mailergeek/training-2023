# Function to generate a random name
generate_name() {
    local names=("Alice" "Bob" "Charlie" "David" "Eve" "Frank" "Grace" "Henry" "arya" "rahul")
    echo "${names[$RANDOM % ${#names[@]}]}"
}

#function to generate a random domain

generate_domain() {
  local domain=("@gmail.com" "@yahoo.com" "@example.com")
  echo "${domain[$RANDOM % ${#domain[@]}]}"
}
#function to generate a random campaign
generate_campaign(){
 campaign=(1 2 3 4 5 6 7 8 9 10)
  echo "${campaign[$RANDOM % ${#campaign[@]}]}"
}

# Number of entries to generate
num_entries=5000
DB_NAME="mydatabase"  # mydatabase name
output_file="random_data.txt"

> "$output_file"  # clear file data

declare -a countries=("india" "usa" "rusia" "pakistan")




# Generate and store random data
for ((i=0; i<num_entries; i++)); do
    name=$(generate_name)
    domain=$(generate_domain)
    email="$name$RANDOM${domain}"
    echo "$name,$email" >> "$output_file"
done

echo "Random data has been generated and stored in '$output_file'." 

# Iterate over lines in the input file

while IFS="," read -r name email; 
do

 sql_query="INSERT INTO contacts (name,email) VALUES ('$name','$email');SELECT LAST_INSERT_ID();"
 
 result=$(mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_query")

    id=$(echo "$result" | grep -o '[0-9]\+')
    echo "$id"

 DOB=$(date -d "now - $((RANDOM % 7300)) days" +"%Y %m %d")
 country="${countries[$RANDOM % ${#countries[@]}]}"
 city="$country $((RANDOM % 25 + 1))"
 details={\"dob\":\"$DOB\",\"country\":\"$country\",\"city\":\"$city\"}
 sql_details_query="INSERT INTO contacts_details (contacts_id,details)VALUES('$id','$details');"
 sql_activity_query="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES('$id','$campaignid','$activitytype','$activitydate');"
 mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_details_query"
  campaignid=$(generate_campaign)

 for ((i = 1; i < $campaignid; i++)); 
 do
    random_num=$((1 + RANDOM % 100))
   if [[ $random_num -gt 10 ]]; then
    activitytype=1
   else
    activitytype=2
   fi
  activitydate=$(date -d "now - $((RANDOM % 1095)) days" +"%Y-%m-%d")
  sql_activity_query="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES('$id','$i','$activitytype','$activitydate');"
  mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_activity_query"
  
  if [[ $activitytype -eq 1 ]]; then
    act=(0 3)
    random_num=$((1 + RANDOM % 100))
     if [[ $random_num -gt 10 ]]; then
    activitytype=3
    else
    activitytype=0 
    fi
    if [[ $activitytype -eq 3 ]]; then
      activitydate=$(date -d "$activitydate + $((RANDOM % 3)) days" +"%Y-%m-%d")
      sql_activity_query="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES('$id','$i','$activitytype','$activitydate');"
      mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_activity_query"
      activitytype="$((RANDOM % 3 + 4))" #Random value between 4 and 6
      activitydate=$(date -d "$activitydate + $((RANDOM % 3)) days" +"%Y-%m-%d")
      sql_activity_query="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES('$id','$i','$activitytype','$activitydate');"
      mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_activity_query"
      
      if [[ $activitytype -eq 4 ]]; then
        activitytype="$((RANDOM % 3 + 5))"  #Random value between 5 and 7
        activitydate=$(date -d "$activitydate + $((RANDOM % 3)) days" +"%Y-%m-%d")
        sql_activity_query="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES('$id','$i','$activitytype','$activitydate');"
        mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_activity_query"
      fi
    fi

 fi   

 done
  
done < "$output_file"  

echo "insertion compleate"
