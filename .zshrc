
if type nvim > /dev/null 2>&1; then
    alias vi='nvim'
fi
alias mvim="/Applications/MacVim.app/Contents/bin/mvim"
alias v='nvim'

bindkey -e

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export EDITOR=`which nvim`

export PATH="$HOME/Library/Python/3.8/bin:/opt/homebrew/bin:$PATH"
export PATH="/usr/local/opt/binutils/bin:$PATH"
export PATH="/usr/local/opt/binutils/bin:$PATH"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# alias vim=/usr/local/bin/vim

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi


source "$HOME/.zinit/bin/zinit.zsh"
#autoload -Uz _zinit
#(( ${+_comps} )) && _comps[zinit]=_zinit
#zplugin pack for fzf

zinit for \
		OMZL::directories.zsh \
		OMZL::functions.zsh

zinit wait lucid as=program pick="$ZPFX/bin/(fzf|fzf-tmux)" \
    atclone="cp shell/completion.zsh _fzf_completion; \
      cp bin/(fzf|fzf-tmux) $ZPFX/bin" \
    make="!PREFIX=$ZPFX install" \
    multisrc'shell/{key-bindings,completion}.zsh' for \
    junegunn/fzf

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

# 快速目录跳转
zinit ice lucid wait='1'
zinit load skywind3000/z.lua

zinit ice depth=1; zinit light romkatv/powerlevel10k
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/common-aliases/common-aliases.plugin.zsh
zinit snippet OMZ::plugins/virtualenv/virtualenv.plugin.zsh

# Python {{{
zinit ice atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
    atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
    as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
zinit light pyenv/pyenv

zinit ice cloneonly nocompile nocompletions \
    atclone"mkdir -p $PYENV_ROOT/plugins;
    ln -sf ${ZINIT[PLUGINS_DIR]}/pyenv---pyenv-virtualenv $PYENV_ROOT/plugins/pyenv-virtualenv"
zinit light pyenv/pyenv-virtualenv

zinit ice cloneonly nocompile nocompletions \
    atclone"mkdir -p $PYENV_ROOT/plugins;
    ln -sf ${ZINIT[PLUGINS_DIR]}/pyenv---pyenv-virtualenvwrapper $PYENV_ROOT/plugins/pyenv-virtualenvwrapper"
zinit light pyenv/pyenv-virtualenvwrapper

# zinit ice lucid wait'1' atinit"local ZSH_PYENV_LAZY_VIRTUALENV=true" \
#   atload"pyenv virtualenvwrapper_lazy"
# zinit light davidparsson/zsh-pyenv-lazy
# }}}


zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# ogham/exa, replacement for ls
zinit ice wait lucid from"gh-r" as"program" mv"bin/exa* -> exa"
zinit light ogham/exa

zinit ice wait lucid from"gh-r" as"program" mv"jcli* -> jcli"
zinit light jenkins-zh/jenkins-cli

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# zinit lucid wait'1' from"gh-r" as"program" mv"direnv* -> direnv" \
#     atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
#     pick"direnv" src="zhook.zsh" for \
#         light-mode direnv/direnv
