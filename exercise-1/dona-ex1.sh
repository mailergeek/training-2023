#!/bin/bash
DB_HOST="localhost"
DB_USER="root"
DB_NAME="campaign"

contacts=1000000

declare -A activity_dates

activity_dates["1"]="2023-08-21"
activity_dates["2"]="2023-08-22"
activity_dates["3"]="2023-08-23"
activity_dates["4"]="2023-08-24"
activity_dates["5"]="2023-08-25"
activity_dates["6"]="2023-08-26"
activity_dates["7"]="2023-08-27"

function get_activity_date() {
    activity_type="$1"
    echo "${activity_dates[$activity_type]}"
}


function activitytype_fn() {
random_number=$((1 + RANDOM % 8))

case $random_number in
    1)
        values=(1 3 4 5)
        ;;
    2)
        values=(1 3 4 6)
        ;;
    3)
        values=(1 3 4 7)
        ;;
    4)
        values=(2)
        ;;
    5)
        values=(1)
        ;;
    6)
        values=(1 3 6 7)
        ;;
    7)
        values=(1 3 6)
        ;;
    8)
        values=(1 3 7)
        ;;
    *)
        values=("out of range")
        ;;
esac
echo "${values[@]}"

}


function contact_data(){
    names=("Dona" "Joseph" "Deleesha" "Edison" "James" "Emma" "Michael" "Olivia" "William" "Ava" "David" "Sophia" "Joseph" "Isabella" "Charles" "Mia" "John" "Amelia" "Robert" "Grace" "Daniel" "Harper" "Matthew" "Sofia" "Andrew" "Scarlett" "Benjamin" "Abigail" "Samuel" "Emily" "Jackson" "Avery" "Christopher" "Chloe" "Joshua" "Ella" "David" "Aria" "John" "Lily" "Ethan" "Layla" "Ryan" "Zoey" "Alexander" "Grace" "James" "Aubrey" "Elijah" "Hannah" "Benjamin" "Ellie" "Samuel" "John" "Mary" "Michael" "Linda" "William" "Susan" "David" "Sarah" "Robert" "Karen" "James" "Patricia" "Richard" "Jennifer" "Charles" "Laura" "Joseph" "Nancy" "Thomas" "Maria")
    domains=("example" "testmail" "domain" "email" "mysite" "webmail" "company" "service" "provider" "online" "net" "org" "co" "shop" "store" "blog" "info" "business" "tech" "xyz")
    countries=("UAE" "UK" "USA" "Uruguay" "Uzbekistan" "Vanuatu" "Vatican City" "Venezuela" "Vietnam" "Yemen" "Zambia" "Zimbabwe")
    campaign=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
    
    _name=${names[$((RANDOM % ${#names[@]}))]}
    _domain=${domains[$((RANDOM % ${#domains[@]}))]}
    _email="user${i}@${_domain}.com"
    _dob=$(date -d "$((RANDOM % 36525)) days ago" +%Y-%m-%d)
    _country=${countries[$((RANDOM % ${#countries[@]}))]}
    _city="${_country}${i}"
    _campaignid=${campaign[$((RANDOM % ${#campaign[@]}))]}

    json="{\"DOB\": \"$_dob\", \"City\": \"$_city\", \"Country\": \"$_country\"}"

    gen_name="$_name"
    gen_email="$_email"
    gen_json="$json"

    #storing the last inserted id into result variable
    result=$(mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO Contacts (Name, Email)
    VALUES ('$gen_name', '$gen_email'); SELECT LAST_INSERT_ID();")


    id_value=${result##*)}
    id=$((id_value))
    #sending data into contact details table
    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactDetails(ContactsID,DataJSON)
    VALUES ('$id','$gen_json');"


    echo "$id"  # Return the 'result' variable
    echo "$_campaignid"

}

for ((i = 0; i < contacts; i++)); do
    id_and_campaign=($(contact_data))  # Call the function and capture the output in an array
    id="${id_and_campaign[0]}"  # Extract 'id' from the array
    campaign="${id_and_campaign[1]}" # Extract campaign id
    activity_array=($(activitytype_fn))
    
    activity_values=()
    for ((j = 0; j < "${#activity_array[@]}"; j++)); do
        activity_type="${activity_array[j]}"
        activity_date=$(get_activity_date "$activity_type")
        activity_values+=("('$campaign', '$id', '$activity_type', '$activity_date')")
    done

   
    _activity_values=$(IFS=,; echo "${activity_values[*]}")
    
    insert_query="INSERT INTO ContactActivity (CampaignID, ContactsID, ActivityType, ActivityDate) VALUES $_activity_values;"
    
    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "$insert_query"
done

echo "successful"
