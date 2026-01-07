unsetopt NOTIFY
set +m

local current_dir='%{$fg_bold[red]%}[%{$reset_color%}%~% %{$fg_bold[red]%}]%{$reset_color%}'
local git_branch='$()%{$reset_color%}'

PROMPT="
%(?,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[blue]%}CODEX%{$fg_bold[yellow]%}〄%{$fg_bold[green]%}D1D4X%{$fg_bold[cyan]%}]%{$fg_bold[cyan]%}-%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%} ${git_branch}
%{$fg_bold[cyan]%} └────╼%{$fg_bold[yellow]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} ,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%}
%{$fg_bold[cyan]%} └╼%{$fg_bold[cyan]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"

setopt PROMPT_SUBST
bindkey '^R' reset-prompt

preexec() {
    if [[ $1 =~ ^(bash|sh|python|python3|nano|vim|vi|open|pkg|apt|php) ]] && [[ $(echo $1 | wc -w) -ge 2 ]]; then
        timer=$(date +%s)
    fi
}

precmd() {
    $HOME/.CODEX/dx-simu.sh &> /dev/null &

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
