shell_cert_path_windows="/mnt/c/Users/Yonah.Citron/OneDrive - Shell/shell-certs/shell-root-cert.crt"

# Copy it to wsl
shell_cert_path_wsl="/usr/local/share/ca-certificates/shell-cert.crt"
export SSL_CERT_FILE=$shell_cert_path_wsl
export CURL_CA_BUNDLE=$shell_cert_path_wsl
export REQUESTS_CA_BUNDLE=$shell_cert_path_wsl

if [ ! -e $shell_cert_path_wsl ]; then
    # Add the .crt file and register it with ssl.
    sudo cp "$shell_cert_path_windows" "$shell_cert_path_wsl"
    sudo update-ca-certificates
fi
