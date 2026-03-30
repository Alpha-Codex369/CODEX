unsetopt NOTIFY
set +m

local current_dir='%{$fg_bold[red]%}[%{$reset_color%}%~% %{$fg_bold[red]%}]%{$reset_color%}'
local git_branch='$()%{$reset_color%}'

PROMPT="
%(?,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[blue]%}CODEX%{$fg_bold[yellow]%}〄%{$fg_bold[green]%}DX-SIMU%{$fg_bold[cyan]%}]%{$fg_bold[cyan]%}-%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%} ${git_branch}
%{$fg_bold[cyan]%} └────╼%{$fg_bold[yellow]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} ,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%}
%{$fg_bold[cyan]%} └╼%{$fg_bold[cyan]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"

setopt PROMPT_SUBST
bindkey '^R' reset-prompt

command_not_found_handler() {
    local g="\033[1;92m"
    local c="\033[1;96m"
    local n="\033[0m"
    
    echo
    echo -e "                     ${g}Headache...*${n}"
    echo -e "${c}              (\_/)${n}"
    echo -e "${c}              (${n}*—*${c})${n}"
    echo -e "${c}             ⊂(___)づ${n}"
    echo
    
    local c_green=$'\033[1;92m'
    local c_blue=$'\033[1;94m'
    local c_red=$'\033[1;91m'
    local c_cyan=$'\033[1;96m'
    local c_reset=$'\033[0m'
    local c_pink=$'\033[1;95m'
    local c_yellow=$'\033[1;93m'
    
    local output=""

    if [[ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]]; then
        output=$(/data/data/com.termux/files/usr/libexec/termux/command-not-found "$1" 2>&1)
    elif [[ -x /usr/lib/command-not-found ]]; then
        output=$(/usr/lib/command-not-found -- "$1" 2>&1)
    elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
        output=$(/usr/share/command-not-found/command-not-found -- "$1" 2>&1)
    else
        output="simu: command not found: $1"
    fi

        echo "$output" | sed -E \
        -e "s/([Cc]ommand)/${c_green}\1${c_reset}/g" \
        -e "s/\b([Ii]n)\b/${c_green}\1${c_reset}/g" \
        -e "s/\b([Pp]kg)\b/${c_blue}\1${c_reset}/g" \
        -e "s/\b([Ii]nstall)\b/${c_yellow}\1${c_reset}/g" \
        -e "s/\b([Ii]nstalled)\b/${c_yellow}\1${c_reset}/g" \
        -e "s/\b([Ff]ound)\b/${c_red}\1${c_reset}/g" \
        -e "s/\b([Ss]udo)\b/${c_pink}\1${c_reset}/g" \
        -e "s/\b([Pp]rogram)\b/${c_green}\1${c_reset}/g" \
        -e "s/\b([Pp]ackage)\b/${c_cyan}\1${c_reset}/g" \
        -e "s/([0-9]+)/${c_pink}\1${c_reset}/g" >&2
    return 127
}
exit() {
    if [[ "$1" == "x" ]]; then
        local g="\033[32m"
        local c="\033[36m"
        local y="\033[33m"
        local n="\033[0m"
        
        echo
        echo -e "                      .  ${g}ᶻ 𝗓 𐰁 .ᐟ...${n}"
        echo -e "${c}              (\_/) .${n}"
        echo -e "${c}              (${y}-_-${c})."
        echo -e "${c}             ⊂(___)づ${n}"
        echo
        sleep 1.5
        builtin exit
    else
        echo
        echo -e "                      .  ${g}ᶻ 𝗓 𐰁 .ᐟ...${n}"
        echo -e "${c}              (\_/) .${n}"
        echo -e "${c}              (${y}-_-${c})."
        echo -e "${c}             ⊂(___)づ${n}"
        echo
        builtin exit "$@"
    fi
}

preexec() {
    if [[ $1 =~ ^(bash|sh|python|python3|nano|vim|vi|open|pkg|apt|php) ]] && [[ $(echo $1 | wc -w) -ge 2 ]]; then
        timer=$(date +%s)
    fi
}

precmd() {

    if [ $timer ]; then
        now=$(date +%s)
        elapsed=$((now - timer))
        hours=$((elapsed / 3600))
        minutes=$(( (elapsed % 3600) / 60 ))
        seconds=$((elapsed % 60))

        if [[ $hours -gt 0 ]]; then
            if [[ $minutes -gt 0 ]]; then
                elapsed_str="%F{blue}Run time:%f %F{cyan}${hours}%f h %F{cyan}${minutes}%f m"
            else
                elapsed_str="%F{blue}Run time:%f %F{cyan}${hours}%f h"
            fi
        elif [[ $minutes -gt 0 ]]; then
            if [[ $seconds -gt 0 ]]; then
                elapsed_str="%F{blue}Run time:%f %F{cyan}${minutes}%f m %F{cyan}${seconds}%f s"
            else
                elapsed_str="%F{blue}Run time:%f %F{cyan}${minutes}%f m"
            fi
        else
            elapsed_str="%F{blue}Run time:%f %F{cyan}${seconds}%f s"
        fi

        export RPROMPT='%F{green}[%f⏱%F{green}]%f ${elapsed_str}'
        unset timer
    else
        unset elapsed_str
        export RPROMPT='%F{green}[%f%F{green}]%f %F{cyan}%D{%L:%M:%S}%f%F{white} - %f%F{cyan}%D{%p}%f'
    fi
}
