
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


generate_random_date(){
    randomyear=2023
    randommonth=08
    randomday=$(( (RANDOM % 28) + 1))
    echo "$randomyear"."$randommonth"."$randomday"

}

num=1000
 
# insert into contacts table
for ((i=1;i<=num;i++));do
	id=$i
	name=$(generate_name)
        email=$(generate_email)
	mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
        "INSERT INTO c1 (id, name, email) VALUES ($id, '$name', '$name$((RANDOM))@$email.com');"

#insert into contact_details_table   
        contactid=$((i))
        dob="$(generate_random_dob)"
        country=$(generate_country)
        mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
        "INSERT INTO c2 (contactid,dob,city,country) VALUES ($contactid, '$dob', '$country$((RANDOM))','$country');"
        
        
#insert into contact_activity table
        contactid=$((i))
        campaign=$(generate_campaign)  
        actvt=$(generate_activity_type)
        date=$(generate_random_date)

        if [[ $actvt -eq 2 ]]; then
            temp=2
        else
             temp=1
        fi
        
        for ((k=temp;k<=actvt;k++));do
            
                activitytype=$((k))
                if [[ $k -eq 1 || $k -eq 2 ]]; then
                      activitydate="2023-08-01"
                else
                      activitydate=$date
                fi
                if [[ $k -eq 2 && $actvt -gt 2 ]]; then
                      continue
                elif [[ $k -eq 5 && $actvt -eq 7 ]]; then
                      continue
                elif [[ $k -eq 6 && $actvt -eq 7 ]]; then
                      continue
                else
                     mysql --defaults-file=~/.my.cnf -D "$db_name" -e \
                     "INSERT INTO c3 (contactid, campaignid,activitytype,activitydate) VALUES ($contactid, $campaign,$activitytype,'$activitydate');"
                
                
                fi 
 
               

        done
       
done
    
    
    
    
