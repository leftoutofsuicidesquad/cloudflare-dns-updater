#!/bin/bash

# Cloudflare API credentials
ZONE_ID="your_zone_id"          # The zone ID (website) in Cloudflare
API_TOKEN="your_api_token"      # Your Cloudflare API token
DOMAIN="yourdomain.com"         # Your domain (e.g., example.com)

# Optional: Set whether to proxy the DNS records (True or False)
PROXY_STATUS=${1:-false}        # Default is 'false', can be set to 'true' when calling the script

# Get the current public IP address
CURRENT_IP=$(curl -s https://ipv4.icanhazip.com)

# Get all DNS records for the zone (including subdomains)
DNS_RECORDS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json")

# For each A-record in the zone, check the IP and update if necessary
for row in $(echo "$DNS_RECORDS" | jq -r '.result[] | select(.type=="A") | @base64'); do
    # Extract subdomain and record ID
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    DNS_NAME=$(_jq '.name')               # Name of the subdomain (e.g., sub1.yourdomain.com)
    DNS_RECORD_ID=$(_jq '.id')            # DNS record ID
    DNS_IP=$(_jq '.content')              # Current IP address of the DNS record

    # Check if the IP address has changed
    if [ "$CURRENT_IP" != "$DNS_IP" ]; then
        # Update the DNS record with the proxy setting
        echo "Updating subdomain: $DNS_NAME to IP: $CURRENT_IP with proxy set to $PROXY_STATUS"
        curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'"$DNS_NAME"'","content":"'"$CURRENT_IP"'","ttl":120,"proxied":'"$PROXY_STATUS"'}'
    else
        echo "Subdomain $DNS_NAME is already using the current IP: $CURRENT_IP"
    fi
done
