export ZSH=/home/aorst/.oh-my-zsh

ZSH_THEME="classyTouch"

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

alias vimdiff="nvim -d"
alias zshconf="nvim ~/.zshrc"
alias vimconf="nvim ~/.config/nvim/init.vim"
alias neofetch="clear && echo && neofetch --ascii_distro mac --disable DE WM Theme Icons Shell GPU Resolution  --color_blocks --underline_char '─' --cpu_cores --os_arch"
alias stopwatch='while true; do echo -ne "\r$(date +%-M:%S:%N)"; done'

export EDITOR="nvim -u NORC"
