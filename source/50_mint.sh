# Mint-only stuff. Abort if not Ubuntu.
is_mint || return 1

# Package management
alias update="sudo aptitude update && sudo aptitude upgrade"
alias install="sudo aptitiude install"
alias remove="sudo aptitiude remove"
alias search="aptitiude search"

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
