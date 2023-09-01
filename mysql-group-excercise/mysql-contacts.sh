start_time=$(date +%s%3N)
source ./activity.sh
count=100000
batch_size=100
n=0
sql_query=''
activity_string=''
flag=1

generate_mysql_command() {
    for query in "${queries[@]}"; do
        mysql --defaults-file=~/.my.cnf -D campaign <<EOF
        START TRANSACTION;
        $query
        COMMIT;
EOF
    done
}

export -f generate_mysql_command
n=0
m=0
queries=()
batch_queries=()
batch_number=0

for ((k=1; k<=$count; k++)); do
echo $k
    return="$(end_result)"
    value=$(echo "$return" | grep -oE '@p_id, 100, [0-9]+' | grep -oE '100' | tr -d '\n')
    if [ -n "$value" ]; then
        flag=1
    else
        flag=0
    fi
    name="Name$k"
    email="name$k@example.com"
    dob=$(date -d "$((RANDOM % 36525)) days ago" +%Y-%m-%d)
    country="Country$k"
    city="City$k"
    json="{\"dob\":\"$dob\",\"country\":\"$country\",\"city\":\"$city\"}"
    sql_query+="CALL InsertContactAndActivity ('$name','$email',$flag,'$json','$return');"
    flag=1
    n=$((n+1))
    batch_number=$(( (k - 1) / batch_size + 1 ))
   

    if [[ $((k % batch_size)) -eq 0 || $k -eq $count ]]; then
        batch_queries+=("$sql_query")

        if [[ $((batch_number % 10)) -eq 0 ]]; then
            queries+=("${batch_queries[@]}")
            batch_queries=()
            m=$((m+1))
            if [[ $((m % 10)) -eq 0 ]]; then
        
            generate_mysql_command "${queries[@]}" &
            queries=()
            end_time=$(date +%s%3N)
            execution_time=$((end_time - start_time))
            echo "Script execution time: $execution_time milliseconds"

            fi
        fi
        echo "Batch $batch_number processed"
        sql_query=""
    fi
done
wait
end_time=$(date +%s%3N)
execution_time=$((end_time - start_time))
echo "Script execution time: $execution_time milliseconds"

