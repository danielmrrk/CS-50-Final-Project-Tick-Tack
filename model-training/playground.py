import json
import copy
from main import check_win, decide_move, place_player_move, print_board, test_board, create_key, defended

with open('q_values.json', 'r') as json_file:
    q_values = json.load(json_file)

print(len(q_values))

while True:
    game_board = [[" ", " ", " "],
                           [" ", " ", " "],
                           [" ", " ", " "]]
    play_again = input("Do you want to play again? (yes/no): ")
    if play_again != "yes":
        print("See you next time.\n")
        break
    player_symbol = input("Do you want to be X or O?: ")
    if player_symbol != "X" and player_symbol != "O":
        raise NameError("Invalid player_symbol")
    player_moves = 0
    while player_moves != 9:
        beginning_board = copy.deepcopy(game_board)
        print_board(beginning_board)
        if player_symbol == "X":
            input_positions = input("Please choose an valid col, row: ")
            next_row, next_col = map(int, input_positions.split(","))
            print("\n\n")
            place_player_move(board=game_board, col=next_col, row=next_row, player_symbol=player_symbol)
            player_moves += 1
            if check_win(game_board, player_symbol):
                print("Congrats you won\n")
                break
            elif player_moves == 9:
                print("Draw.\n")
                break
            opponent_symbol = "O"
            next_row, next_col = decide_move(board=game_board, player_symbol=opponent_symbol, exploitation_rate=1.0,
                                             q_values=q_values)
            key = create_key(game_board, opponent_symbol)
            place_player_move(board=game_board, col=next_col, row=next_row, player_symbol=opponent_symbol)
            print(f"\n\nQ_value for decision: {q_values[key]}")
            player_moves += 1
            print_board(game_board)
            if check_win(game_board, opponent_symbol):
                break
        else:
            opponent_symbol = "X"
            next_row, next_col = decide_move(board=game_board, player_symbol=opponent_symbol, exploitation_rate=1.0,
                                             q_values=q_values)
            key = create_key(game_board, opponent_symbol)
            print(f"\n\nQ_value for decision: {q_values[key]}")
            place_player_move(board=game_board, col=next_col, row=next_row, player_symbol=opponent_symbol)
            print_board(game_board)
            player_moves += 1
            if check_win(game_board, opponent_symbol):
                print("You lost. :(\n")
                break
            elif player_moves == 9:
                print("Draw\n")
                break
            input_positions = input("Please choose an valid col, row: ")
            next_row, next_col = map(int, input_positions.split(","))
            print("\n\n")
            place_player_move(board=game_board, col=next_col, row=next_row, player_symbol=player_symbol)
            player_moves += 1
            if check_win(game_board, player_symbol):
                print("Congrats you won\n")
                break



