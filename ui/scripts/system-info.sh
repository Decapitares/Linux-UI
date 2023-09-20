#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Funkce pro získání informací o RAM
get_ram_stats() {
    free -h | grep "Mem:" | awk '{print "RAM: " $3 "/" $2}'
}

# Funkce pro získání informací o CPU
get_cpu_stats() {
    top -bn1 | grep '%Cpu' | awk '{print "CPU: " $2 "%"}'
}

# Funkce pro získání informací o využití disku (Disk Space) pro kořenový souborový systém
get_root_disk_stats() {
    df -h / | grep '/' | awk '{print "Disk Space (root): " $3 "/" $2 " = " $5 " | " "free " $4 }'
}

# Funkce pro získání informací o využití disku (Disk Space) pro oddíl /home
get_home_disk_stats() {
    df -h /home | grep '/home' | awk '{print "Disk Space (/home): " $3 "/" $2 " = " $5 " | " "free " $4 }'
}

# Funkce pro získání informací o hlavní IP adrese, bráně (gateway) a maskovacím síťovém čísle (subnet mask)
get_network_info() {
    interface=$(ip -o -4 route show to default | awk '{print $5}')
    main_ip=$(ip -o -4 addr list $interface | awk '{print $4}' | cut -d/ -f1)
    gateway=$(ip -o -4 route show to default | awk '{print $3}')
    subnet_mask=$(ip -o -4 addr list $interface | awk '{print $4}' | cut -d/ -f2)
    echo "Hlavní IP adresa: $main_ip \n"
    echo "Brána (Gateway): $gateway \n"
    echo "Maskovací síťové číslo (Subnet Mask): $subnet_mask \n"
}

# Funkce pro zobrazení dialogového okna s informacemi a volbami
show_system_info() {
    while true; do
        # Získáme informace o RAM, CPU, využití disku, a síťové informace
        ram_stats=$(get_ram_stats)
        cpu_stats=$(get_cpu_stats)
        root_disk_stats=$(get_root_disk_stats)
        home_disk_stats=$(get_home_disk_stats)
        network_info=$(get_network_info)

        # Zobrazíme dialogové okno s aktuálními daty
        choice=$(dialog --title "Monitorování systému" --extra-button --extra-label "Ukončení" \
            --ok-label "Aktualizovat" --msgbox "$ram_stats\n\n$cpu_stats\n\n$root_disk_stats\n\n$home_disk_stats\n\n$network_info" 18 60 2>&1 >/dev/tty)

        # Zpracování volby
        exit_status=$?
        case $exit_status in
            0)  # Uživatel stiskl tlačítko "Aktualizovat"
                ;;
            3)  # Uživatel stiskl tlačítko "Ukončení" nebo zavřel dialogové okno
                break ; /home/Deca/Documents/program/./start.sh
                ;;
        esac
    done
}

# Spustíme zobrazení dialogového okna s informacemi a volbami
show_system_info

./ui.sh
