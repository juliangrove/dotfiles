#! /usr/bin/env python2
from subprocess import check_output

def get_pass(gpgfile):
    return check_output("gpg -q --for-your-eyes-only --no-tty -d ~/." + gpgfile, shell=True).strip("\n")
