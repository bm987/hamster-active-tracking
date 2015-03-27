#!/bin/bash
#
# active-tracking-sh
#
# simple CLI interface for active time tracking with hamster
#

################################################################
# globals - change these to your liking
################################################################

#
# timeouts
#

PROMPT_TIME=60
DESC_PROMPT_TIME=20
WAIT_TIME=300

#
# directories
#

WORKING_DIR=~/projects/hamster-active-tracking
DB=~/.local/share/hamster-applet/hamster.db

################################################################
# main program
################################################################

#
# reset category/activity directory structure
#

rm -rf $WORKING_DIR/codes
mkdir -p $WORKING_DIR/codes
cd $WORKING_DIR/codes

#
# set up categories and activities in directory structure for 
# autocomplete and to know the ID for each activity
#

for hamster_category in `echo "select lower(name) from categories;"  | sqlite3 $DB | sed -e "s/[^a-z0-9]//g"`
do
    mkdir -p $hamster_category
done

for hamster_activity in `echo "select lower(c.name)||'/'||replace(replace(replace(lower(a.name),' ','_'),'-','_'),'/','_'),a.id from activities a join categories c on c.id = a.category_id;" | sqlite3 $DB | sed -e "s/[^a-z0-9\/|]//g"`
do
    hamster_file=`echo $hamster_activity | cut -d'|' -f1`
    hamster_code=`echo $hamster_activity | cut -d'|' -f2`
    echo "$hamster_code" > $hamster_file
done

#
# main loop
#

while true
do
    $WORKING_DIR/beep.sh 400 500 > /dev/null 2>&1
    read -e -t $PROMPT_TIME -p "What are you doing? " answer
    if [ $? -gt 128 ]
    then
	echo "Timeout exceeded - you are doing nothing."
	# read an extra 5 seconds just in case user hit ENTER just as the last timeout was exceeded
	#
	read -t 5 extra
	answer="nothing"
	echo "update facts set end_time = datetime('now','localtime') where end_time is null and start_time = (select max(start_time) from facts);" | sqlite3 $DB
    else
	if [ -z "$answer" ]
	then
	    echo "You are still doing $last."
	    answer=$last
	else
	    echo "You are doing new activity, $answer."
	    echo "update facts set end_time = datetime('now','localtime') where end_time is null and start_time = (select max(start_time) from facts);" | sqlite3 $DB
	    if [ -a "$answer" ]
	    then
		ACT_ID=`cat $answer`
		read -t $DESC_PROMPT_TIME -p "Description? " description
		if [ $? -gt 128 ]
		then
		    echo "No description provided."
		    # read an extra 5 seconds just in case user hit ENTER just as the last timeout was exceeded
		    #
		    read -t 5 extra
		    description="N/A"
		fi
		echo "insert into facts (activity_id,start_time,description) values ($ACT_ID,datetime('now','localtime'),'$description');" | sqlite3 $DB
	    else
		echo "Error! $answer is not a known activity."
	    fi
	fi
    fi
    last=$answer
    sleep $WAIT_TIME
done
