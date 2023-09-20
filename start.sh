#!/bin/bash 

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
#Hlavní menu
function menu() {
    cmd=(dialog --clear --backtitle "SIDEREUM | SCRIPT MENU v1.0 By DecapitaresCz" --title "HLAVNI MENU" --menu "Vyber si jednu z možností" 20 40 11)
    options=(1 "Midnight Commander"
             2 "System Info"
             3 "install-update"
             4 "Blbosti"
             5 "Callendar"
             6 "Test script"
             7 "reload")
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices
    do
        case $choice in
            1)
                clear ; mc ; ./ui.sh
                ;;
            2)
                "$CURRENT_DIR/scripts/./system-info.sh"
                ;;
            3)
                install-update
                ;;
            4)
                blbosti
                ;;
            5)
                "$CURRENT_DIR/scripts/./callendar.sh"
                ;;
            6)
                "$CURRENT_DIR/scripts/./test.sh"
                ;;
            7)
                ./ui.sh
                ;;
        esac
    done
}

#note menu
function note() {
    local filename=$(dialog --title "Vyber .txt soubor" --fselect "$HOME/Documents/program/scripts/note/" 14 70 2>&1 >/dev/tty)

    # Pokud uživatel nevybere žádný soubor nebo zavře okno, skript se ukončí
    if [[ -z "$filename" ]]; then
        echo "Nebyl vybrán žádný soubor."
        menu
    fi

    # Spustíme editaci vybraného souboru
    edit_file "$filename"
}

# Funkce pro editaci .txt souboru
function edit_file() {
    local file="$1"
    echo "Editace souboru: $file"

    # Zde můžete použít libovolný textový editor, například nano nebo vim
    # V tomto příkladu použijeme nano
    nano "$file"
    menu
}

#blbosti menu
function blbosti() {
    cmd=(dialog --clear --backtitle "SIDEREUM | BLBOSTI MENU" --title "BLBOSTI" --menu "Vyber si jednu z možností" 20 40 11)

    options=(1 "Mrk"
             2 "Nyan"
             3 "BACK")
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices
    do
        case $choice in
            1)
                "$CURRENT_DIR/scripts/blbosti/./mrk.sh"
                ;;
            2)
                "$CURRENT_DIR/scripts/blbosti/./nyan.sh"
                ;;
            3)
                menu
                ;;
        esac
    done
}

#install-&-update menu
function install-update() {
    cmd=(dialog --clear --backtitle "SIDEREUM | Install-Update MENU" --title "Install-Update" --menu "Vyber si jednu z možností" 20 40 11)

    options=(1 "Update apt"
             2 "Update & Upgrade"
             3 "Install Midnight Commander"
             4 "BACK"
             5 "Docker & portainer install script")
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices
    do
        case $choice in
            1)
                clear ; sudo apt update
                ;;
            2)
                clear ; sudo apt update && sudo apt upgrade
                ;;
            3)
                clear ; sudo apt install mc
                ;;
            4)
                menu
                ;;
            5)
                clear ; "$CURRENT_DIR/scripts/docker_install.sh"
                ;;
        esac
    done
}

menu

clear