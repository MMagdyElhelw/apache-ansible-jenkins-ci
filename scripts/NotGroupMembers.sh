#!/bin/bash
USERS=$(awk -F: '{if ($3 >= 1000 && $3 < 65534) print $1}'  /etc/passwd)
COUNT=0
for user in $USERS
do
	if ! groups $user | grep -qw 'deployG'; then
		echo "Username: $user"
		echo "UID: $(id -u "$user")"
		echo "Shell: $(cat /etc/passwd |grep $user|cut -d : -f 7 )"
		LAST=$(last -R $user | awk '{print $3,$4,$5,$6}' | head -n1)
		if [[ -n "${LAST//[[:space:]]/}" ]]; then
			echo -e  "Last Login: $LAST \n"
		else
			echo -e "Last Login: No Login yet \n"
		fi
		((COUNT++))
	fi
done

echo "Total users not in deployG: $COUNT"
