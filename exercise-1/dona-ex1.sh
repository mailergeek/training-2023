#!/bin/bash
DB_HOST="localhost"
DB_USER="root"
DB_NAME="campaign"

# list of real, example domains, countries and dates
names=("Dona" "Joseph" "Deleesha" "Edison" "James" "Emma" "Michael" "Olivia" "William" "Ava" "David" "Sophia" "Joseph" "Isabella" "Charles" "Mia" "John" "Amelia" "Robert" "Grace" "Daniel" "Harper" "Matthew" "Sofia" "Andrew" "Scarlett" "Benjamin" "Abigail" "Samuel" "Emily" "Jackson" "Avery" "Christopher" "Chloe" "Joshua" "Ella" "David" "Aria" "John" "Lily" "Ethan" "Layla" "Ryan" "Zoey" "Alexander" "Grace" "James" "Aubrey" "Elijah" "Hannah" "Benjamin" "Ellie" "Samuel" "John" "Mary" "Michael" "Linda" "William" "Susan" "David" "Sarah" "Robert" "Karen" "James" "Patricia" "Richard" "Jennifer" "Charles" "Laura" "Joseph" "Nancy" "Thomas" "Maria")
domains=("example" "testmail" "domain" "email" "mysite" "webmail" "company" "service" "provider" "online" "net" "org" "co" "shop" "store" "blog" "info" "business" "tech" "xyz")
countries=("Afghanistan" "Albania" "Algeria" "Andorra" "Angola" "Antigua" "Argentina" "Armenia" "Australia"
    "Austria" "Azerbaijan" "Bahamas" "Bahrain" "Bangladesh" "Barbados" "Belarus" "Belgium" "Belize" "Benin" "Bhutan" 
    "Bolivia" "Bosnia" "Botswana" "Brazil" "Brunei" "Bulgaria" "Burkina" "Burundi" "Cambodia" "Cameroon" "Canada" "Cape Verde" 
    "Chad" "Chile" "China" "Colombia" "Comoros" "Congo" "Costa Rica" "Croatia" "Cuba" "Cyprus" "Czech" "Denmark" "Djibouti"
    "Dominica" "East Timor" "Ecuador" "Russia" "Rwanda" "Saint Kitts" "Saint Lucia" "Saint Vincent" 
    "Samoa" "San Marino" "Sao Tome" "Saudi Arabia" "Senegal" "Serbia" "Seychelles" "Sierra Leone" "Singapore" "Slovakia"
    "Slovenia" "Solomon Islands" "Somalia" "South Africa" "South Sudan" "Spain" "Sri Lanka" "Sudan" "Suriname" "Sweden" 
    "Switzerland" "Syria" "Taiwan" "Tajikistan" "Tanzania" "Thailand" "Togo" "Tonga" "Trinidad" "Tunisia" "Turkey"
    "Turkmenistan" "Tuvalu" "Uganda" "Ukraine" "UAE" "UK" "USA" "Uruguay" "Uzbekistan" "Vanuatu" "Vatican City"
    "Venezuela" "Vietnam" "Yemen" "Zambia" "Zimbabwe")

sent_date="2023-11-12"
bounce_date="2023-11-12"
open_date="2023-11-13"
click_date="2023-11-14"
unsubscribe_date="2023-11-15"
abuse_date="2023-11-15"
conversion_date="2023-11-16"
campaign=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

contacts=1000000


# Selecting a random value for name, email, dob, country, city, campaignid
for ((i=0; i<=contacts; i++)); do
    _name=${names[$((RANDOM % ${#names[@]}))]}
    _domain=${domains[$((RANDOM % ${#domains[@]}))]}
    _email="user${i}@${_domain}.com"
    _dob=$(date -d "$((RANDOM%36525)) days ago" +%Y-%m-%d)
    _country=${countries[$((RANDOM % ${#countries[@]}))]}
    _city="${_country}${i}"
    _campaignid=${campaign[$((RANDOM % ${#campaign[@]}))]}
    
    json="{\"DOB\": \"$_dob\", \"City\": \"$_city\", \"Country\": \"$_country\"}"

#storing the last inserted id into result variable
    result=$(mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO Contacts (Name, Email)
    VALUES ('$_name', '$_email'); SELECT LAST_INSERT_ID();")

#retain only numeric value from id 
    id_value=${result##*)}
    id=$((id_value))
    echo $id

#sending data into contact details table
    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactDetails(ContactsID,DataJSON)
    VALUES ('$id','$json');"



    val=$((1 + RANDOM % 100)) # Selecting a random value from 1 to 100
    if ((val < 90)); then
        _activitytype=1  #higher probability of sending
    else
        _activitytype=2
    fi

    #check if sent
    if [ "$_activitytype" == "1" ]; then
        mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
        VALUES ('$id', '$_campaignid', '1', '$sent_date');"
        
        activity=(3 0)  # picking a random value if it's 3 then moves to open
        _activitytype=${activity[((RANDOM % ${#activity[@]}))]}

        #open
        if [ "$_activitytype" == "3" ]; then
            activity=(4 0) # picking a random value if it's 4 then moves to click
            _activitytype=${activity[((RANDOM % ${#activity[@]}))]}
            mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
            VALUES ('$id', '$_campaignid', '3', '$open_date');"

            #click 
            if [ "$_activitytype" == "4" ]; then
                activity=(5 6 7) # picking a random value if it's 5 then moves to unsub, 6 moves to abuse, 7 to conversion
                _activitytype=${activity[((RANDOM % ${#activity[@]}))]}
                mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                VALUES ('$id', '$_campaignid', '4', '$click_date');"
                
                #unsubscribe
                if [ "$_activitytype" == "5" ]; then
                    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                    VALUES ('$id', '$_campaignid', '5', '$unsubscribe_date');"
                fi

                #abuse
                if [ "$_activitytype" == "6" ]; then
                    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                    VALUES ('$id', '$_campaignid', '6', '$abuse_date');"
                fi
                #conversions
                if [ "$_activitytype" == "7" ]; then
                    mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                    VALUES ('$id', '$_campaignid', '7', '$conversion_date');"
                fi
            fi
        else
            activity=(5 6) # as not clicked, picking a random value if it's 5 then moves to unsub, 6 moves to abuse
            _activitytype=${activity[((RANDOM % ${#activity[@]}))]}
            
            #unsubscribe
            if [ "$_activitytype" == "5" ]; then
                mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                VALUES ('$id', '$_campaignid', '5', '$unsubscribe_date');"
            fi

            #abuse
            if [ "$_activitytype" == "6" ]; then
                mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
                VALUES ('$id', '$_campaignid', '6', '$abuse_date');"
            fi
        fi
    else
        #bounce    
        mysql --defaults-file=~/.my.cnf -h "$DB_HOST" -D "$DB_NAME" -e "INSERT INTO ContactActivity (ContactsID, CampaignID, ActivityType, ActivityDate)
        VALUES ('$id', '$_campaignid', '2', '$bounce_date');"
    fi
done

echo "All contacts inserted."
