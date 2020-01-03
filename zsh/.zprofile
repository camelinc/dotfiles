
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export GEMPATH=${HOME}/.gem/ruby/2.6.0/bin
export PATH=$PATH:$GEMPATH
#export LC_ALL=C

#if [ -e ${HOME}/.ssh-agent-setup.sh ];then
#  source ${HOME}/.ssh-agent-setup.sh
#fi
