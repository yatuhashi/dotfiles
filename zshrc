#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export PATH=/Users/yatuhashi/Develop/Shell:$PATH
alias vim='/Users/yatuhashi/Build/nvim-osx64/bin/nvim "$@"'
export EDITOR='/Users/yatuhashi/Build/nvim-osx64/bin/nvim "$@"'

fpath=($HOME/.zprezto/modules/cd-bookmark(N-/) $fpath)
autoload -Uz cd-bookmark

alias dc='docker'
alias d-c='docker-compose'
alias doc-c='docker-compose'
alias chbg='changebg.sh'
alias ghc='stack ghc --'
alias ghci='stack ghci --'
alias runhaskell='stack runhaskell --'
alias psa="ps aux"
alias psg="ps aux | grep "
alias brewu='brew update  && brew upgrade && brew cleanup && brew prune && brew doctor'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias cv='cd-bookmark'
alias c='clear'
alias u='cd ~/'
alias h='history'
alias t='tig'
alias ta='tig --all'
alias g='git'
alias z='vim ~/.zshrc'
alias sp='tmux split-window -h'
alias vs='tmux split-window -v'
alias lla='ls -lah'
alias num='ls -1 | wc -l'
alias ks='ls -lah'
alias pv='pyenv version'
alias pvs='pyenv versions'
alias proxy='export http_proxy="http://cache.ccs.kogakuin.ac.jp:8080"'
alias proxys='export https_proxy="https://cache.ccs.kogakuin.ac.jp:8080"'
alias noproxy='export http_proxy=""'
alias noproxys='export https_proxy=""'
alias gol= 'GOOS=linux GOARCH=amd64 go'
alias gow= 'GOOS=windows GOARCH=amd64 go'
alias ff='(){find . -type f | xargs -I{} sh -c "echo {}; cat {} | grep $1" }'
alias myip='curl whatismyip.akamai.com; echo'
alias mydns='curl -s whatismyip.akamai.com | xargs dig +short -x'
alias -s html=open
alias -s py=python
alias -s scala=scala
alias -s {txt,memo,md}=vim
alias -s dvi=dvipdfmx
function gocode(){
    echo 'fmt'$1
    go fmt $1;
    echo 'build'$1
    go build $1;
}
alias -s go=gocode
function runcpp () { g++ $1 && shift && ./a.out $@ }
alias -s {c,cpp}=runcpp
function extract() {
    case $1 in
        *.tar.gz|*.tgz) tar xzvf $1;;
        *.tar.xz) tar Jxvf $1;;
        *.zip) unzip $1;;
        *.lzh) lha e $1;;
        *.tar.bz2|*.tbz) tar xjvf $1;;
        *.tar.Z) tar zxvf $1;;
        *.gz) gzip -d $1;;
        *.bz2) bzip2 -dc $1;;
        *.Z) uncompress $1;;
        *.tar) tar xvf $1;;
        *.arj) unarj $1;;
    esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

#kill procce name snipet
zstyle ':completion:*:processes' command "ps -u $USER"

bg() {
    /Users/yatuhashi/Build/dotfiles/change
    if [ -z "$BUFFER" ]; then
            osascript -e "tell application \"iTerm\"
                                        tell current window
                                            tell current session
                                                set background image to \"/Users/yatuhashi/Pictures/Fate/Haikei/result.jpg\"
                                            end tell
                                        end tell
                                    end tell"
            zle reset-prompt
    else
        zle accept-line
    fi
}
zle -N bg
bindkey '^m' bg

rbg() {
    if [ -z "$BUFFER" ]; then
            osascript -e "tell application \"iTerm\"
                            tell current window
                                tell current session
                                    set background image to \"/Users/yatuhashi/Pictures/zsh/100.png\"
                                end tell
                            end tell
                        end tell"
            zle reset-prompt
    else
        zle accept-line
    fi
}
zle -N rbg
bindkey '^h' rbg

##############################################
#  Do Redo
#  +   -
###########################################
path_history=($(pwd))
path_history_index=1
path_history_size=1

function push_path_history {
    local curr_path
    curr_path=$1

    if [ $curr_path = $path_history[$path_history_index] ]; then
        # do nothing
    else
        local path_history_cap
        path_history_cap=$#path_history

        if [ $path_history_index -eq $path_history_cap ]; then
            local next_cap
            next_cap=$(($path_history_cap * 2))

            # ほんとに伸長されているかは不明
            path_history[$next_cap]=
        fi

        path_history_index=$(($path_history_index+1))
        path_history[$path_history_index]=$curr_path
        path_history_size=$path_history_index
    fi
}

function - {
    if [ $path_history_index -eq 1 ]; then
        # do nothing
    else
        path_history_index=$(($path_history_index-1))

        local prev_path
        prev_path=$path_history[$path_history_index]

        cd $prev_path
    fi
}

function + {
    if [ $path_history_index -eq $path_history_size ]; then
        # do nothing
    else
        path_history_index=$(($path_history_index+1))

        local next_path
        next_path=$path_history[$path_history_index]

        cd $next_path
    fi
}

function reset_path_history {
    path_history=($(pwd))
    path_history_index=1
    path_history_size=1
}

function chpwd {
    push_path_history $(pwd)
}


#################################################
# cdr coomand & Peco Directory History          #
#################################################
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^e' peco-cdr

#################################################
# ######## #        #   #     #  #       #      #
#    #     # #    # #   #     #    #   #        #
#    #     #  #  #  #   #     #      #          #
#    #     #    #   #    #   #     #   #        #
#    #     #        #     ###   #        #      #
#################################################
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} ---tmux--- ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
tmux_automatically_attach_session

## tmux ssh split
autoload -Uz add-zsh-hook
function tmux_ssh_preexec() {
    local command=$1
    if [[ "$command" = *ssh* ]]; then
        tmux setenv TMUX_SSH_CMD_$(tmux display -p "#I") $command
    fi
}
add-zsh-hook preexec tmux_ssh_preexec

## tmux ssh hostname
function ssh() {
    if [[ -n $(printenv TMUX) ]]
    then
        local window_name=$(tmux display -p '#{window_name}')
        tmux rename-window -- "$*" # zsh specified
        # tmux rename-window -- "${!#}" # for bash
        command ssh $@
        tmux rename-window $window_name
    else
        command ssh $@
    fi
}


#################################################
#           SSSS     SSSS     H   H             #
#          S        S         H   H             #
#           SSSS     SSSS     HHHHH             #
#               S        S    H   H             #
#           SSSS     SSSS     H   H             #
#################################################
echo -n "ssh-agent: "
if [ -e ~/.ssh-agent-info ]; then
    source ~/.ssh-agent-info
fi

ssh-add -l >&/dev/null
if [ $? = 2 ] ; then
    echo -n "ssh-agent: restart...."
    ssh-agent >~/.ssh-agent-info
    source ~/.ssh-agent-info
fi
if ssh-add -l >&/dev/null ; then
    echo "ssh-agent: Identity is already stored."
else
    ssh-add
fi

[[ -s "/Users/yatuhashi/.gvm/scripts/gvm" ]] && source "/Users/yatuhashi/.gvm/scripts/gvm"
