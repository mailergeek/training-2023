#!/bin/bash

generate_name() {
    local names=("Alice" "Bob" "Charlie" "David" "Eve" "Frank" "Grace" "Henry" "arya" "rahul")
    echo "${names[$RANDOM % ${#names[@]}]}"
}

generate_domain() {
    local domain=("@gmail.com" "@yahoo.com" "@example.com")
    echo "${domain[$RANDOM % ${#domain[@]}]}"
}

generate_campaign() {
    campaign=(1 2 3 4 5 6 7 8 9 10)
    echo "${campaign[$RANDOM % ${#campaign[@]}]}"
}

num_entries=1000000
DB_NAME="invoicing"

declare -a countries=("india" "usa" "russia" "pakistan")
sql_query=""
j=0

for ((i=0; i<=num_entries; i++)); do

        name=$(generate_name)
        domain=$(generate_domain)
        email="$name$RANDOM${domain}"

        sql_query+="INSERT INTO contacts (name,email) VALUES ('$name','$email');"  
        sql_query+="SET @p_id= LAST_INSERT_ID();"

        DOB=$(date -d "now - $((RANDOM % 7300)) days" +"%Y-%m-%d")
        country="${countries[RANDOM % ${#countries[@]}]}"
        city="$country $((RANDOM % 25 + 1))"
        details="{\"dob\":\"$DOB\",\"country\":\"$country\",\"city\":\"$city\"}"
        sql_query+="INSERT INTO contacts_details (contacts_id,details) VALUES (@p_id,'$details');"

        campaignid=$(generate_campaign)

        for ((z = 1; z <= $campaignid; z++)); do
            random_num=$((1 + RANDOM % 100))
         if [[ $random_num -gt 10 ]]; then
         activitytype=1
         else
         activitytype=2
         fi
         activitydate=$(date -d "now - $((RANDOM % 1095)) days" +"%Y-%m-%d")
         sql_query+="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES(@p_id,'$z','$activitytype','$activitydate');"

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
            sql_query+="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES(@p_id,'$z','$activitytype','$activitydate');"

            activitytype="$((RANDOM % 3 + 4))" # Random value between 4 and 6
            activitydate=$(date -d "$activitydate + $((RANDOM % 3)) days" +"%Y-%m-%d")
            sql_query+="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES(@p_id,'$z','$activitytype','$activitydate');"

            if [[ $activitytype -eq 4 ]]; then
                activitytype="$((RANDOM % 3 + 5))"  # Random value between 5 and 7
                activitydate=$(date -d "$activitydate + $((RANDOM % 3)) days" +"%Y-%m-%d")
                sql_query+="INSERT INTO contact_activity (contactsid,campaignid,activitytype,activitydate) VALUES(@p_id,'$z','$activitytype','$activitydate');"
            fi
          fi
    fi
        done
        echo "$i"
        j=$((j+1))
     if [[ $j -eq 1000 ]]; then
        # Execute all accumulated SQL queries
        mysql --defaults-file=~/.my.cnf -D "$DB_NAME" <<EOF
        START TRANSACTION;
        $sql_query
        COMMIT;
EOF
        sql_query=""
        j=0
        echo " batch inserted"
    fi
    
    
done

echo "Complete"


# SELECT
#     c.ID,
#     c.Name,
#     c.email,
#     cd.details->"$.dob" AS DOB,
#     cd.details->"$.country" AS Country,
#     cd.details->"$.city" AS City,
#     COUNT(ca.id) AS TotalActivities
# FROM contacts c
# JOIN contact_activity ca ON c.id = ca.contactsid
# JOIN contacts_details cd ON c.id = cd.contacts_id
# WHERE ca.ActivityType = "4"
#   AND ca.ActivityDate >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
# GROUP BY c.id, cd.details->"$.dob", cd.details->"$.country", cd.details->"$.city"
# ORDER BY TotalActivities DESC
# LIMIT 5;

