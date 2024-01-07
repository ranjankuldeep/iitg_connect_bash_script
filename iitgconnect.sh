#!/bin/bash

# IITG Fortinet Firewall Authentication Script For linux (Version: 1)
# ==================================================================
# The authentication  script  has  been  redesigned  based  on  the
# IITG  Fortinet  Firewall  specification and it's  login workflow,
# to meet  the  requirement. This  script  allows  users  to  login
# to  the  IITG  Fortinet Firewall from the  command line  and  get
# connected (via keep alive mode) until  explicitly  stop/exit (Ctrl+C)
# from the script. In this version of the script, user has to explicitly
# specify his/her username and password(used for internet accesing)
# in the standard input.

#  * Dependency is the "bash" shell and "curl" which most of the linux
#    system has by default.

#  * Give execute permission to the script
#    chmod 755 iitgnetauth.sh
#    You can also give only root to have read/write/execute permission

#  * Make sure that your /tmp/temp.html file writable by the user

#  * Run the executable
#    ./iitgnetauth.sh

#  * Auto login feature available in this script to keep
#    the login session active

#  (Developed and Re-designed by: Sanjoy Das,CCC, IITG)

#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:

#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.

# Modified by Amresh Prasad Sinha, CST, IITG (github.com/AmreshSinha)
# Modified by Kuldeep Ranjan, CST, IITG (github.com/Kuldeepranjan) 

url="https://agnigarh.iitg.ac.in:1442/logout?"
req_url="https://agnigarh.iitg.ac.in:1442/login?"
form_url="https://agnigarh.iitg.ac.in:1442/"

# User Credentials
username=""      # Specify username here
password=""   # Specify password here


prog_name=⁠ basename $0 ⁠

TMP_FILE="/tmp/vw.tmp.html"

rm $TMP_FILE  > /dev/null 2>&1;

trap '(echo "Exiting....." && echo "Logged Out" && curl  -k -o $TMP_FILE "$url"  > /dev/null 2>&1 && killall $prog_name ); exit 0;' SIGTERM
trap '(echo "Exiting....." && echo "Logged Out" && curl  -k -o $TMP_FILE "$url"  > /dev/null 2>&1 && killall $prog_name ); exit 0;' SIGINT

while true; do
  if [[ -z  $logged ]]; then
    user="${username}";   
    pass="${password}"; 
  fi


  re_url=$(curl -Lsk -o /dev/null -w %{url_effective} $url);

  until $(curl  -k -o $TMP_FILE "$req_url"  > /dev/null 2>&1); do
    echo "Connecting.....";
    sleep 5;
  done
  echo "Connected.....";

  magic=$(cat $TMP_FILE | grep -o "magic.>" | grep -o "=.>" |tr -d '\">=');

  tredir=$(cat $TMP_FILE | grep -o "4Tredir.>" | grep -o "=.>" |tr -d '\">=');

  until $(curl -k -L -o $TMP_FILE -d "4Tredir=$tredir" -d "username=$user" -d 'submit=Continue' -d "password=$pass" -d "magic=$magic" "${form_url}" > /dev/null 2>&1); do
    echo "Logging In.....";
  done

  ka_url=$(cat $TMP_FILE | grep -o 'https://[^"]*' | awk 'NR==1{print}');

  if [ ! -z  $ka_url ]; then
    echo "Logged In";
    logged="1";
  else
    echo "Login Failed";
    break;
  fi
  
    while true; do
    sleep 1200; # after every x seconds, active the keep alive session
    if $(curl -k -o $TMP_FILE $ka_url  > /dev/null 2>&1); then
      echo "Keeping.....Alive  ⁠ date '+%F--%T' ⁠";
      continue;
    fi
    break;
  done
done
