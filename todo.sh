
declare -r ROOT_DIR=~/.todo

declare -r ROOT_FILE=~/.todo/.todolist


add_todo () {
	declare max_count=`tail -1 $ROOT_FILE | cut -d':' -f 1`
	declare max_count=$(($max_count+1))

	# if parameter is empty
	if [ $# = 0 ];then
		echo "run like : -a 'name of todo'"
	fi

	# if parameter is only one
	if [ $# = 1 ];then
		echo "$max_count : $1" >> $ROOT_FILE
		echo "New Todo Added!"
		echo "run 'todo -l' for listing all todos."
	fi

	# if parameter is multiple
	if [ $# -gt 1 ];then
		count=$#
		for param in $@
		do
			var=$var" "$param
		done
		echo "$max_count : $var" >> $ROOT_FILE
		echo "New Todo Added!"
		echo "run 'todo -l' for listing all todos."
	fi
}

delete_todo () {

	list_todos
	echo ""
	read -p "> Type todo id to delete : " id_to_delete

	declare max_count=`tail -1 $ROOT_FILE | cut -d':' -f 1`
	echo $max_count
	if [ $id_to_delete -le $max_count ]
		then
			grep -v "^$id_to_delete " $ROOT_FILE > $ROOT_DIR/tmp && mv $ROOT_DIR/tmp $ROOT_FILE
			echo "Successfully deleted the todo."
		else
			echo "The ID's todo does not exists."
	fi
}

list_todos () {
	declare total=`wc -l < $ROOT_FILE`
	echo "========================================================================"
	echo "ID : Title                                                    Total: "$total
	echo "------------------------------------------------------------------------"
	cat $ROOT_FILE | sort
	echo "========================================================================"
}

reset_todos () {
	cp /dev/null $ROOT_FILE
	echo "Delete All Todos"
}

search_todo () {
	if [ -z $@ ]
		then
			read -p "Type any number or text for search: " search_original
			search_todo $search_original
		else
		result=`grep "$@" $ROOT_FILE`
		search_total=`grep "$@" $ROOT_FILE | wc -l`
	    [ -z $search_total ] && search_total="0" || search_total=$search_total

		echo "========================================================================"
		echo "ID : Title                                                    Total: "$search_total
		echo "------------------------------------------------------------------------"
		echo "${result}"
		echo "========================================================================"
	fi
}

initialize () {

	# Create dir if it does not exist yet
	if [ ! -d $ROOT_DIR ];then
		mkdir $ROOT_DIR
	fi

	# Create a file if it does not exist yet
	if [ ! -f $ROOT_FILE ];then
		touch $ROOT_FILE
	fi

}

initialize

case $1 in
	"-a"|"--add")
		add_todo ${*:2}
		;;
	"-d"|"--delete")
		delete_todo
		;;
	"-l"|"--list")
		list_todos
		;;
	"-r"|"--reset")
		reset_todos
		;;
	"-s"|"--search")
		search_todo ${*:2}
		;;
	*)
		echo "todo -a for add , -d for delete, -l for list, -r for reset, -s for search"
		;;
esac
