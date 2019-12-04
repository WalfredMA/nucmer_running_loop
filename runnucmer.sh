#!/bin/bash

timegap=18000

logfile='./nucmerfinished.txt'

ciapmfolder='/media/KwokRaid04/CIAPM/CIAPM_supernova/'

onethfolder='/media/KwokRaid04/1000GP/supernova2/1000GP_sn2/'

unfinshednum=1

while [[ $unfinshednum > 0 ]] ; do


finished="$(cat "$logfile")"

IFS=';' read -ra finished <<< "$finished"

ciapmfolders=$(ls "$ciapmfolder"*/ -d)

unfinishciapm=()
for folder in ${ciapmfolders[@]}
do
IFS='/' read -ra foldername <<< "$folder"
foldername=${foldername[${#foldername[@]}-1]}

if [[ $foldername = *"_assembly"* ]]
then
	foldername=${foldername%'_assembly'}
	in=0
	for x in "${finished[@]}"; do
		[[ $x == "$foldername" ]] && in=1
	done
else
	in=1
fi

if [ $in == 0 ]
then
	echo $foldername
	unfinishciapm+=($foldername)
fi

done

onethfolders=$(ls "$onethfolder"*/ -d)

unfinishoneth=()
for folder in ${onethfolders[@]}

do
IFS='/' read -ra foldername <<< "$folder"

foldername=${foldername[${#foldername[@]}-1]}

if [[ $foldername = *"_assembly"* ]]
then
	foldername=${foldername%'_assembly'}
    in=0
    for x in "${finished[@]}"; do
        [[ $x == "$foldername" ]] && in=1
    done
else
	in=1

fi
                                                                                                                                            if [ $in == 0 ]
then
    echo $foldername
    unfinishoneth+=($foldername)
fi

done

unfinshednum=$((${#unfinishoneth[@]}+${#unfinishciapm[@]}))


if [ unfinshednum > 0 ]
then

	if [ ${#unfinishoneth[@]} > 0 ]
	then
		current=${unfinishciapm[0]}
		runningfolder=ciapmfolder
	else
		current=${unfinishoneth[0]}
		runningfolder=onethfolder
	fi 



	if [ $? -eq 0 ]; then
		echo  ";$current">> $logfile
		unfinshednum=unfinshednum-1
	else
		echo 'error'
		exit(1)
	fi

	if [ unfinshednum >0 ] ; then 
		sleep $timesleep
	fi

fi
done
