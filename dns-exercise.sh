#!/bin/bash

#!/bin/bash

domain="$1"

log() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message"
}

# Initialize arrays
declare -a unique_cnames=()
declare -a unique_mx=()

extract_unique_records() {
    local record_type="$1"
    local -n records="$2" 
    local -n unique_array_name="$3"
#  log "function started"
    for record in "${records[@]}"; do
        if [ -n "$record" ]; then
            num_fields=$(echo "$record" | awk -F. '{print NF}')

            if [ "$num_fields" -ge 2 ]; then
                cut_string=$(echo "$record" | awk -F. '{print $(NF-2)"."$(NF-1)}')
            fi

            # Check if cut_string is not in the respective unique array
            if [[ ! " ${unique_array_name[@]} " =~ " $cut_string" ]]; then
                echo "$cut_string"
                eval "unique_array_name+=("$cut_string")"
            fi
     
        fi
    done
  unset -n  unique_array_name
#   log "function ended"
}
output=($(curl -s "https://crt.sh/?q=%25.$domain&output=json" | grep -oP '\"name_value\":\"\K.*?(?=\")' | sort -u))

echo "Email tool for $domain:"
unique_mx=()

 mx+=($(dig +short MX "$domain" 2>/dev/null))


 extract_unique_records "MX" mx unique_mx
echo "Analytical tool for $domain:"

for subdomain in "${output[@]}"; do
    CNAME_record+=($(dig +short CNAME "$subdomain" 2>/dev/null))
done
    extract_unique_records "CNAME" CNAME_record unique_cnames
    unset unique_cnames