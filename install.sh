#!/bin/bash
clear
mkdir -p $HOME/.CODEX
mkdir -p $HOME/.Codex-simu
mkdir -p $HOME/.toolx
# dx color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# dx Symbol
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# dx icon
OS="\uf6a6"
HOST="\uf6c3"
KER="\uf83c"
UPT="\uf49b"
PKGS="\uf8d6"
SH="\ue7a2"
TERMINAL="\uf489"
CHIP="\uf2db"
CPUI="\ue266"
HOMES="\uf015"

# Device Detection
if command -v getprop &>/dev/null; then
    MODEL=$(getprop ro.product.model)
    VENDOR=$(getprop ro.product.manufacturer)
else
    MODEL=$(uname -n)
    VENDOR=$(uname -s)
fi
devicename="${VENDOR} ${MODEL}"
THRESHOLD=100
random_number=$(( RANDOM % 2 ))

exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"              
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}Codex Banner \033[1;36m"
    echo
    cd "$HOME"
    rm -rf "$HOME/CODEX"
    kill -9 $PPID 2>/dev/null
    exit 0
}

if command -v tput &>/dev/null; then
    echo ""
else
    echo -e " ${C} ${g}Waiting for setup Screen!¡${n}"
    if [ -d "/data/data/com.termux/files/usr/" ]; then
        pkg install ncurses-utils -y >/dev/null 2>&1
    else
        sudo apt install ncurses-bin -y >/dev/null 2>&1 || true
    fi
    clear
fi

if command -v curl &>/dev/null; then
    echo ""
else
    if [ -d "/data/data/com.termux/files/usr/" ]; then
        pkg install curl -y >/dev/null 2>&1
    else
        sudo apt install curl -y >/dev/null 2>&1 || true
    fi
    clear
fi

trap exit_script SIGINT SIGTSTP

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    local used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    local disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}
data=$(check_disk_usage)

