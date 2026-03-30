ZSH_THEME="codex"

if [ -d "/data/data/com.termux/files/usr/" ]; then
    export ZSH=$HOME/.oh-my-zsh
    TOOLX_DIR="$HOME/.toolx"
    D1="$HOME/.termux"
    PLUGINS_DIR="/data/data/com.termux/files/home/.oh-my-zsh/plugins"
    alias rd='termux-reload-settings'
else
    export ZSH=$HOME/.oh-my-zsh
    TOOLX_DIR="$HOME/.toolx"
    D1="$HOME/.CODEX"
    PLUGINS_DIR="$HOME/.oh-my-zsh/plugins"
    alias rd='source ~/.zshrc 2>/dev/null'
fi

plugins=(git)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh" >/dev/null 2>&1
fi

if [ -f "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" >/dev/null 2>&1
fi

if [ -f "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >/dev/null 2>&1
fi

if command -v lsd >/dev/null 2>&1; then
alias la='lsd -l --blocks size,name --color always | column -c $(tput cols)'
alias ls='lsd -l --blocks size,name --color always'
alias lt='lsd --tree --blocks size,name --color always --icon always'
fi

[ -f "$TOOLX_DIR/chat" ] && alias chat="$TOOLX_DIR/chat"
[ -f "$TOOLX_DIR/unstall" ] && alias unstall="$TOOLX_DIR/unstall"
[ -f "$TOOLX_DIR/dev" ] && alias dev="$TOOLX_DIR/dev"
[ -f "$TOOLX_DIR/dev" ] && alias report="$TOOLX_DIR/dev"
[ -f "$TOOLX_DIR/update" ] && alias update="$TOOLX_DIR/update"
[ -f "$TOOLX_DIR/bname" ] && alias bname="$TOOLX_DIR/bname"
[ -f "$TOOLX_DIR/help" ] && alias help="$TOOLX_DIR/help"

r='\033[91m'
p='\033[1;95m'
y='\033[93m'
g='\033[92m'
n='\033[0m'
b='\033[94m'
c='\033[96m'

X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;32m]\033[1;92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
aHELL="\uf489"
USER="\uf007"
TERMINAL="\ue7a2"
PKGS="\uf8d6"
UPT="\uf49b"
CAL="\uf073"

bol='\033[1m'
bold="${bol}\e[4m"
THRESHOLD=100

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage
    
    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    if [ -z "$disk_usage" ]; then disk_usage=0; fi 

    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e " ${g}[${n}\uf0a0${g}] ${r}WARN: ${c}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e " ${g}[${n}\uf0e7${g}] ${c}Disk usage: ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    fi
}

banner() {
command clear
echo
echo -e "    ${y}░█████╗░░█████╗░██████╗░███████╗██╗░░██╗"
echo -e "    ${y}██╔══██╗██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝"
echo -e "    ${y}██║░░╚═╝██║░░██║██║░░██║█████╗░░░╚███╔╝░"
echo -e "    ${c}██║░░██╗██║░░██║██║░░██║██╔══╝░░░██╔██╗░"
echo -e "    ${c}╚█████╔╝╚█████╔╝██████╔╝███████╗██╔╝╚██╗"
echo -e "    ${c}░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░░╚═╝${n}"
echo
}

spin() {
    command clear
    banner
    local pid=$!
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    while ps -p $pid > /dev/null 2>&1; do
        for i in "${spinner[@]}"; do
            tput civis
            echo -ne "\033[1;96m\r [+] Downloading..please wait.........\e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
            sleep $delay
            printf "\b\b\b\b\b\b\b\b"
        done
    done
    printf "   \b\b\b\b\b"
    tput cnorm
    printf "\e[1;93m [Done]\e[0m\n"
    echo
    sleep 1
}

CODEX="https://codex-server-x.vercel.app"
mkdir -p "$D1" 
UPDATE_LOG="$D1/update_id.txt"

udp() {
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        local update_data=$(curl -s --connect-timeout 3 "$CODEX/update" 2>/dev/null)
        local server_id=$(echo "$update_data" | jq -r '.id' 2>/dev/null)
        local server_msg=$(echo "$update_data" | jq -r '.message' 2>/dev/null)

        if [ -n "$server_id" ] && [ "$server_id" != "null" ]; then
            local current_id=""
            if [ -f "$UPDATE_LOG" ]; then
                current_id=$(cat "$UPDATE_LOG")
            fi

            if [ "$current_id" != "$server_id" ]; then
                banner
                echo -e " ${A} ${c}Tools Updated ${n}| ${c}New ${g}$server_msg"
                sleep 3
                cd "$HOME" || return
                rm -rf CODEX
                git clone https://github.com/Alpha-Codex369/CODEX.git >/dev/null 2>&1 &
                spin
                
                echo "$server_id" > "$UPDATE_LOG"
                
                if [ -d "CODEX" ]; then
                    cd CODEX || return
                    bash install.sh
                fi
            fi
        fi
    fi
}

load() {
    command clear
    echo -e "${TERMINAL}${r}●${n}"
    sleep 0.2
    command clear
    echo -e "${TERMINAL}${r}●${y}●${n}"
    sleep 0.2
    command clear
    echo -e "${TERMINAL}${r}●${y}●${b}●${n}"
    sleep 0.2
}

PUT() { echo -en "\033[${1};${2}H"; }
DRAW() { echo -en "\033%"; echo -en "\033(0"; }
WRITE() { echo -en "\033(B"; }
HIDECURSOR() { echo -en "\033[?25l"; }
NORM() { echo -en "\033[?12l\033[?25h"; }

draw_dashboard() {
    local data=$(check_disk_usage)
    local widths=$(stty size 2>/dev/null | awk '{print $2}')
    if [ -z "$widths" ] || [ "$widths" -lt 10 ]; then widths=$(tput cols 2>/dev/null || echo 80); fi

    local width=$widths
    local var=$((width - 2))
    local var2=$(printf '═%.0s' $(seq 1 $var))
    local var3=$(printf ' %.0s' $(seq 1 $var))
    local var4=$((width - 20))
    if [ $var4 -lt 1 ]; then var4=1; fi

    local prefix="${TERMINAL}${r}●${y}●${b}●${n}"
    local clean_prefix=$(echo -e "$prefix" | sed 's/\x1b\[[0-9;]*m//g')
    local prefix_len=${#clean_prefix}
    local clean_data=$(echo -e "${data}" | sed 's/\x1b\[[0-9;]*m//g')
    local data_len=${#clean_data}

    local data_start=$(((width - data_len) / 2))
    local padding=$((data_start - prefix_len))
    if [ $padding -lt 0 ]; then padding=0; fi

    local spaces=$(printf '%*s' $padding "")

    # Draw Header
    PUT 1 1
    echo -e "${prefix}${spaces}${data}${c}"

    # Draw the Background Box Outline
    PUT 2 1
    echo -e "\033[36;1m╔${var2}╗\033[0m"
    for ((i=3; i<=10; i++)); do
        PUT $i 1
        echo -e "\033[36;1m║${var3}║\033[0m"
    done
    PUT 11 1
    echo -e "\033[36;1m╚${var2}╝\033[0m"

    # Print the ASCII art inside the box
    PUT 4 1
    if command -v simu >/dev/null 2>&1; then
        simu -w $width "DX-SIMU" | lolcat -f 2>/dev/null || simu -w $width "DX-SIMU"
    fi

    # Redraw borders to prevent ASCII space overlapping & glitching
    PUT 2 1
    echo -e "\033[36;1m╔${var2}╗\033[0m"
    for ((i=3; i<=10; i++)); do
        PUT $i 1
        echo -e "\033[36;1m║\033[0m"
        PUT $i $width
        echo -e "\033[36;1m║\033[0m"
    done
    PUT 11 1
    echo -e "\033[36;1m╚${var2}╝\033[0m"

    # CODEX Version Tag Inside
    PUT 10 ${var4}
    echo -e "\e[32m[\e[0m\uf489\e[32m] \e[36mCODEX \e[36m1.5\e[0m"

    # Footer section
    PUT 12 1
    local ads1=""
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        ads1=$(curl -s --connect-timeout 2 "$CODEX/ads" | jq -r '.message' 2>/dev/null)
    fi

    if [ -z "$ads1" ] || [ "$ads1" == "null" ]; then
        local DATE=$(date +"%Y-%b-%a ${g}—${c} %d")
        local TM=$(date +"%I:%M:%S ${g}— ${c}%p")
        echo -e " ${g}[${n}${CAL}${g}] ${c}${TM} ${g}| ${c}${DATE}"
    else
        echo -e " ${g}[${n}${PKGS}${g}] ${c}Ｃｏｄｅｘ: ${g}$ads1"
    fi

    # Reset Cursor Below drawing to prevent prompt overlap
    PUT 13 1
    NORM
}

smart_clear() {
    if [ "$1" = "n" ]; then
        command clear
    else
        command clear
        draw_dashboard
    fi
}
alias clear='smart_clear'

udp
HIDECURSOR
load
command clear
draw_dashboard
