#!/bin/bash
echo "IOANAAAAA"
verifica_ip() {
    local dominio="$1"
    local ip="$2"
    local dns="$3"

    ips=$(nslookup "$dominio" "$dns" 2>/dev/null | awk '
        /^Name:/ {gasit=1; next}
        gasit && /^Address:/ {print $2}
    ')

    if ! grep -Fxq "$ip" <<< "$ips"; then
        echo "Bogus IP for $dominio in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r ip nume
do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    if [[ "$ip" == *:* || "$ip" == 127.* ]]; then
        continue
    fi

    for domeniu in $nume
    do
        if [[ "$domeniu" == \#* ]]; then
            break
        fi

        verifica_ip "$domeniu" "$ip" "8.8.8.8"
    done
done
