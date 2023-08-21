db_host="localhost"
db_user="root"
db_pass="newpassword"
db_name="mydatabase"


namelist=('shamnas' 'arun' 'abhinandh' 'vishnu' 'dona' 'safana' 'jeejo' 'mujeeb' 'safvan' 'hisham' 'raheem' 'anandhan' 'raja' 'kumar' 'rithu' 'bathool' 'hashir' 'veena' 'varun' 'sona' 'madhu' 'kannan' 'kishore' 'muneer')
domain=('gmail'  'yahoo' 'vinam' 'example')
generate_name(){
	randomname=${namelist[$((RANDOM % ${#namelist[@]}))]}
	echo "$randomname"
}
generate_email(){
	randomemail=${domain[$((RANDOM % ${#domain[@]}))]}
	echo "$randomemail"
}
country=('india' 'usa' 'africa' 'argentina' 'brazil' 'skorea' 'peru' 'chili' 'france' 'spain' 'portugal' 'colombia' 'qatar' 'uae' 'germany')

generate_country(){
     randomcountry=${country[$((RANDOM%${#country[@]}))]}
     echo "$randomcountry"

}
generate_random_dob(){
    randomyear=$(( (RANDOM % (2023 - 1900 + 1)) + 1900 ))
    randommonth=$(( (RANDOM % 12) + 1 ))
    randomday=$(( (RANDOM % 28) + 1))
    echo "$randomyear"."$randommonth"."$randomday"

}
activity=(1 2 3 4 5 6 7)
generate_activity_type(){
    randomactivity=${activity[$((RANDOM%${#activity[@]}))]}
    echo "$randomactivity"

}
campaign=(1 2 3 4 5 6 7 8 9 10)
generate_campaign(){
    randomactivity=${campaign[$((RANDOM%${#campaign[@]}))]}
    echo "$randomactivity"

}

num=1000000
for ((i=75404;i<=num;i++));do
	id=$i
	name=$(generate_name)
        email=$(generate_email)
	mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
        "INSERT INTO contacts (id, name, email) VALUES ($id, '$name', '$name$((RANDOM))@$email.com');"
        
        
        contactid=$((i))
        dob="$(generate_random_dob)"
        country=$(generate_country)
        mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
        "INSERT INTO contact_details (contactid,dob,city,country) VALUES ($contactid, '$dob', '$country$((RANDOM))','$country');"
        
        
        
        
 
        contactid=$((i))
        campaign=$(generate_campaign)  
        actvt=$(generate_activity_type)
        if [[ $actvt -eq 1 ]]; then
                activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
        fi  
        if [[ $actvt -eq 2 ]]; then
                activitytype=2
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
        fi 
        if [[ $actvt -eq 3 ]]; then
                activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                activitytype=3
                activitydate="2023-08-02"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
        fi
        if [[ $actvt -eq 4 ]]; then
                 activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                activitytype=3
                activitydate="2023-08-03"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                activitytype=4
                activitydate="2023-08-03"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
        fi
        if [[ $actvt -eq 5 ]]; then
                activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                activitytype=3
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                activitytype=4
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
                activitytype=5
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
                activitytype=6
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
            
        fi
        if [[ $actvt -eq 6 ]]; then
                activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                activitytype=3
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                activitytype=4
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"    
                activitytype=6
                activitydate="2023-08-04"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
            
        fi
        if [[ $actvt -eq 7 ]]; then
                activitytype=1
                activitydate="2023-08-01"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                activitytype=3
                activitydate="2023-08-05"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                activitytype=4
                activitydate="2023-08-05"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"    
                activitytype=7
                activitydate="2023-08-05"
                mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                "INSERT INTO contact_activity (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"     
            
        fi
        
done
    
    
    
    
