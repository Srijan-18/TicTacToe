#VARIABLES


declare -a gameBoard
cell=0

#FUNCTION TO RESET GAME BOARD WITH RESPECTIVE CELL NUMBERS

resetGameBoard()
{
	for((cell=1;cell<=9;cell++))
	do
		gameBoard[cell]=$cell
	done
}

printf "\n		****** WELCOME TO TIC-TAC-TOE GAME SIMULATOR ***** \n\n\n "
resetGameBoard

