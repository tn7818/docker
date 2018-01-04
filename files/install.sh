#!/usr/bin/expect -f

#Set Expect TimeOut
set timeout 60

#Set System Arc Type (Default : blank)
set OS_ID ""

#Set Upas Installer Store Path
set UPAS_FILE [lindex $argv 6]

#Set UPAS Install  PATH (UPAS_HOME)
set UPAS_PATH [lindex $argv 0]

#Set UPAS SERVER TYPE (1 DAS  2 MS )
set SERVER_TYPE [lindex $argv 1]

#Set UPAS SERVER MODE (1 Pro 2 DeV)
set SERVER_MODE [lindex $argv 2]

#Set JDK Install PATH (JAVA_HOME)
set JAVA_HOME [lindex $argv 3]

#Set DAS PASSWORD
set DAS_PWD [lindex $argv 4]

#Set UPAS DOMAIN NAME
set UPAS_DOMAIN [lindex $argv 5]



# Install UPAS
spawn bash $UPAS_FILE

expect {
        "PRESS <ENTER> TO CONTINUE:\ " {send "\r";exp_continue}

        "DO YOU ACCEPT THE TERMS OF THIS LICENSE AGREEMENT? (Y/N):\ " {send "Y\r";exp_continue}

        "Choose Current System (DEFAULT: *):\ " {send "$OS_ID\r";exp_continue}

        "ENTER AN ABSOLUTE PATH*\ " {send "$UPAS_PATH\r";exp_continue}

        "IS THIS CORRECT? (Y/N):\ " {send "Y\r";exp_continue}

        "ENTER THE NUMBER OF THE DESIRED CHOICE*\ " {send "$SERVER_MODE\r";exp_continue}

        "ENTER THE NUMBER FOR THE INSTALL SET*\ " {send "$SERVER_TYPE\r";exp_continue}

        "Enter the JDK path (DEFAULT: *):\ " {send "$JAVA_HOME\r";exp_continue}

        "Input Password::\ " {send "$DAS_PWD\r";exp_continue}

        "Corfirm Password::\ " {send "$DAS_PWD\r";exp_continue}

        "Enter the domain name (DEFAULT: upas_domain):\ " {send "$UPAS_DOMAIN\r";exp_continue}

        "PRESS <ENTER> TO EXIT THE INSTALLER:\ " {send "\r"}
}

#expect "*]$\" {send "exit\r"}

expect eof

