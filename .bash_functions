####################
#    WINE                   #
####################
prefix() {
    if [ -z "$1" ]; then
        echo "${HOME}/.wine/"
    else
        echo "${HOME}/.local/share/wineprefixes/$1"
    fi
}

lsp() {
    ls $* "${HOME}/.local/share/wineprefixes"
}

run() {
    WINEPREFIX="$(prefix $1)" wine cmd /c "C:\\run-$1.bat"
}

#if [[ $EUID -ne 0 ]]; then
#	if [ "$PVSYS" == "HOME" ]; then
#		complete -W "$(lsp)" prefix run
#	fi
#fi

####################
#  CYGWIN                #
####################
open() {
  if [[ -n "$1" ]]; then 
    explorer /e, $(cygpath -mal "$PWD/$1");
  else 
    explorer /e, $(cygpath -mal "$PWD");
  fi
}

expl() {
  if [[ -n "$1" ]]; then 
    explorer $( cygpath $1 -w)
  else 
    explorer $( cygpath $PWD -w)
  fi
}
#function .t() {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
#}

showPath() {
	echo "#################### PATH START ####################"	
	setopt sh_word_split
	IFS=':'
	CYGWIN=nodosfilewarning
	i=0;
	for p in $PATH; do
		echo "$i $p"
		((i++))
	done
	unsetopt sh_word_split
	echo "#################### PATH END ######################"
}

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
