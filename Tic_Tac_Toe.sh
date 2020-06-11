
#CONSTANTS

TOSS_USER=1
COMPUTER_X=1
COMPUTER_WINS="computer"
USER_WINS="user"
IS_TIE="tie"
NUM_OF_CELLS=9
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
	for((cell=1;cell<=$NUM_OF_CELLS;cell++))
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
			for((cell=1;cell<=$NUM_OF_CELLS;cell++))
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
					echo "			CELL IS OCCUPIED, ENTER VALID CELL NUMBER"
					userChoice=0
				fi
		else
			echo "				INVALID INPUT PLEASE RE-ENTER VALID INPUT"
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
	playerSign=$1
	winnerSign=""
	cell=1
	while [[ "$winner" == "none" ]] && [ $cell -le $NUM_OF_CELLS ]
	do
		if [ $cell -eq 1 ]
		then
			if [[ "${gameBoard[1]}" == "$playerSign" ]] &&  [[ "${gameBoard[2]}" == "$playerSign" ]]  && [[ "${gameBoard[3]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign;
			elif [[ "${gameBoard[1]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[9]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign;
			elif [[ "${gameBoard[1]}" == "$playerSign" ]] && [[ "${gameBoard[4]}" == "$playerSign" ]] && [[ "${gameBoard[7]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign;
			fi
		elif [ $cell -eq  2 ]
		then
			if [[ "${gameBoard[2]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[8]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign
			fi
		elif [ $cell -eq  3 ]
		then
			if [[ "${gameBoard[3]}" == "$playerSign" ]] && [[ "${gameBoard[6]}" == "$playerSign" ]] && [[ "${gameBoard[9]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign
			elif [[ "${gameBoard[3]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[7]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign
			fi
		elif [ $cell -eq  4 ]
		then
			if [[ "${gameBoard[4]}" == "$playerSign" ]] && [[ "${gameBoard[5]}" == "$playerSign" ]] && [[ "${gameBoard[6]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign
			fi
		elif [ $cell -eq  7 ]
		then
			if [[ "${gameBoard[7]}" == "$playerSign" ]] && [[ "${gameBoard[8]}" == "$playerSign" ]] && [[ "${gameBoard[9]}" == "$playerSign" ]]
			then
				winnerSign=$playerSign
			fi
		fi
	((cell++))
	done
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
	
	for(( computerChoice=1;computerChoice<=NUM_OF_CELLS;computerChoice++))
	do
		for ((cellCount=1;cellCount<=$NUM_OF_CELLS;cellCount++))
		do
			if [ $cellCount -eq $computerChoice  ]
			then
				if [[ "${gameBoard[cellCount]}" != "$userSign" && "${gameBoard[cellCount]}" != "$computerSign"  ]]
				then
# CHECK IF MOVE GETS COMPUTER A WIN, IF SO THEN MAKE THE MOVE
					gameBoard[computerChoice]=$computerSign
					checkWinner $computerSign
					if [[ "$winner" == "$COMPUTER_WINS" ]]
					then
						winner="none"
						cellCount=10
						computerChoice=10
						((moveSuccessful++))
					else
						gameBoard[cellCount]=$cellCount
					fi
				fi
			fi
		done
	done
}

#FUNCTION FIND USER'S WINNING POSSIBILTY AND THEN BLOCK IT


userWinningMove()
{
	for(( computerChoice=1;computerChoice<=NUM_OF_CELLS;computerChoice++))
	do
		for ((cellCount=1;cellCount<=$NUM_OF_CELLS;cellCount++))
		do
			if [ $cellCount -eq $computerChoice  ]
			then
				if [[ "${gameBoard[cellCount]}" != "$userSign" && "${gameBoard[cellCount]}" != "$computerSign"  ]]
				then
# CHECK IF MOVE IN PRESENT CELL GETS USER A WIN, IF SO THEN BLOCK IT
					gameBoard[computerChoice]=$userSign
					checkWinner $userSign
					if [[ "$winner" == "$USER_WINS" ]]
						then
							winner="none"
							gameBoard[cellCount]=$computerSign
							cellCount=10
							computerChoice=10
							((moveSuccessful++))
					else
							gameBoard[cellCount]=$cellCount
					fi
				fi
			fi
		done
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

		for ((cell=1;cell<=$NUM_OF_CELLS;cell++))
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


printf "\n		***** WELCOME TO TIC-TAC-TOE GAME SIMULATOR ***** \n\n\n "
resetGameBoard
toss
signDecision
display

while [[ "$winner" == "none" ]] && [ $moveNumber -lt $NUM_OF_CELLS ]
do
	if [ $toss -eq $TOSS_USER ]
	then
		echo " "
		echo "				**Your Turn***"
		echo " "
		userChance
		display
		checkWinner $userSign
		((moveNumber++))
		if [[ "$winner" != "$USER_WINS" ]] &&  [ $moveNumber -lt $NUM_OF_CELLS ]
		then
			echo " "
			echo "				**Computer's Turn***"
			echo " "
			computerChance
			display
			checkWinner $computerSign
			((moveNumber++))
		fi
	else
		echo " "
		echo "				**Computer's Turn***"
		echo " "
		computerChance
		display
		checkWinner $computerSign
		((moveNumber++))
		if [[ "$winner" != "$COMPUTER_WINS" ]] && [ $moveNumber -lt $NUM_OF_CELLS ]
		then
			echo " "
			echo "				**Your Turn***"
			echo " "
			userChance
			display
			checkWinner $userSign
			((moveNumber++))
		fi
	fi
done

if [[ "$winner" == "$USER_WINS" ]]
then
	echo "					***YOU WON***"
elif	[[ "$winner" == "$COMPUTER_WINS" ]]
then
	echo "					***COMPUTER WON***"
else
	echo "					***IT'S A TIE ***"
fi


##########		END		##########
