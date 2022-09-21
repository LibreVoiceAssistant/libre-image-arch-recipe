#!/usr/bin/env bash

echo
echo -e "\e[33mOVOS\e[0m"
echo

echo
echo "OVOS-specific commands you can use from the Linux command prompt:"
echo -e "  ovos-cli-client       command line client, useful for debugging"
echo -e "  ovos-monitor          see all bus messages live, useful for debugging"
echo

echo
echo "Scripting utilities:"
echo -e "  ovos-listen           start listening for a voice command"
echo -e "  ovos-send <msg>       send a bus message"
echo -e "  ovos-speak <phr>      have OVOS speak a phrase to the user"
echo -e "  ovos-say-to <utt>     send an utterance to OVOS as if spoken by a user"
echo -e "  ovos-play <uri>       play with ovos audio service"
echo

echo "System commands:"
echo "  ovos-start               start ovos"
echo "  ovos-restart             restart ovos"
echo "  ovos-stop                stop ovos"
echo "  ovos-update              update ovos"
echo "  ovos-reset               factory reset ovos"
echo "  ovos-wifi                enable wifi setup"
echo

echo
echo "Other:"
echo "  ovos-help             display this message"
echo
echo -e "For more information, see \e[33mopenvoiceos.com\e[0m"
