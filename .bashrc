# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Для начала определить некоторые цвета:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color (нет цвета)

function _exit()        # функция, запускающаяся при выходе из оболочки
{
    echo -e "${RED}Сессия закрыта ${NC}"
}
trap _exit EXIT

if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1='\[\033[33m\]\t:\e[31m\u\[\033[95m\]@\[\033[32m\]\H\[\033[00m\]\w\[\033[33m\]:\$\[\033[00m\]'
else # normal
  PS1='\[\033[33m\]\t:\[\033[32m\]\u\[\033[95m\]@\[\033[32m\]\H\[\033[00m\]\w\[\033[33m\]:\$\[\033[00m\]'
fi

# Добавляем историю в файл, а не перезаписываем его.
shopt -s histappend
if [ -x /usr/bin/grc ]; then
	alias diff="grc --colour=auto diff"
	alias netstat="grc --colour=auto netstat"
	alias ping="grc --colour=auto ping"
	alias gcc="grc --colour=auto gcc"
	alias traceroute="grc --colour=auto traceroute"
    alias last="grc --colour=auto last"
fi
# Размер истории команд
export HISTSIZE="10000"
# Редактор по-умолчанию
export EDITOR='vi'

#ulimit -S -c 0 > /dev/null 2>&1
ulimit -S -c 0          # Запрет на создание файлов coredump
#set -o notify
#set -o noclobber
#
#set -o nounset
#set -o xtrace          # полезно для отладки

# Разрешающие настройки:
#shopt -s cdspell
#shopt -s cdable_vars
#shopt -s checkhash
#shopt -s checkwinsize
#shopt -s mailwarn
#shopt -s sourcepath
# shopt -s no_empty_cmd_completion  # только для bash>=2.04
#shopt -s cmdhist
shopt -s histappend histreedit histverify
#shopt -s extglob
# Запрещающие настройки:
shopt -u mailwarn
unset MAILCHECK         # Я не желаю, чтобы командная оболочка сообщала мне о прибытии почты
# export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
# export HISTIGNORE="&:bg:fg:ll:h"
# export HOSTFILE=$HOME/.hosts    # Поместить список удаленных хостов в файл ~/.hosts


if [ -e ~/.alias ]; then
	source ~/.alias
fi

alias la='ls -Al'               # показать скрытые файлы
alias ls='ls -hF --color'       # выделить различные типы файлов цветом
alias lx='ls -lXB'              # сортировка по расширению
alias lk='ls -lSr'              # сортировка по размеру
alias lc='ls -lcr'              # сортировка по времени изменения
alias lu='ls -lur'              # сортировка по времени последнего обращения
alias lr='ls -lR'               # рекурсивный обход подкаталогов
alias lt='ls -ltr'              # сортировка по дате
alias lm='ls -al |more'         # вывод через 'more'
alias tree='tree -Csu'          # альтернатива 'ls'

# Архивация
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
# Postscript,pdf,dvi.....
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps
complete -f -o default -X '!*.+(pdf|ps)' gv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
# Multimedia
complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' xv gimp
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123
complete -f -o default -X '!*.pl'  perl perl5

# Установка переменной http_proxy. Варианты - on, off, свой вариант
sethttpproxy() {
	case "${1}" in
	on)
	export http_proxy='192.168.0.252:3128' ;;
	off)
	export http_proxy='' ;;
	*)
	export http_proxy="${1}" ;;
	esac
}
