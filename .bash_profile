export TRUSTSTORE=/net/share/export/space/bits/certificates/chain.jks
export KEYSTORE=/net/share/export/space/bits/certificates/ds.unboundid.lab.jks
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_72.jdk/Contents/Home"
export ANT_HOME="/usr/local/apache-ant-1.9.4/"
export M2_HOME="/usr/local/apache-maven-3.2.5/"
export SAUCE_HOME="/usr/local/sc-4.3.8/"
export ZAP_HOME="/usr/local/ZAP_2.4.0/"
export SVN_EDITOR=vi
export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$M2_HOME/bin:$SAUCE_HOME/bin:$ZAP_HOME:$PATH

# BASH History Settings
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# Lots of history
export HISTSIZE=100000
export HISTFILESIZE=100000
# Timestamp the history of commands
export HISTTIMEFORMAT="%d/%m/%y %T "

alias keystore=/net/share/export/space/bits/certificates/ds.unboundid.lab.jks
alias truststore=/net/share/export/space/bits/certificates/chain.jks
alias getbuild=getbuild.py
alias lss="ls -lhS"
alias zap="zap.sh"
ulimit -n 65535

