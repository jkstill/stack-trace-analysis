#!/bin/bash

typeset rptFile=stack-rpt.txt

#hardpath some cmds

declare -A cmds

cmds[grep]=''
cmds[cat]=''
cmds[awk]=''
cmds[sort]=''
#cmds[junk]=''
cmds[tee]=''
cmds[basename]=''
cmds[dirname]=''

assert_loc () {

	typeset cmd=$1
	typeset location=$2

	[[ -z $location ]] && {
		echo
		echo assert_loc: Cannot locate $cmd in accepted paths
		echo
		exit 99
	}
}

hardpath () {
	for cmd in ${!cmds[@]}
	do
		# echo CMD: $cmd
		# look for the command in /bin /usr/bin and /usr/local/bin

		typeset location=''

		if [ -x /bin/${cmd} ]; then
			location=/bin/${cmd}
		elif [ -x /usr/bin/${cmd} ]; then
			location=/usr/bin/${cmd}
		elif [ -x /usr/local/bin/${cmd} ]; then
			location=/usr/local/bin/${cmd}
		fi

		assert_loc $cmd $location

		cmds[$cmd]=$location

	done
}


errMsg () {
	typeset msg="$*"
	echo "Error! - $msg"
}

banner () {
	typeset heading="$*"
	typeset filler='###################'

	echo "$filler $heading $filler"

}

usage () {

${cmds[cat]} <<-EOF

usage: get-stack.sh

  get-stack.sh -a alert.log -r report.txt

	-a path to alert log
	-f output report - defaults to stack-rpt.txt

EOF

}

# main

hardpath

typeset alertLog='nosuchfile'

while getopts a:f:h arg
do
	case $arg in
		a) alertLog=$OPTARG;;
		f) rptFile=$OPTARG;;
		h) usage; exit 0;;
		*) usage; exit 1;;
	esac
done

[ -r $alertLog ] ||	{
	errMsg "Cannot read $alertLog"
	exit 2
}

[ -f $rptFile ] && {
	errMsg "Cowardly refusing to overwrite $rptFile"
	exit 3
}

> $rptFile
rc=$?

[[ $rc -ne 0 ]] && {
	errMsg "Cannot create $rptFile"
	exit 4
}


for f in $( ${cmds[grep]} -3	'ORA-.*600' $alertLog \
	| ${cmds[grep]} 'Incident details' \
	| ${cmds[sort]} -u \
	| ${cmds[awk]} '{ print $4 }' \
)
do
	banner $( ${cmds[basename]} $f)
	./get-stack.pl < $f
done | ${cmds[tee]}	$rptFile