start() {
    clear
    tput civis
    LIME='\e[38;5;154m'
    C='\e[38;5;51m'
    BLINK='\e[5m'
    N='\e[0m'
    TOTAL_CHARS=0
    texts=(
        "「 CODEX STARTED 」"
        "「 HELLO DEAR USER I'M DX-SIMU 」"
        "「 CODEX WILL PROTECT YOU 」"
        "「 GOODBYE 」"
        "「 ENJOY OUR CODEX 」"
        "「............... 」"
    )
    for t in "${texts[@]}"; do
        TOTAL_CHARS=$((TOTAL_CHARS + ${#t}))
    done
    CURRENT_CHAR=0
    update_progress() {
        local percentage=$(( CURRENT_CHAR * 100 / TOTAL_CHARS ))
        if [ "$percentage" -gt 100 ]; then percentage=100; fi
        local term_width=$(tput cols)
        local bar_width=$((term_width - 20))
        if [ "$bar_width" -gt 50 ]; then bar_width=50; fi
        local padding=$(( (term_width - bar_width - 10) / 2 ))
        local filled=$(( percentage * bar_width / 100 ))
        local empty=$(( bar_width - filled ))
        local f_bar=$(printf "%${filled}s" "")
        local e_bar=$(printf "%${empty}s" "")
        tput sc
        tput cup 2 0
        tput el
        printf "%${padding}s${LIME}[\e[48;5;154m%s\e[0m\e[48;5;236m%s\e[0m${LIME}] ${C}%3d%%${N}" "" "$f_bar" "$e_bar" "$percentage"
        tput rc
    }
    type_effect() {
        local text="$1"
        local delay="$2"
        local term_width=$(tput cols)
        local text_length=${#text}
        local padding=$(( (term_width - text_length) / 2 ))
        printf "%${padding}s" ""
        for ((i=0; i<${#text}; i++)); do
            CURRENT_CHAR=$((CURRENT_CHAR + 1))
            update_progress
            printf "${LIME}${BLINK}${text:$i:1}${N}"
            if (( RANDOM % 1 == 0 )); then
                printf "\e[48;5;51m \e[0m"
                printf "\b \b"
            fi
            sleep "$delay"
        done
        echo
        echo
    }
    tput cup 5 0
    type_effect "${texts[0]}" 0.01
    sleep 0.1
    type_effect "${texts[1]}" 0.02
    sleep 0.1
    type_effect "${texts[2]}" 0.02
    sleep 0.1
    type_effect "${texts[3]}" 0.02
    sleep 0.1
    type_effect "${texts[4]}" 0.02
    sleep 0.1
    type_effect "${texts[5]}" 0.02
    sleep 1
    tput cnorm
    clear 
}
start


tr() {
    if ! command -v curl &>/dev/null; then
        if [ -d "/data/data/com.termux/files/usr/" ]; then
            pkg install curl -y &>/dev/null 2>&1
        else
            sudo apt install curl -y &>/dev/null 2>&1
        fi
    fi
}



spin() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    for package in "${packages[@]}"; do
        if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "ok installed"; then
            pkg install "$package" -y >/dev/null 2>&1 &
            show_spinner "$package"
        fi
    done

    if ! command -v lolcat >/dev/null 2>&1 || ! pip show lolcat >/dev/null 2>&1; then
        pip install lolcat >/dev/null 2>&1 &
        show_spinner "lolcat(pip)"
    fi
    
    rm -rf /data/data/com.termux/files/usr/bin/chat >/dev/null 2>&1

    if [ ! -f "$HOME/.toolx/chat" ]; then
        mkdir -p "$HOME/.toolx"
        mv "$HOME/CODEX/files/chat.sh" "$HOME/.toolx/chat" &
        show_spinner "chat"
        chmod +x "$HOME/.toolx/chat"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1 &
        show_spinner "oh-my-zsh"
    fi
    
    if [ "$SHELL" != "/data/data/com.termux/files/usr/bin/zsh" ]; then
        chsh -s zsh >/dev/null 2>&1 &
        show_spinner "zsh-shell"
    fi
    
    if [ ! -f "$HOME/.zshrc" ]; then
        rm -rf ~/.zshrc >/dev/null 2>&1
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &
        show_spinner "zshrc"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1 &
        show_spinner "zsh-autosuggestions"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1 &
        show_spinner "zsh-syntax"
    fi
}

linux_spin() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    if command -v apt >/dev/null 2>&1; then
        sudo -v # Caches sudo credentials
        sudo apt update >/dev/null 2>&1
        packages=("git" "python3" "python3-pip" "jq" "figlet" "zsh" "ruby" "exa")
        for package in "${packages[@]}"; do
            if ! command -v "$package" >/dev/null 2>&1; then
                sudo apt install "$package" -y >/dev/null 2>&1 &
                show_spinner "$package"
            fi
        done
    fi

    if ! command -v lolcat >/dev/null 2>&1; then
        sudo pip3 install lolcat --break-system-packages >/dev/null 2>&1 || pip3 install lolcat >/dev/null 2>&1 &
        show_spinner "lolcat(pip)"
    fi

    if [ ! -f "$HOME/.toolx/chat" ]; then
        mkdir -p "$HOME/.toolx"
        mv "$HOME/CODEX/files/chat.sh" "$HOME/.toolx/chat" &
        show_spinner "chat"
        chmod +x "$HOME/.toolx/chat"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1 &
        show_spinner "oh-my-zsh"
    fi
    
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        sudo chsh -s $(command -v zsh) $USER >/dev/null 2>&1
        # No background processing for chsh on linux to avoid hanging
    fi
    
    if [ ! -f "$HOME/.zshrc" ]; then
        rm -rf ~/.zshrc >/dev/null 2>&1
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &
        show_spinner "zshrc"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1 &
        show_spinner "zsh-autosuggestions"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1 &
        show_spinner "zsh-syntax"
    fi
}

setup_termux_paths() {
    ds="$HOME/.termux"
    dx="$ds/font.ttf"
    simu="$ds/colors.properties"
    if [ ! -f "$dx" ]; then
        cp $HOME/CODEX/files/font.ttf "$ds"
    fi
    if [ ! -f "$simu" ]; then
        cp $HOME/CODEX/files/colors.properties "$ds"
    fi
    mv $HOME/CODEX/files/unstall $HOME/.toolx/
    chmod +x $HOME/.toolx/unstall
    mv $HOME/CODEX/files/bname $HOME/.toolx/
    chmod +x $HOME/.toolx/bname
    mv $HOME/CODEX/files/simu $PREFIX/bin/
    chmod +x $PREFIX/bin/simu
    mv $HOME/CODEX/files/dev $HOME/.toolx/
    chmod +x $HOME/.toolx/dev
    mv $HOME/CODEX/files/update $HOME/.toolx/
    chmod +x $HOME/.toolx/update
    mv $HOME/CODEX/files/help $HOME/.toolx/
    chmod +x $HOME/.toolx/help
    mv $HOME/CODEX/files/code $PREFIX/bin/
    chmod +x $PREFIX/bin/code
    termux-reload-settings
}

setup_linux_paths() {
    mkdir -p ~/.local/share/fonts
    cp $HOME/CODEX/files/font.ttf ~/.local/share/fonts/
    fc-cache -fv  > /dev/null
    mv $HOME/CODEX/files/unstall $HOME/.toolx/
    chmod +x $HOME/.toolx/unstall
    mv $HOME/CODEX/files/bnamel $HOME/.toolx/
    chmod +x $HOME/.toolx/bname
    mv $HOME/CODEX/files/dev $HOME/.toolx/
    chmod +x $HOME/.toolx/dev
    sudo mv $HOME/CODEX/files/simu /usr/local/bin/
    sudo chmod +x /usr/local/bin/simu
    mv $HOME/CODEX/files/update $HOME/.toolx/
    chmod +x $HOME/.toolx/update
    mv $HOME/CODEX/files/help $HOME/.toolx/
    chmod +x $HOME/.toolx/help
    sudo mv $HOME/CODEX/files/code /usr/local/bin/
    chmod +x /usr/local/bin/code
}

dxnetcheck() {
    clear
    echo
    echo -e "		              ${g}Uhu"
    echo -e "${c}                        (\_/)"
    echo -e "                        (${y}^_^${c})"
    echo -e "                       ⊂(___)づ"
    echo
    echo -e "                ${g}╔════════════════╗"
    echo -e "                ${g}║ ${n}</>  ${c}CODEX-X${g}   ║"
    echo -e "                ${g}╚════════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║  ${y} Checking Your Internet Connection¡ ${g}      ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    while true; do
        curl --silent --head --fail https://github.com > /dev/null
        if [ "$?" != 0 ]; then
            echo -e "              ${g}╔══════════════════╗"
            echo -e "              ${g}║${C} ${r}No Internet ${g}║"
            echo -e "              ${g}╚══════════════════╝"
            sleep 2.5
        else
            break
        fi
    done
    clear
}

donotchange() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Please Enter Your ${g}Banner Name${c}"
    echo
    while true; do
        read -p "$(echo -e ${c}${A}──[Enter Your Name]────► ${n})" name
        echo
        
        if [[ -z "$name" ]]; then
            echo -e " ${E} ${r}Name cannot be empty!${c}"
            echo
            continue
        fi
        
       
        if [[ ! "$name" =~ ^[a-zA-Z0-9[:space:]-]+$ ]]; then
            echo -e " ${E} ${r}Invalid Input! No fancy fonts or symbols.\n ${E} ${r}Use letters, numbers, hyphens & spaces only.${c}"
            echo
            continue
        fi

        name="${name^^}"
        name="${name// /-}"

 
        len=${#name}
        if [[ $len -ge 1 && $len -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Name must be between ${g}1 and 8${r} characters.\n ${y}Current length is: ${g}$len${c}"
            echo
        fi
    done

    if [ -d "/data/data/com.termux/files/usr/" ]; then
        D1="$HOME/.termux"
    else
        D1="$HOME/.CODEX"
        mkdir -p "$D1"
    fi
    
    USERNAME_FILE="$D1/usernames.txt"
    INPUT_FILE="$HOME/CODEX/files/.zshrc"
    THEME_INPUT="$HOME/CODEX/files/.codex.zsh-theme"
    OUTPUT_ZSHRC="$HOME/.zshrc"
    OUTPUT_THEME="$HOME/.oh-my-zsh/themes/codex.zsh-theme"
    TEMP_FILE="$HOME/temp.zshrc"
    sed "s/DX-SIMU/$name/g" "$INPUT_FILE" > "$TEMP_FILE" &&
    sed "s/DX-SIMU/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" &&
    
CODEX="https://codex-server-x.vercel.app"
UPDATE_LOG="$HOME/.codex_update_id.txt"

curl -s --connect-timeout 5 "$CODEX/update" | jq -r '.id' | tr -d '[:space:]' > "$UPDATE_LOG" 2>/dev/null   
  
  if [[ $? -eq 0 ]]; then
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC"
        clear
        echo
        echo
        echo -e "		        ${g}Hey ${y}$name"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm Dx-Simu${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        echo -e " ${A} ${c}Your Banner created ${g}Successfully¡${c}"
        echo
        sleep 3
    else
        echo
        echo -e " ${E} ${r}Error occurred while processing the file."
        sleep 1
        rm -f "$TEMP_FILE"
    fi
    clear
}

banner() {
    clear
    echo
    echo
    echo -e "   ${y}░█████╗░░█████╗░██████╗░███████╗██╗░░██╗"
    echo -e "   ${y}██╔══██╗██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝"
    echo -e "   ${y}██║░░╚═╝██║░░██║██║░░██║█████╗░░░╚███╔╝░"
    echo -e "   ${c}██║░░██╗██║░░██║██║░░██║██╔══╝░░░██╔██╗░"
    echo -e "   ${c}╚█████╔╝╚█████╔╝██████╔╝███████╗██╔╝╚██╗"
    echo -e "   ${c}░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░░╚═╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+"
    echo -e "${c}               |D|X|-|C|O|D|E|X|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/Termuxcodex"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/alphacodex369"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}㄀ ${y}ᴄᴏᴅᴇx ${g}㄀"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}ᴅx-ᴄᴏᴅᴇx"
    echo -e "${b}┃❁ ${g}ᴅᴇᴠɪᴄᴇ: ${y}${VENDOR} ${MODEL}"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
}

setupx() {
    tr
    dxnetcheck
    banner
    
    if [ -d "/data/data/com.termux/files/usr/" ]; then
        echo -e " ${C} ${y}Detected Termux on Android¡"
        echo -e " ${lm}"
        echo -e " ${A} ${g}Updating Package..¡"
        echo -e " ${dm}"
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        echo -e " ${lm}"
        spin
    else
        echo -e " ${C} ${y}Detected Linux System¡"
        echo -e " ${lm}"
        echo -e " ${A} ${g}Updating Package..¡"
        echo -e " ${dm}"
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        echo -e " ${lm}"
        linux_spin
    fi

    if [ -d "$HOME/CODEX" ]; then
        sleep 2
        clear
        banner
        echo -e " ${A} ${p}Updating Completed...!¡"
        echo -e " ${dm}"
        clear
        banner
        echo -e " ${C} ${c}Package Setup Your System..${n}"
        echo
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        
        if [ -d "/data/data/com.termux/files/usr/" ]; then
            setup_termux_paths
        else
            setup_linux_paths
        fi
        
        donotchange
        clear
        banner
        echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Terminal¡¡ ${g}[${n}${HOMES}${g}]${n}"
        echo
        sleep 3
        cd "$HOME"
        rm -rf "$HOME/CODEX"
        kill -9 $PPID 2>/dev/null
        exit 0
    else
        clear
        banner
        echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
        echo
        echo
        sleep 3
        exit
    fi
}

banner2() {
    echo
    echo
    echo -e "   ${y}░█████╗░░█████╗░██████╗░███████╗██╗░░██╗"
    echo -e "   ${y}██╔══██╗██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝"
    echo -e "   ${y}██║░░╚═╝██║░░██║██║░░██║█████╗░░░╚███╔╝░"
    echo -e "   ${c}██║░░██╗██║░░██║██║░░██║██╔══╝░░░██╔██╗░"
    echo -e "   ${c}╚█████╔╝╚█████╔╝██████╔╝███████╗██╔╝╚██╗"
    echo -e "   ${c}░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░░╚═╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+"
    echo -e "${c}               |D|X|-|C|O|D|E|X|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/Termuxcodex"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/alphacodex369"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}㄀ ${y}ᴄᴏᴅᴇx ${g}㄀"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}ᴅx-ᴄᴏᴅᴇx"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
    echo -e "${c}╭════════════════════════════════════════════════⊷"
    echo -e "${c}┃ ${p}❏ ${g}Choose what you want to use. then Click Enter${n}"
    echo -e "${c}╰════════════════════════════════════════════════⊷"
}

options=("Free Usage" "Premium")
selected=0

display_menu() {
    clear
    banner2
    echo
    echo -e " ${g}■ \e[4m${p}Select An Option\e[0m ${g}▪︎${n}"
    echo
    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e " ${g}㄀> ${c}${options[$i]} ${g}<㄀${n}"
        else
            echo -e "     ${options[$i]}"
        fi
    done
}

if [ -d "/data/data/com.termux/files/usr/" ]; then
    clear
    echo
    echo -e " ${p}■ \e[4m${g}Use Button\e[4m ${p}▪︎${n}"
    echo
    echo -e " ${y}Termux: Use Extra key Button with move${n}"
    echo
    echo -e " UP          ↑"
    echo -e " DOWN        ↓"
    echo
    echo -e " ${g}Select option Click Enter button"
    echo
    echo -e " ${b}■ \e[4m${c}If you understand, click the Enter Button\e[4m ${b}▪︎${n}"
    read -p ""
    clear
        
    while true; do
        display_menu
        read -rsn1 input
        if [[ "$input" == $'\e' ]]; then
            read -rsn2 -t 0.1 input
            case "$input" in
                '[A') # Up arrow
                    ((selected--))
                    if [ $selected -lt 0 ]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    if [ $selected -ge ${#options[@]} ]; then
                        selected=0
                    fi
                    ;;
                *)
                    display_menu
                    ;;
            esac
        elif [[ "$input" == "" ]]; then # Enter key
            case ${options[$selected]} in
                "Free Usage")
                    echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Continue Free..!${n}"
                    sleep 1
                    setupx
                    break
                    ;;
                "Premium")
                    echo -e "\n ${g}[${n}${HOST}${g}] ${c}Wait for opening Telegram..!${n}"
                    sleep 1
                    if command -v termux-open >/dev/null 2>&1; then
                        termux-open "https://t.me/Codexownerbot"
                    else
                        xdg-open "https://t.me/Codexownerbot" 2>/dev/null
                    fi
                    echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Switching to Free Usage to continue..!${n}"
                    sleep 2
                    setupx
                    break
                    ;;
            esac
        fi
    done
else
    while true; do
        clear
        banner2
        echo
        echo -e " ${g}■ \e[4m${p}Select An Option\e[0m ${g}▪︎${n}"
        echo
        echo -e " ${g}[${n}1${g}] ${c}Free Usage${n}"
        echo -e " ${g}[${n}2${g}] ${c}Premium${n}"
        echo
        read -p "$(echo -e ${A}${g}──[${n}Select Option${g}]────► ${n})" choice
        
        if [ "$choice" == "1" ]; then
            echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Continue Free..!${n}"
            sleep 1
            setupx
            break
        elif [ "$choice" == "2" ]; then
            echo -e "\n ${g}[${n}${HOST}${g}] ${c}Wait for opening Telegram..!${n}"
            sleep 1
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "https://t.me/Codexownerbot"
            fi
            echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Switching to Free Usage to continue..!${n}"
            sleep 2
            setupx
            break
        else
            echo -e "\n ${E} ${r}Invalid Choice! Please enter 1 or 2.${n}"
            sleep 1
        fi
    done
fi
