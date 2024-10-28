#!/run/current-system/sw/bin/bash

# Fetch the current time from a trusted website's HTTPS Date header
TIME_SOURCE="https://cloudflare.com"  # Replace with a trusted website

# Use curl to get the Date header
DATE_STRING=$(curl -s --head "$TIME_SOURCE" | grep -i "^Date:" | sed 's/Date: //i')

# If we successfully retrieved the date, update the system time
if [ -n "$DATE_STRING" ]; then
    # Convert the date string to a format that 'date' command understands
    DATE_PARSED=$(date -d "$DATE_STRING" +"%Y-%m-%d %H:%M:%S")
    
    # Update the system clock
    doas date -s "$DATE_PARSED"
    echo "System time updated to: $DATE_PARSED"
else
    echo "Failed to retrieve time from $TIME_SOURCE"
    exit 1
fi
