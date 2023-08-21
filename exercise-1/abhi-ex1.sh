#!/bin/bash

start_time=$(date +%s%3N)


generate_data() {
    data=""
    nested_array=()
    campaign_ID=$((1 + RANDOM % 10))
    activity=$((1 + RANDOM % 7))
    activity_date="2023-07-01"
    case $activity in
        1)
            nested_array=(1)
            ;;
        2)
            nested_array=(2)
            ;;
        3)
            nested_array=(1 3 4)
            ;;
        4)
            nested_array=(1 3 4 5)
            ;;
        5)
            nested_array=(1 3 4 6)
            ;;
        6)
            nested_array=(1 3 4 5 6)
            ;;
        7)
            nested_array=(1 3 4 7)
            ;;
        *)
            echo "Unknown key: $activity"
            ;;
    esac
    for ((i=0; i<${#nested_array[@]}; i++)); do
        array_value="${nested_array[$i]}"
        activity_date=$(date -d "$activity_date + $((i+1)) days" +%Y-%m-%d)
        activity_string="(@parent_id, $campaign_ID, $array_value, '$activity_date')"
        if [[ $i -ne 0 ]]; then
            data+=", $activity_string"
        else
            data="$activity_string"
        fi
    done
    echo "$data"
}


count=1000000
j=0  

for ((i=1; i<=$count; i++)); do
   
    if [[ $j -lt 1000 ]]; then  
        name="Name$i"
        email="name$i@example.com"
        dob="01/01/2000"
        country="Country$i"
        city="City$i"
        json="{\"dob\":\"$dob\",\"country\":\"$country\",\"city\":\"$city\"}"
        result=$(generate_data)

        batch_data+="INSERT INTO contacts (name, email) VALUES ('$name', '$email');"
        batch_data+="SET @parent_id = LAST_INSERT_ID();"
        batch_data+="INSERT INTO contacts_details (contacts_ID, json) VALUES (@parent_id, '$json');"
        batch_data+="INSERT INTO contacts_activity (contacts_ID, campaign_ID, activity_type, activity_date) VALUES $result;"
        j=$((j+1))  
    else
        mysql --defaults-file=~/.my.cnf -D DB <<EOF
START TRANSACTION;
$batch_data
COMMIT;
EOF


        end_time=$(date +%s%3N)
        execution_time=$((end_time - start_time))

        echo "batch execution time: $execution_time milliseconds"
        j=0
        batch_data=""
    fi

done

end_time=$(date +%s%3N)
execution_time=$((end_time - start_time))

echo "Script execution time: $execution_time milliseconds"