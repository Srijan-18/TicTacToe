
#CONSTANTS

TOSS_USER=1
COMPUTER_X=1
#VARIABLES

declare -a gameBoard
cell=0
toss=2
computerSign=""
userSign=""
userChoice=0
cellOccupied=0
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

echo "			Signs are :"
echo "			USER : $userSign"
echo "			COMPUTER : $computerSign"
}

#FUNCTION TO DISPLAY BOARD

display()
{
	echo " "
	echo "			     ****CURRENT BOARD STATUS****"
	echo " "
	echo "				||  ${gameBoard[1]}  ||  ${gameBoard[2]}  ||  ${gameBoard[3]}  ||"
	echo "				-----------------------"
	echo "				||  ${gameBoard[4]}  ||  ${gameBoard[5]}  ||  ${gameBoard[6]}  ||"
	echo "				-----------------------"
	echo "				||  ${gameBoard[7]}  ||  ${gameBoard[8]}  ||  ${gameBoard[9]}  ||"
	echo " "
}

#FUNCTION TO TAKE INPUT FROM USER

userChance()
{
	userChoice=0
	while [ $userChoice -eq 0 ]
	do
		read -p "			Enter the cell number to make a move :" userChoice
		if [[ $userChoice -gt 0 && $userChoice -lt 10 ]]
		then
			cellOccupied=0
			for((cell=1;cell<=9;cell++))
			do
				if [ $cell -eq $userChoice  ]
				then
					if [[ "${gameBoard[cell]}" == "X" || "${gameBoard[cell]}" == "O"  ]]
					then
					 ((cellOccupied++))
					else
						gameBoard[cell]=$userSign
					fi
				fi
			done
				if [ $cellOccupied -gt 0 ]
				then
					echo "			CELL IS OCCUPIED, ENTER VALID CELL NUMBER"
					userChoice=0
				fi
		else
			echo "				INVALID INPUT PLEASE RE-ENTER VALID INPUT"
			userChoice=0
		fi
	done
}
printf "\n		***** WELCOME TO TIC-TAC-TOE GAME SIMULATOR ***** \n\n\n "
resetGameBoard
toss
signDecision
display
userChance
