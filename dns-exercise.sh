#!/bin/bash

domain="$1"

log() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message"
}

# Initialize arrays
unique_cnames=()
unique_mx=()

extract_unique_records() {
    local record_type="$1"
    local records=("${!2}")
    local unique_array_name="$3"

    for record in "${records[@]}"; do
        if [ -n "$record" ]; then
            num_fields=$(echo "$record" | awk -F. '{print NF}')

            if [ "$num_fields" -ge 2 ]; then
                cut_string=$(echo "$record" | awk -F. '{print $(NF-2)"."$(NF-1)}')
            fi

            # Check if cut_string is not in the respective unique array
            if  [[ ! " ${unique_array_name[@]} " =~ " $cut_string " ]]; then
                echo "$cut_string"
                unique_array_name+=("$cut_string")
            fi
        fi
    done
}

output=($(curl -s "https://crt.sh/?q=%25.$domain&output=json" | grep -oP '\"name_value\":\"\K.*?(?=\")' | sort -u))

echo "Analytical tool for $domain:"

for subdomain in "${output[@]}"; do
    CNAME_record="$(dig +short CNAME "$subdomain")"
    extract_unique_records "CNAME" CNAME_record unique_cnames
done

echo "Email tool for $domain:"

mx=($(dig +short MX "$domain"))

extract_unique_records "MX" mx unique_mx
