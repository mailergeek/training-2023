#!/bin/bash

end_result() {

calculate_activity_date() {
    activity_date1=$(date -d "$activity_date + 1 days" +%Y-%m-%d)
    activity_date2=$(date -d "$activity_date1 + 2 days" +%Y-%m-%d)
    activity_date3=$(date -d "$activity_date2 + 3 days" +%Y-%m-%d)
}

calculate_activity() {
    if (($percent <= 80)); then
            if (($percent <= 30)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
            elif (($percent <= 60)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
            else
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 7, \"$activity_date\"),"
            fi
    elif (($percent <= 90)); then
            if (($percent <= 82)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
            elif (($percent <= 84)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"

            elif (($percent <= 86)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"

            elif (($percent <= 88)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"

            elif (($percent <= 89)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 7, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
            else
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                activity_date=$activity_date1
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                activity_string+="(@p_id, $i, 7, \"$activity_date\"),"
                activity_date=$activity_date2
                activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                activity_date=$activity_date3
                activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
            fi
            
    else
            percent=$((1+ RANDOM % 1000)) 
            if (($percent <= 940)); then
                activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
            else
                flag=0
                if (($percent <= 960)); then
                    activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                    activity_date=$activity_date1
                    activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                    activity_date=$activity_date2
                    activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                    activity_date=$activity_date3
                    activity_string+="(@p_id, $i, 5, \"$activity_date\"),"
                elif (($percent <= 970)); then
                    activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                    activity_date=$activity_date1
                    activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                    activity_date=$activity_date2
                    activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                    activity_date=$activity_date3
                    activity_string+="(@p_id, $i, 6, \"$activity_date\"),"
                elif (($percent <= 980)); then
                    activity_string+="(@p_id, $i, 1, \"$activity_date\"),"
                    activity_date=$activity_date1
                    activity_string+="(@p_id, $i, 3, \"$activity_date\"),"
                    activity_date=$activity_date2
                    activity_string+="(@p_id, $i, 4, \"$activity_date\"),"
                    activity_date=$activity_date3
                    activity_string+="(@p_id, $i, 5, \"$activity_date\"),"
                    activity_string+="(@p_id, $i, 6, \"$activity_date\"),"
                else
                    activity_string+="(@p_id, $i, 2, \"$activity_date\"),"
                fi
            fi
    fi

}

generate_data() {
    i=$((i+1))
    flag=1

    if (( $i % 10 == 0 )); then
            activity_datex=$(date -d "$activity_datex + 1 months" +%Y-%m-%d)
            activity_date=$activity_datex
            calculate_activity_date
    else
        activity_date=$activity_datex
    fi
    percent=$((1+ RANDOM % 100))   
    calculate_activity
    if [[ $i -eq 100 || $flag -eq 0 ]]; then
        echo "$activity_string"
        i=0
    else    
        generate_data 
    fi
   
}
activity_datex="2023-01-01"
activity_date1="2023-01-01"
activity_date2="2023-01-01"
activity_date3="2023-01-01"
i=0

activity_string=""
result="$(generate_data)"
result="${result%,}"

echo $result
}
# export -f end_result
# parallel -j 4 end_result :::
