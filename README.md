# t #

## Description ##

`t` is a shell script for working with [hledger][]'s [timeclock][] format.

## Install ##

Download and install the script to a directory that exists in your `$PATH`. For example, `$HOME/bin`:

    curl --silent -G https://raw.github.com/ariep/t/master/t -o ~/bin/t
    chmod +x ~/bin/t

Set the location of your timelog file:

    export $TIMELOG=$HOME/.timelog.ldg

The default location is `$HOME/.timelog.ldg`.

## Usage ##

Usage: `t <action>`

### Actions ###

- `t in` - clock into project or last project
- `t out` - clock out of project
- `t sw,switch` - switch projects
- `t bal` - show balance
- `t hours` - show balance for today
- `t edit` - edit timelog file
- `t cur` - show currently open project
- `t last` - show last closed project
- `t grep` - grep timelog for argument
- `t cat` - show timelog
- `t less` - show timelog in pager
- `t timelog` - show timelog file

## References ##

Here are you can read more about the timeclock file format, and how to extract reports
from your timelog file using [hledger][]:

- [Timeclock files][timeclock]

[timeclock]: http://hledger.org/manual.html#timeclock-format
[hledger]: http://hledger.org/
