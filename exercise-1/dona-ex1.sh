#!/bin/bash

start_time=$(date +%s%3N)

#array of date
declare -A activity_dates
activity_dates["1"]="2023-08-21"
activity_dates["2"]="2023-08-22"
activity_dates["3"]="2023-08-23"
activity_dates["4"]="2023-08-24"
activity_dates["5"]="2023-08-25"
activity_dates["6"]="2023-08-26"
activity_dates["7"]="2023-08-27"

#get activity date
function get_activity_date() {
    echo "${activity_dates[$1]}"
}

activity() {
    local data=""
    values=()
    campaign=$((1 + RANDOM % 10))
    random_activity=$((1 + RANDOM % 7))
    activity_date="2023-07-01"
    case $random_activity in
        1) values=(1 3 4 5) ;;
        2) values=(1 3 4 6) ;;
        3) values=(1 3 4 7) ;;
        4) values=(2) ;;
        5) values=(1) ;;
        6) values=(1 3 6 7) ;;
        7) values=(1 3 6) ;;
        8) values=(1 3 7) ;;
        *) values=("out of range") ;;
    esac
    for array_value in "${values[@]}"; do
        activity_date=$(get_activity_date "$array_value")
        activity_string+=("(@last_id, $campaign, '$array_value', '$activity_date')")
    done
    
    activity_values=$(IFS=,; echo "${activity_string[*]}")
    echo "$activity_values"
}

#generate contact data
function contact_data(){
    names=("Dona" "Joseph" "Deleesha" "Edison" "James" "Emma" "Michael" "Olivia" "William" "Ava" "David" "Sophia" "Joseph" "Isabella" "Charles" "Mia" "John" "Amelia" "Robert" "Grace" "Daniel" "Harper" "Matthew" "Sofia" "Andrew" "Scarlett" "Benjamin" "Abigail" "Samuel" "Emily" "Jackson" "Avery" "Christopher" "Chloe" "Joshua" "Ella" "David" "Aria" "John" "Lily" "Ethan" "Layla" "Ryan" "Zoey" "Alexander" "Grace" "James" "Aubrey" "Elijah" "Hannah" "Benjamin" "Ellie" "Samuel" "John" "Mary" "Michael" "Linda" "William" "Susan" "David" "Sarah" "Robert" "Karen" "James" "Patricia" "Richard" "Jennifer" "Charles" "Laura" "Joseph" "Nancy" "Thomas" "Maria")
    domains=("example" "testmail" "domain" "email" "mysite" "webmail" "company" "service" "provider" "online" "net" "org" "co" "shop" "store" "blog" "info" "business" "tech" "xyz")
    countries=("UAE" "UK" "USA" "Uruguay" "Uzbekistan" "Vanuatu" "Venezuela" "Vietnam" "Yemen" "Zambia" "Zimbabwe")
    campaign=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

    _name=${names[$((RANDOM % ${#names[@]}))]}
    _domain=${domains[$((RANDOM % ${#domains[@]}))]}
    _email="user${1}@${_domain}.com"
    _dob=$(date -d "$((RANDOM % 36525)) days ago" +%Y-%m-%d)
    _country=${countries[$((RANDOM % ${#countries[@]}))]}
    _city="${_country}${1}"
    _campaignid=${campaign[$((RANDOM % ${#campaign[@]}))]}

    echo "$_name"
    echo "$_email"
    echo "$_dob"
    echo "$_city"
    echo "$_country"
    echo "$_campaignid"
}


count=1000000
batch=10000
inc=0
group=""
batch_no=0

for ((i=1; i<=$count; i++)); do
        returned_data=($(contact_data "$i"))
        gen_name="${returned_data[0]}"
        gen_email="${returned_data[1]}"
        gen_json="{\"DOB\": \"${returned_data[2]}\", \"City\": \"${returned_data[3]}\", \"Country\": \"${returned_data[4]}\"}"
        campaign="${returned_data[5]}"
        
        result=$(activity)

    group+="INSERT INTO Contacts (Name, Email) VALUES ('$gen_name', '$gen_email');"
    group+="SET @last_id = LAST_INSERT_ID();"
    group+="INSERT INTO ContactDetails (ContactsID, DataJSON) VALUES (@last_id, '$gen_json');"
    group+="INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate) VALUES $result;"
    
    inc=$((inc+1))  

    if [[ $inc -gt $batch || $i -eq $count ]]; then
        mysql --defaults-file=~/.my.cnf -D campaign <<EOF
START TRANSACTION;
$group
COMMIT;
EOF
batch_no=$((batch_no+1))  
        final=$(date +%s%3N)
        execution_time=$((final - start_time))

        echo "batch $batch_no successful and execution time is: $execution_time milliseconds"
        inc=0
        group=""
    fi
done



#SQL QUERY
# SELECT co.ID, ca.CampaignID, co.Email, ca.ActivityType, JSON_EXTRACT(cd.DataJSON, '$.Country') 
# FROM Contacts co JOIN ContactActivity ca ON co.ID = ca.ContactsID JOIN ContactDetails cd ON cd.ContactsID = co.ID 
# WHERE ca.ActivityType = 3 AND JSON_EXTRACT(cd.DataJSON, '$.Country') in ('USA','UK') 
# GROUP BY co.ID, cd.DataJSON, ca.CampaignID HAVING COUNT(*)>30; 
