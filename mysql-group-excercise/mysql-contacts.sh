

start_time=$(date +%s%3N)
source ./activity.sh
count=100000

batch_size=200

nested_array=()

j=0

sql_query=''

activity_string=''

flag=1

 

for ((k=1; k<=$count; k++)); do

    echo $k
    
return=$(end_result)



    name="Name$k"

    email="name$k@example.com"

    dob=$(date -d "$((RANDOM % 36525)) days ago" +%Y-%m-%d)

    country="Country$k"

    city="City$k"

    json="{\"dob\":\"$dob\",\"country\":\"$country\",\"city\":\"$city\"}"
    

sql_query+="CALL InsertContactAndActivity ('$name','$email',$flag,'$json','$return');"


echo $email



j=$((j+1))

if [[ $j -gt $batch_size || $k -eq $count ]]; then
    sql_query=${sql_query%,}

    echo "hi"
    mysql --defaults-file=~/.my.cnf -D Task_mysql<<EOF

    START TRANSACTION;

    $sql_query

    COMMIT;

EOF
        j=0

        sql_query=''

    fi

done

 

end_time=$(date +%s%3N)

execution_time=$((end_time - start_time))

echo "Script execution time: $execution_time milliseconds"
