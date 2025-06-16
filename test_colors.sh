#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "$0")/echos"

unset NOCOLORS
FATALNOEXIT=1
ok "Result matches what was expected"
info "Describe what is about to be done"
warning "Result was not expected, but non-blocking"
error "Result is wrong"
fatal "Program must stop and exit" 1
echo "---- NOCOLORS=1 ----"
NOCOLORS=1
FATALNOEXIT=
ok "(no colors) Result matches what was expected (NOCOLORS='${NOCOLORS})"
info "(no colors) Describe what is about to be done"
warning "(no colors) Result was not expected, but non-blocking"
error "(no colors) Result is wrong"
fatal "(no colors) The program must exit and stop (FATALNOEXIT='${FATALNOEXIT}')" 2

# final echo should not be displayed:
echo "All done"