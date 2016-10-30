# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# History Options
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

PVSYS=WORK
USERDIR=peters
if [ -d "/home/jens/.wicd" ]; then
  PVSYS=HOME
  USERDIR=jens
fi
echo "Working @$PVSYS ($USERDIR)"

# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
	source "${HOME}/.bash_aliases"
fi
if [ -f "${HOME}/.bash_alias_common" ]; then
	source "${HOME}/.bash_alias_common"
fi

# Functions
#
# Some people use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
	source "${HOME}/.bash_functions"
fi

if [ "$PVSYS" == "WORK" ]; then
	# Start only one ssh-agent
	if [[ -f ${HOME}/.ssh-agent ]]
	then
		. ${HOME}/.ssh-agent > /dev/null
	fi
	if [ -z "${SSH_AGENT_PID}" -o -z "$(ps -a | awk "\$1 == ${SSH_AGENT_PID} {print ${SSH_AGENT_PID}}")" ]
	then
		/usr/bin/ssh-agent > ${HOME}/.ssh-agent
		. ${HOME}/.ssh-agent > /dev/null

		ssh-add
	fi
    export DISPLAY=:0.0
else
    export ANDROID_SWT=/usr/share/swt-3.7/lib/
    export PATH="/opt/android-sdk-update-manager/platform-tools/:${PATH}"
fi
echo "#################### PATH START ####################"
export PATH=$PATH:"/home/$USERDIR/bin"
IFS=':'
CYGWIN=nodosfilewarning
for A in ${PATH}
do	
	echo "${A}"	
done
echo "#################### PATH END ######################"

# tells pkg-config to look in an additional location, besides its standard path.
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

# Prevent Wine from adding menu entries and desktop links.
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

echo "Display: $DISPLAY"
echo "VTNR:    ${fgconsole}"
if [[ "$PVSYS" == "HOME" && ! ${DISPLAY} && ${fgconsole} == 6 ]]; then
    exec startxfce4
fi

#complete -cf sudo
export ANDROID_HOME=/opt/android-sdk-update-manager
