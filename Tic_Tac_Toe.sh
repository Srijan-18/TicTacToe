#CONSTANTS

TOSS_USER="1"

#VARIABLES

declare -a gameBoard
cell=0
toss="none"

#FUNCTION TO RESET GAME BOARD WITH RESPECTIVE CELL NUMBERS

resetGameBoard()
{
	for((cell=1;cell<=9;cell++))
	do
		gameBoard[cell]=$cell
	done
}

#FUNCTION TO TOSS AND DECIDE WHO STARTS THE GAME

toss()
{

	toss=$((RANDOM%2))
	if [ $toss -eq $TOSS_USER ]
	then
		toss="USER"
		echo "			You Won the Toss to make first move"
	else
		toss="COMPUTER"
		echo "			Computer Won the Toss to make first move"
	fi
}

printf "\n		***** WELCOME TO TIC-TAC-TOE GAME SIMULATOR ***** \n\n\n "
resetGameBoard
toss

