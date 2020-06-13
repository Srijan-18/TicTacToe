#CONSTANTS

TOSS_USER=1
COMPUTER_X=1
COMPUTER_WINS="computer"
USER_WINS="user"
IS_TIE="tie"
NUM_OF_ROWS=3
NUM_OF_COLUMNS=3
CENTER=5

#VARIABLES

declare -a gameBoard
cell=0
toss=2
computerSign=""
userSign=""
userChoice=0
computerChoice=0
cellOccupied=0
winner="none"
moveNumber=0

#FUNCTION TO RESET GAME BOARD WITH RESPECTIVE CELL NUMBERS

resetGameBoard()
{
	for((cell=1;cell<=NUM_OF_ROWS*NUM_OF_COLUMNS;cell++))
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
		printf "\t\t\tYou Won the Toss to make first move\n\n"
	else
		printf "\t\t\tComputer Won the Toss to make first move\n"
	fi
}

#FUNCTION TO DECIDE SIGN OF USER AND COMPUTER

signDecision()
{
	if [ $toss -eq $TOSS_USER ]
	then
		while [[ "$userSign" == "" ]]
		do
			printf "\n"
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
				printf "\n\t\t\tINVALID INPUT PLEASE ENTER EITHER OF TWO OPTIONS\n"
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

	printf "\t\t\tSigns are :\n\t\t\tUSER --> $userSign\n\t\t\tCOMPUTER --> $computerSign"
}

#FUNCTION TO DISPLAY BOARD

display()
{
	printf "\n\t\t\t\t****CURRENT BOARD STATUS****\n\n"
	printf "\t\t\t\t||  ${gameBoard[1]}  ||  ${gameBoard[2]}  ||  ${gameBoard[3]}  ||\n"
	printf "\t\t\t\t-----------------------\n"
	printf "\t\t\t\t||  ${gameBoard[4]}  ||  ${gameBoard[5]}  ||  ${gameBoard[6]}  ||\n"
	printf "\t\t\t\t-----------------------\n"
	printf "\t\t\t\t||  ${gameBoard[7]}  ||  ${gameBoard[8]}  ||  ${gameBoard[9]}  ||\n\n"
}

#FUNCTION TO TAKE INPUT FROM USER

userChance()
{
	userChoice=0
	while [ $userChoice -eq 0 ]
	do
		printf "\n"
		read -p "			Enter the cell number to make a move :" userChoice
		if [[ $userChoice -gt 0 && $userChoice -lt 10 ]]
		then
			cellOccupied=0
			for((cell=1;cell<=NUM_OF_ROWS*NUM_OF_COLUMNS;cell++))
			do
				if [ $cell -eq $userChoice  ]
				then
					if [[ "${gameBoard[cell]}" == "$userSign" || "${gameBoard[cell]}" == "$computerSign"  ]]
					then
					 ((cellOccupied++))
					else
						gameBoard[cell]=$userSign
					fi
				fi
			done
				if [ $cellOccupied -gt 0 ]
				then
					printf "\t\t\tCELL IS OCCUPIED, ENTER VALID CELL NUMBER\n"
					userChoice=0
				fi
		else
			printf "\t\t\tINVALID INPUT PLEASE RE-ENTER VALID INPUT\n"
			userChoice=0
		fi
	done
}

# FUNCTION TO GENERATE COMPUTER'S MOVE

computerChance()
{
	moveSuccessful=0
	computerWinningMove
	if [ $moveSuccessful -eq 0 ]
	then
		userWinningMove
	fi
	if [ $moveSuccessful -eq 0 ]
	then
		selectCorners
	fi
	if [ $moveSuccessful -eq 0 ]
	then
		selectCenter
	fi
	if [ $moveSuccessful -eq 0 ]
	then
		selectRandom
	fi
}

# FUNCTION TO DETERMINE WINNER

checkWinner()
{
	winnerDecision=0
	playerSign=$1
	winnerSign=""

# CHECK FOR ROWS

for (( cell=1;cell<=NUM_OF_ROWS*NUM_OF_COLUMNS ; cell+=NUM_OF_ROWS))
do
	if [ $winnerDecision -eq 0  ]
	then
		if [[ "${gameBoard[cell]}" == "$playerSign" && "${gameBoard[((cell+1))]}" == "$playerSign" && "${gameBoard[((cell+2))]}" == "$playerSign" ]]
		then
			winnerSign=$playerSign
			((winnerDecision++))
			break
		fi
	fi
done

# CHECK FOR COLUMNS

for ((cell=1;cell<=$NUM_OF_COLUMNS;cell++))
do
	if [ $winnerDecision -eq 0  ]
	then
		if [[ "${gameBoard[cell]}" == "$playerSign" && "${gameBoard[((cell+NUM_OF_COLUMNS))]}" == "$playerSign" && "${gameBoard[((cell+(2*NUM_OF_COLUMNS)))]}" == "$playerSign" ]]
		then
			winnerSign=$playerSign
			((winnerDecision++))
			break
		fi
	fi
done

# CHECK FOR DIAGONALS

if [[ $winnerDecision -eq 0  ]] && [[ "${gameBoard[1]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[9]}" == "$playerSign" ]]
then
	winnerSign=$playerSign;
	((winnerDesicion++))
elif [[ $winnerDecision -eq 0  ]] && [[ "${gameBoard[3]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[7]}" == "$playerSign" ]]
then
	winnerSign=$playerSign;
	((winnerDesicion++))
fi
	if [[ "$winnerSign" == "$userSign" ]]
	then
		winner=$USER_WINS
	elif [[ "$winnerSign" == "$computerSign" ]]
	then
		winner=$COMPUTER_WINS
	fi
}

