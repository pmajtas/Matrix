#!/bin/bash
clear
# Color variables
MGREEN='\033[0;92m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

declare -A matrix
declare -A LinesToPrint
num_rows=$(tput lines)
num_cols=$(tput cols)
strung1=""
strung2="  "
strung3="    "
Pos1=0
Pos2=0
Pos3=0

function cleanup() {
	tput cnorm
}

function MoveBottom() {
for ((i=num_rows;i>=1;i--)) do
    for ((j=1;j<=num_cols;j++)) do
			L=$((i-1))
        matrix[$i,$j]="${matrix[$((i-1)),$j]}"
    done
done
}

function AddString() {
	Num=$(shuf -i 0-2 -n 1)
	if [[ $Num -eq 0 ]]
	then
		return
	fi
	if [[ $strung1 == "" ]] 
	then
		len=$(shuf -i 1-15 -n 1)
		strung1=$(echo $RANDOM | md5sum | cut -c 1-$len)
		Pos1=$(shuf -i 1-190 -n 1)
	fi
	if [[ $strung2 == "" ]] 
	then
		len=$(shuf -i 1-15 -n 1)
		strung2=$(echo $RANDOM | md5sum | cut -c 1-$len)
		Pos2=$(shuf -i 1-190 -n 1)
	fi
	if [[ $strung3 == "" ]] 
	then
		len=$(shuf -i 1-15 -n 1)
		strung3=$(echo $RANDOM | md5sum | cut -c 1-$len)
		Pos3=$(shuf -i 1-190 -n 1)
	fi
	#echo $Pos
	#echo $strung
}

function ManageStrung1() {
	if [[ $strung1 != "" ]] 
	then
		matrix[0,$Pos1]=${strung1:0:1}
		strung1="${strung1:1}"
	else
	AddString
	fi
}
function ManageStrung2() {
	if [[ $strung2 != "" ]] 
	then
		matrix[0,$Pos2]=${strung2:0:1}
		strung="${strung2:1}"
	else
	AddString
	fi
}
function ManageStrung3() {
	if [[ $strung3 != "" ]] 
	then
		matrix[0,$Pos3]=${strung3:0:1}
		strung3="${strung3:1}"
	else
	AddString
	fi
}
function ManageStrungs(){
	ManageStrung1
	ManageStrung2
	ManageStrung3
}

trap cleanup EXIT


#init matrix
for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_cols;j++)) do	
			if [[ $i -eq $j ]]
			then
				matrix[$i,$j]="X"
			else
				matrix[$i,$j]=" "
			fi
        
    done
done
matrix[2,5]="@"
matrix[3,140]="P"
matrix[4,140]="M"

#let's go
tput civis
AddString
while :
do
#	echo -e "${MGREEN}This is red $TEXT ${matrix[$IDX,5]}${RESET}"

	#fill future line with spaces
	for ((j=1;j<=num_cols;j++)) do
			L=$((i-1))
        matrix[0,$j]=" "
    done
    
	ManageStrungs
	MoveBottom
	for ((i=1;i<=num_rows;i++)) do
	LINE=""
		for ((j=1;j<=num_cols;j++)) do
			LINE+="${matrix[$i,$j]}"
		done
	LinesToPrint[$i]="$LINE"
	done
	clear
	for ((i=1;i<=num_rows;i++)) do
		echo -n -e "${GREEN}${LinesToPrint[$i]}${RESET}"
		if [[ $i -ne num_rows ]] 
		then
			echo ""
		fi
	done
	sleep 0.05
done


