#!/bin/sh

# Date format used in timelog
format='%Y-%m-%d %H:%M'

# Show current timelog
_t_timelog() {
  echo "$timelog"
}

# Run a ledger command on the timelog
_t_ledger() {
  hledger -f $timelog "$@"
}

# do something in unix with the timelog
_t_do() {
    action=$1; shift
    ${action} "$@" ${timelog}
}

# Clock in to the given project
# Clock in to the last project if no project is given
# Add an argument of the form "-5" to clock in 5 minutes ago,
# or "@12:50" to clock in at the given time.
_t_in() {
  __t_timeshift "$@"
  # [ ! "$1" ] && set -- "$@" "$(_t_last)"
  if [ -z "$__rest" ];
  then
    __rest=$(_t_last)
  fi
  echo i `date -d "$__time" "+$format"` $__rest >> $timelog
}

# Clock out
_t_out() {
  __t_timeshift "$@"
  echo o `date -d "$__time" "+$format"` $__rest >> $timelog
}

# switch projects
_t_sw() {
  __t_timeshift "$@"
  echo o `date -d "$__time" "+$format"` >> $timelog
  echo i `date -d "$__time" "+$format"` $__rest >> $timelog
}

# Show the currently clocked-in project
_t_cur() {
  sed -e '/^i/!d;$!d' ${timelog} | __t_extract_project
}

# Show the last checked out project
_t_last() {
  sed -ne '/^o/{g;p;};h;' ${timelog} | tail -n 1 | __t_extract_project
}

# Show usage
_t_usage() {
  # TODO
  cat << EOF
Usage: t action
actions:
     in - clock into project or last project
     out - clock out of project
     sw,switch - switch projects
     bal - show balance
     hours - show balance for today
     edit - edit timelog file
     cur - show currently open project
     last - show last closed project
     grep - grep timelog for argument
     cat - show timelog
     less - show timelog in pager
     timelog - show timelog file
EOF
}

#
# INTERNAL FUNCTIONS
#

__t_extract_project() {
  awk '$1 != "o" {
          line = $4
          for (i=5; i<=NF; i++)
            line = line " " $i;
          print line
      }'
}

__t_timeshift() {
  __time="now"
  __rest=""
  while (( "$#" ));
  do
    case "$1" in
      -*) __time="$1 minutes" ;;
      +*) __time="$1 minutes" ;;
      @*) __time="${1/@/}"    ;;
      *)  __rest="$__rest $1"
    esac
    shift
  done
}

action=$1; shift
[ "$TIMELOG" ] && timelog="$TIMELOG" || timelog="${HOME}/.timelog.ldg"

case "${action}" in
  in)   _t_in "$@";;
  out)  _t_out "$@";;
  sw)   _t_sw "$@";;
  bal) _t_ledger bal "$@";;
  hours) _t_ledger bal -p "today" "$@";;
  switch)   _t_sw "$@";;
  edit) _t_do $EDITOR "$@";;
  cur)  _t_cur "$@";;
  last) _t_last "$@";;
  grep) _t_do grep "$@";;
  cat)  _t_do cat "$@";;
  less)  _t_do less;;
  timelog) _t_timelog "$@";;

  h)    _t_usage;;
  *)    _t_usage;;
esac

exit 0