#FUNCTION TO CHECK POSSIBILITY OF A MOVE THAT CAN MAKE COMPUTER WIN

computerWinningMove()
{
	for ((cellCount=1;cellCount<=NUM_OF_ROWS*NUM_OF_COLUMNS;cellCount++))
	do
		if [[ "${gameBoard[cellCount]}" != "$userSign" && "${gameBoard[cellCount]}" != "$computerSign"  ]]
		then
# CHECK IF MOVE GETS COMPUTER A WIN, IF SO THEN MAKE THE MOVE
			gameBoard[cellCount]=$computerSign
			checkWinner $computerSign
			if [[ "$winner" == "$COMPUTER_WINS" ]]
			then
				winner="none"
				cellCount=10
				((moveSuccessful++))
				else
				gameBoard[cellCount]=$cellCount
			fi
		fi
	done
}

#FUNCTION FIND USER'S WINNING POSSIBILTY AND THEN BLOCK IT


userWinningMove()
{
	for ((cellCount=1;cellCount<=NUM_OF_ROWS*NUM_OF_COLUMNS;cellCount++))
	do
		if [[ "${gameBoard[cellCount]}" != "$userSign" && "${gameBoard[cellCount]}" != "$computerSign"  ]]
		then
# CHECK IF MOVE IN PRESENT CELL GETS USER A WIN, IF SO THEN BLOCK IT
			gameBoard[cellCount]=$userSign
			checkWinner $userSign
			if [[ "$winner" == "$USER_WINS" ]]
			then
				winner="none"
				gameBoard[cellCount]=$computerSign
				cellCount=10
				((moveSuccessful++))
			else
				gameBoard[cellCount]=$cellCount
			fi
		fi
	done
}

#FUNCTION TO CHECK AND SELECT CORNERS IF AVAILABLE

selectCorners()
{
	for cell in 1 3 7 9
	do
		if [[ "${gameBoard[cell]}" != "$userSign" && "${gameBoard[cell]}" != "$computerSign"  ]]
		then
			gameBoard[cell]=$computerSign
			((moveSuccessful++))
			break
		fi
	done

}

# FUNCTION TO SELECT CENTER

selectCenter()
{

	if [[ "${gameBoard[$CENTER]}" != "$userSign" && "${gameBoard[CENTER]}" != "$computerSign"  ]]
	then
		gameBoard[$CENTER]=$computerSign
		((moveSuccessful++))
	fi
}

# FUNCTION TO SELECT RANDOM CELLS OUT OF AVAILABLE CELLS

selectRandom()
{
	computerChoice=0
	cell=1
	while [ $computerChoice -eq 0 ]
	do
		computerChoice=$((RANDOM%9 + 1))

		for ((cell=1;cell<=NUM_OF_ROWS*NUM_OF_COLUMNS;cell++))
		do
			if [ $cell -eq $computerChoice  ]
			then
				if [[ "${gameBoard[cell]}" != "$userSign" && "${gameBoard[cell]}" != "$computerSign"  ]]
				then
					gameBoard[cell]=$computerSign
					cell=10
				else
					computerChoice=0
				fi
			fi
		done
	done
}


#*************************        MAIN			*************************


printf "\n\t\t\t***** WELCOME TO TIC-TAC-TOE GAME SIMULATOR *****\n\n\n "
resetGameBoard
toss
signDecision
display

while [[ "$winner" == "none" ]] && [ $moveNumber -lt $((NUM_OF_ROWS*NUM_OF_COLUMNS)) ]
do
	if [ $toss -eq $TOSS_USER ]
	then
		printf "\n\t\t\t\t***Your Turn***\n"
		userChance
		display
		checkWinner $userSign
		((moveNumber++))
		if [[ "$winner" != "$USER_WINS" ]] &&  [ $moveNumber -lt $((NUM_OF_ROWS*NUM_OF_COLUMNS)) ]
		then
			printf "\n\t\t\t\t**Computer's Turn***\n"
			computerChance
			display
			checkWinner $computerSign
			((moveNumber++))
		fi
	else
		printf "\n\t\t\t\t***Computer's Turn***\n"
		computerChance
		display
		checkWinner $computerSign
		((moveNumber++))
		if [[ "$winner" != "$COMPUTER_WINS" ]] && [ $moveNumber -lt $((NUM_OF_ROWS*NUM_OF_COLUMNS)) ]
		then
			printf "\n\t\t\t\t***Your Turn***\n"
			userChance
			display
			checkWinner $userSign
			((moveNumber++))
		fi
	fi
done

if [[ "$winner" == "$USER_WINS" ]]
then
	printf "\n\t\t\t\t\t***YOU WON***\n\n"
elif	[[ "$winner" == "$COMPUTER_WINS" ]]
then
	printf "\n\t\t\t\t\t***COMPUTER WON***\n\n"
else
	printf "\n\t\t\t\t\t***IT'S A TIE ***\n\n"
fi


##########		END		##########
