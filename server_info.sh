#!/bin/bash

echo "=========================================="
echo "PBXWARE SERVER DIAGNOSTICS"
echo "Generated at: $(date)"
echo "=========================================="

echo -e "\n--- 1. TELEPHONY STATUS ---"
# Check for PJSIP endpoints (Online/Offline)
if command -v asterisk > /dev/null; then
    echo "PJSIP Endpoints:"
    asterisk -rx "pjsip show endpoints" | grep -E "Endpoint:|DeviceState:" || echo "No PJSIP endpoints found."
    
    ONLINE_EXT=$(asterisk -rx "pjsip show endpoints" | grep -c "Not in use")
    OFFLINE_EXT=$(asterisk -rx "pjsip show endpoints" | grep -c "Unavailable")
    echo "Summary: $ONLINE_EXT Online, $OFFLINE_EXT Offline"

    echo -e "\nTrunks Status:"
    # Trunks are usually identified by having 'Trunk' in the name in PBXware
    asterisk -rx "pjsip show registrations" || echo "No PJSIP registrations found."
else
    echo "Asterisk command not found."
fi

echo -e "\n--- 2. DISK USAGE (SPECIFIC FOLDERS) ---"
FOLDERS=(
    "/opt/"
    "/opt/httpd/"
    "/opt/pbxware/"
    "/opt/backup/"
    "/opt/pbxware/pw/var/spool/asterisk/monitor/"
    "/opt/pbxware/pw/var/spool/asterisk/voicemail/"
    "/opt/pbxware/pw/var/lib/mysql/pbxware/"
    "/opt/pbxware/pw/tmp/"
)

for folder in "${FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        du -sh "$folder"
    else
        echo "Directory not found: $folder"
    fi
done

echo -e "\n--- 3. OPT DIRECTORY LISTING ---"
ls -F /opt/

echo -e "\n--- 4. CRONTAB LISTING ---"
crontab -l || echo "No crontab for current user."

echo -e "\n--- 5. MEMORY USAGE (GB) ---"
free -g

echo -e "\n--- 6. DISK CAPACITY ---"
df -h

echo -e "\n--- 7. NETWORK INTERFACES ---"
ifconfig || ip addr

echo -e "\n--- 8. NAT / PUBLIC IP INFO ---"
LOCAL_IPS=$(hostname -I)
PUBLIC_IP=$(curl -s ip.bernis.dev)
echo "Local IPs: $LOCAL_IPS"
echo "Public IP: $PUBLIC_IP"

# Simple NAT check: if public IP is not in local IPs
if [[ "$LOCAL_IPS" == *"$PUBLIC_IP"* ]]; then
    echo "NAT Status: No NAT (Direct Public IP)"
else
    echo "NAT Status: Behind NAT / Firewall"
fi

echo -e "\n=========================================="
echo "DIAGNOSTICS COMPLETE"
echo "=========================================="
