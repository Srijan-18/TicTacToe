#CONSTANTS

TOSS_USER=1
COMPUTER_X=1
#VARIABLES

declare -a gameBoard
cell=0
toss=2
computerSign=""
userSign=""

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
		echo "			You Won the Toss to make first move"
	else
		echo "			Computer Won the Toss to make first move"
	fi
}

#FUNCTION TO DECIDE SIGN OF USER AND COMPUTER

signDecision()
{
	if [ $toss -eq $TOSS_USER ]
	then
		while [[ "$userSign" == "" ]]
		do
			echo""
			read -p "			Enter your choice of 'X' or 'O' (both are alphabets): " userSign
			if [[ "$userSign" == "O" || "$userSign" == "o" ]]
			then
				userSign="O"
				computerSign="X"
			elif [[ "$userSign" == "X" || "$userSign" == "x" ]]
			then
				userSign="X"
				computerSign="O"
			else
				echo""
				echo "			INVALID INPUT PLEASE ENTER EITHER OF TWO OPTIONS"
				userSign=""
			fi
		done
	else
		computerSign=$((RANDOM%2))
		if (( computerSign=COMPUTER_X ))
		then
			computerSign="X"
			userSign="O"
		else
			computerSign="O"
			userSign="X"
		fi
	fi
echo "			USER : $userSign"
echo "			COMPUTER : $computerSign"
}

printf "\n		***** WELCOME TO TIC-TAC-TOE GAME SIMULATOR ***** \n\n\n "
resetGameBoard
toss
signDecision
