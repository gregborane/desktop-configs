
#!/usr/bin/env bash
set -euo pipefail

# Eduroam EAP-TLS configuration
CONNECTION=""
INTERFACE="wlp2s0"
SSID=""

IDENTITY=""
ANONYMOUS_IDENTITY=""
DOMAIN=""

CERT_DIR="/etc/wpa_supplicant/certs"
CA_CERT="$CERT_DIR/ca.pem"
CLIENT_CERT="$CERT_DIR/client.crt"
PRIVATE_KEY="$CERT_DIR/client.key"

# 1. Configure certificate ownership and permissions
sudo chown root:wpa_supplicant "$PRIVATE_KEY"
sudo chmod 640 "$PRIVATE_KEY"

sudo chown root:root "$CA_CERT" "$CLIENT_CERT"
sudo chmod 644 "$CA_CERT" "$CLIENT_CERT"

sudo chmod 755 "$CERT_DIR"

# 2. Create the connection if it does not exist
if ! nmcli -g connection.id connection show "$CONNECTION" &>/dev/null; then
    sudo nmcli connection add \
        type wifi \
        con-name "$CONNECTION" \
        ifname "$INTERFACE" \
        ssid "$SSID"
fi

# 3. Configure EAP-TLS authentication
sudo nmcli connection modify "$CONNECTION" \
    connection.interface-name "$INTERFACE" \
    wifi.ssid "$SSID" \
    wifi-sec.key-mgmt "wpa-eap" \
    802-1x.eap "tls" \
    802-1x.identity "$IDENTITY" \
    802-1x.anonymous-identity "$ANONYMOUS_IDENTITY" \
    802-1x.domain-suffix-match "$DOMAIN" \
    802-1x.ca-cert "$CA_CERT" \
    802-1x.client-cert "$CLIENT_CERT" \
    802-1x.private-key "$PRIVATE_KEY" \
    802-1x.private-key-password-flags 0 \
    connection.autoconnect yes

# 4. Configure the private key password
read -rs -p "Private key password: " KEY_PASSWORD
echo

sudo nmcli connection modify "$CONNECTION" \
    802-1x.private-key-password "$KEY_PASSWORD"

unset KEY_PASSWORD

# 5. Connect
sudo nmcli connection up "$CONNECTION"

# 6. Show connection status
nmcli -f GENERAL.STATE,GENERAL.CONNECTION device show "$INTERFACE"

echo "Eduroam setup completed."

