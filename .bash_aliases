# rm aliases cuz damn
alias rm='rm -i'
alias srm='srm -i'

# Git aliases
alias ci='git commit'
alias co='git checkout'
alias br='git branch'
alias brv='git branch -vv'
alias prune='git remote prune origin'
function dev() {
	co develop && git pull
	if ! [[ -z "$1" ]]; then
		co $1 && git merge develop
		if [[ '-p' == "$2" ]]; then
			git push
		fi
	fi
}
