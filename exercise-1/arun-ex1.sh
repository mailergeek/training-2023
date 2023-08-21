
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

DB_NAME="mydatabase"  # mydatabase name
output_file="random_data.txt"

declare -a countries=("india" "usa" "rusia" "pakistan")

# Iterate over lines in the input file

while IFS="," read -r name email; 
do

 sql_query="INSERT INTO contacts (name,email) VALUES ('$name','$email');SELECT LAST_INSERT_ID();"  #
 
 result=$(mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_query")
 id=$(echo "$result" | grep -o '[0-9]\+')
 echo "$id"
 DOB=$(date -d "now - $((RANDOM % 7300)) days" +"%Y %m %d") #generate random DOB
 country="${countries[$RANDOM % ${#countries[@]}]}"  #generate random Country
 city="$country $((RANDOM % 25 + 1))"                # generate random city
 details={\"dob\":\"$DOB\",\"country\":\"$country\",\"city\":\"$city\"}  # storing DOB,Country,city as a json format
 sql_details_query="INSERT INTO contacts_details (contacts_id,details)VALUES('$id','$details');"   #store inert query of contact details table
  mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_details_query"                    #insert into table contact details
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

DB_NAME="mydatabase"  # mydatabase name
output_file="random_data.txt"

declare -a countries=("india" "usa" "rusia" "pakistan")

# Iterate over lines in the input file

while IFS="," read -r name email; 
do

 sql_query="INSERT INTO contacts (name,email) VALUES ('$name','$email');SELECT LAST_INSERT_ID();"  #
 
 result=$(mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_query")
 id=$(echo "$result" | grep -o '[0-9]\+')
 echo "$id"
 DOB=$(date -d "now - $((RANDOM % 7300)) days" +"%Y %m %d") #generate random DOB
 country="${countries[$RANDOM % ${#countries[@]}]}"  #generate random Country
 city="$country $((RANDOM % 25 + 1))"                # generate random city
 details={\"dob\":\"$DOB\",\"country\":\"$country\",\"city\":\"$city\"}  # storing DOB,Country,city as a json format
 sql_details_query="INSERT INTO contacts_details (contacts_id,details)VALUES('$id','$details');"   #store inert query of contact details table
  mysql --defaults-file=~/.my.cnf -D "$DB_NAME" -e "$sql_details_query"                    #insert into table contact details
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

