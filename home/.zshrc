# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$PATH:/Users/danguns/Tools/VAST-tools/pdfSignature"
export PATH=/Users/danguns/.local/bin:$PATH
export PATH="/usr/local/share/dotnet:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH="/Users/danguns/Library/Python/3.11/bin:$PATH"
export PATH=$PATH:/Users/danguns/.cargo/bin
ZSH_THEME="powerlevel10k/powerlevel10k"
export ENV=local
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search kubectl)
export GPG_TTY=$(tty)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
git() {
  if [[ $1 == "pushc" ]]; then
    command git push origin $(git symbolic-ref --short HEAD)
  else
    command git "$@"
  fi
}
export SOPS_AGE_KEY_FILE=$HOME/.sops/age.agekey

source ~/.zsh_functions

alias k="kubectl"

alias photoflow="/Users/danguns/OpenSource/photoflow/target/release/photoflow"



# Added by Antigravity CLI installer
export PATH="/Users/danguns/.local/bin:$PATH"
