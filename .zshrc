# Path to your oh-my-zsh installation.
export ZSH="/Users/${USER}/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
# Add a tool in PATH and MANPATH
addtool() {
	curr_dir="$1"
	if [ ! -d ${curr_dir} ]; then
		echo "[addtool] Given directory doesn't exit: ${curr_dir}"
		return 1
	fi

	bin_dir="${curr_dir}/bin"
	if [ ! -d ${bin_dir} ]; then
		# Try with gnubin
		bin_dir="${curr_dir}/gnubin"
	fi
	if [ -d ${bin_dir} ] && [[ ":${PATH}:" != *":${bin_dir}:"* ]]; then
		export PATH=${bin_dir}${PATH+:${PATH}}
	fi

	man_dir="${curr_dir}/man"
	if [ ! -d ${man_dir} ]; then
		# Try with gnuman
		man_dir="${curr_dir}/gnuman"
	fi
	if [ -d ${man_dir} ] && [[ ":${MANPATH}:" != *":${man_dir}:"* ]]; then
		export MANPATH=${man_dir}${MANPATH+:${MANPATH}}
	fi
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(${HOME}/miniconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]; then
		. "${HOME}/miniconda3/etc/profile.d/conda.sh"
	else
		export PATH="${HOME}/miniconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Add brew installed packages if needed
for dir in `find /usr/local/opt -type l`
do
    # Keep only those with libexec
    curr_dir=${dir}/libexec
    if [ -d ${curr_dir} ]; then
	addtool "${curr_dir}"
    fi
done

# Direnv
eval "$(direnv hook zsh)"

# Locale
export LC_ALL="en_US.UTF-8"

# Custom Prompt
customPrompt="$(echo '${CONDA_PROMPT_MODIFIER}')%(?:%{%}➜ :%{%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)"
PS1="${customPrompt}"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi