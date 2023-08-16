#!/bin/bash
time1=$(date +%s%3N)
# Validate name function
# Validate name function
validate_name() {
    local name=$1
    if [[ ! $name =~ ^[a-zA-Z\s-]{2,30}$ ]]; then
        return 1
    fi
    return 0
}

# Validate city function
validate_city(){
    local city=$1
    if [[ ! $city =~ ^[a-zA-Z\s]{2,20}$ ]]; then
        return 1
    fi
    return 0
}
# Validate country function
validate_country(){
    local country=$1
    if [[ ! $country =~ ^[a-zA-Z\s]{2,10}$ ]]; then
        return 1
    fi
    return 0
}
# Validate dob function
validate_dob(){
    local dob=$1
    if [[ ! $dob =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
        return 1
    fi
    return 0
}
validate_username(){
    local username=$1
    if [[ ! $username =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,20}$ ]]; then
        return 1
    fi
    return 0
}
validate_password(){
    local password=$1
    if [[ ! $password =~ ^[a-zA-Z0-9._\!\%\+\-\@\#\$]{6,30}$ ]]; then
        return 1
    fi
    return 0
}
# Validate age function
validate_age(){
    local age=$1
    if [[ ! $age =~ ^[0-9\s]{1,20}$ ]]; then
        return 1
    fi
    return 0
}
# Validate designation function
validate_designation(){
    local designation=$1
    if [[ ! $designation =~ ^[a-zA-Z\s]{2,20}$ ]]; then
        return 1
    fi
    return 0
}

csv_file="/home/user/Downloads/insert.csv"
output_file="/home/user/Desktop/banana/outputfile.sh"
string=""
while IFS=, read -r  name city country dob username password age designation #!read file
do
 
  # Validate values
    if [[ -z $name || -z $city || -z $country || -z $dob || -z $username || -z $password || -z $age || -z $designation ]]; then
        echo "Empty field. Skipping line."  >> "$out_file"
        continue
    fi

    if ! validate_name "$name"; then
        echo "Invalid name: $name. Skipping line."  >> "$out_file"
        continue
    fi

    if ! validate_city "$city"; then
        echo "Invalid city: $city. Skipping line."  >> "$out_file"
        continue
    fi
     if ! validate_country "$country"; then
        echo "Invalid country: $country. Skipping line."  >> "$out_file"
        continue
    fi
    
     if ! validate_dob "$dob"; then
        echo "Invalid date of birth: $dob. Skipping line."  >> "$out_file"
        continue
    fi
    
    if ! validate_username "$username"; then
        echo "Invalid username: $username. Skipping line."  >> "$out_file"
        continue
    fi
    
    if ! validate_password "$password"; then
        echo "Invalid password: $password. Skipping line."   >> "$out_file"
        continue
    fi
     
    if ! validate_age "$age"; then
        echo "Invalid age: $age. Skipping line."  >> "$out_file"
        continue
    fi
    
     if ! validate_designationss "$designation"; then
        echo "Invalid designation: $designation. Skipping line."  >> "$out_file"
        continue
    fi


string+="('$name', '$city', '$country', '$dob', '$username', '$password', '$age', '$designation'),"   #!stored in variable
done < "$csv_file"

string=$(echo "$string" | sed 's/,$//') #! Remove the trailing comma from string

insert="INSERT INTO file (name, city, country, dob, username, password, age, designation) VALUES $string"
echo "$insert" |   mysql --defaults-file=~/.my.cnf "vinam_data"


echo " data Inserted" 
time2=$(date +%s%3N)
time_taken=$(echo "$time2-$time1" |bc)   #!diffrence in time
echo $time_taken "ms"




