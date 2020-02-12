# vim:ft=zsh
#

() {
	local LC_ALL="" LC_CTYPE="en_US.UTF-8"
}

prompt_segment() {

	local fg

	[[ -n $1 ]] && fg="%F{$1}" || fg="%f"
	[[ -n $3 ]] && fg="%B$fg" || fg="%b$fg"

	echo -n "%{$fg%} "

	[[ -n $2 ]] && echo -n $2
}

prompt_segment_nos() {

	local fg

	[[ -n $1 ]] && fg="%F{$1}" || fg="%f"
	[[ -n $3 ]] && fg="%B$fg" || fg="%b$fg"

	echo -n "%{$fg%}"

	[[ -n $2 ]] && echo -n $2
}

prompt_context() {

	if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		prompt_segment yellow "%(!.%{%F{red}%}.)%m"
	fi
}

prompt_git() {

	local PL_BRANCH_CHAR

	() {
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"

		PL_BRANCH_CHAR=$'\ue0a0'         # 
		PL_ARROWR_CHAR=$'\u203a' 		 # ›
		PL_ARROWL_CHAR=$'\u2039' 		 # ‹
		#PL_ARROWL_CHAR=$'\u00ab' 		 # ‹
		#PL_ARROWR_CHAR=$'\u00bb' 		 # ›
	}

	local ref dirty mode repo_path
	repo_path=$(git rev-parse --git-dir 2>/dev/null)

	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		dirty=$(parse_git_dirty)
		ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

		if [[ -n $dirty ]]; then
		  prompt_segment yellow
		else
		  prompt_segment green
		fi

		#if [[ -e "${repo_path}/BISECT_LOG" ]]; then
		#  mode=" <B>"
		#elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
		#  mode=" >M<"
		#elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
		#  mode=" >R>"
		#fi

		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' enable git
		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		zstyle ':vcs_info:*' stagedstr '✚'
		zstyle ':vcs_info:*' unstagedstr '●'
		zstyle ':vcs_info:*' formats ' %u%c'
		zstyle ':vcs_info:*' actionformats ' %u%c'

		vcs_info

		#echo -n "%{%B"
		echo -n "$PL_ARROWL_CHAR${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}$PL_ARROWR_CHAR"
		#echo -n "%b%}"
	fi
}

prompt_dir() {
	prompt_segment cyan '%~'
}

prompt_status() {
	local symbols

	symbols=()

	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

	[[ -n "$symbols" ]] && prompt_segment black "$symbols"
}

prompt_end() {
	echo -n "%{%f%}"
}

build_prompt() {

	RETVAL=$?
	prompt_status

	prompt_segment white "["
	prompt_context
	prompt_segment white "|"
	prompt_dir
	prompt_segment white "]"

	prompt_git
	prompt_end
}

#PROMPT='%{%f%b%k%}$(build_prompt) '
#PROMPT="%{%f%b%k%}$(build_prompt) 
#$(prompt_segment black white '')$(CURRENT_BG=black prompt_end) "
PROMPT='%{%f%b%k%}$(build_prompt)
 %{%B%F{green}%}$%{%f%b%} '

