import numpy as np
import json
import copy

WIN = 10
LOOSE = -2
STEP = -0.1
DRAW = 0
ILLEGAL_CELL = -1000


def place_player_move(board: list, col: int, row: int, player_symbol: str):
    board[row][col] = player_symbol


def check_win(board: list, player_symbol: str):
    for row in board:
        if all(cell == player_symbol for cell in row):
            return True
    for col in range(3):
        if all(row[col] == player_symbol for row in board):
            return True
    if all(board[i][i] == player_symbol for i in range(3)) or all(board[2 - j][j] == player_symbol for j in range(3)):
        return True
    return False


def print_board(board: list):
    for index, row in enumerate(board):
        print(" | ".join(row))
        if index != 2:
            print("-" * 9)


def get_random_move(board: list):
    row = np.random.randint(0, 3)
    col = np.random.randint(0, 3)
    while not code_valid(board, col, row):
        row = np.random.randint(0, 3)
        col = np.random.randint(0, 3)
    return row, col


def create_key(board: list, player_symbol: str):
    return f"{board}/{player_symbol}"


def decide_move(board: list, player_symbol: str, exploitation_rate: float, q_values: dict):
    key = create_key(board, player_symbol)
    try:
        if np.random.random() < exploitation_rate:
            max_index = np.argmax(q_values[key])
            row, col = np.unravel_index(max_index, (3, 3))
        else:
            row, col = get_random_move(board=board)
    except KeyError:
        q_values[key] = np.array(
            [[ILLEGAL_CELL if board[i][j] != " " else 0 for j in range(3)] for i in range(3)], dtype=float)
        row, col = get_random_move(board=board)
    return row, col


def code_valid(board: list, col: int, row: int):
    return board[row][col] == " "

def change_player_turn(player_symbol: str):
    if player_symbol == "X":
        return "O"
    else:
        return "X"


def determine_reward(next_row: int, next_col: int, origin_board: list, next_board_position: list,
                     player_symbol: str, moves: int):
    has_won = check_win(next_board_position, player_symbol)
    latest_move = (next_row, next_col)
    if has_won:
        return WIN
    elif moves == 9:
        return DRAW
    elif defended(origin_board=origin_board, next_board=next_board_position, player_symbol=player_symbol):
        return +0.1
    elif latest_move == (1, 1):
        return +0.05
    elif latest_move == (0, 0) or latest_move == (2, 2) or latest_move == (2, 0) or latest_move == (0, 2):
        return +0.02
    return STEP


def defended(origin_board: list, next_board: list, player_symbol: str):
    if maybe_opponent_win(origin_board, player_symbol) and not maybe_opponent_win(next_board, player_symbol):
        return True
    return False


def maybe_player_win(origin_board_position: list, player_symbol: str):
    board_copy = copy.deepcopy(origin_board_position)
    for row_idx, row in enumerate(board_copy):
        for col_idx in range(3):
            if row[col_idx] == " ":
                board_copy[row_idx][col_idx] = player_symbol
                # check if player could have won
                if check_win(board_copy, player_symbol):
                    return True
                # reset
                board_copy[row_idx][col_idx] = " "
    return False


# board needs to be a copy!!!
def maybe_opponent_win(board: list, player_symbol: str):
    board_copy = copy.deepcopy(board)
    if player_symbol == "X":
        opponent_symbol = "O"
    else:
        opponent_symbol = "X"
    for row_idx, row in enumerate(board_copy):
        for col_idx in range(3):
            if row[col_idx] == " ":
                board_copy[row_idx][col_idx] = opponent_symbol
                # check if opponent won
                if check_win(board_copy, opponent_symbol):
                    return True
                # reset
                board_copy[row_idx][col_idx] = " "
    return False


# calculates the max_q_value after the "best" move from the opponent
def calculate_max_q_value(potential_board: list, player_symbol: str, q_values: dict):
    potential_key = create_key(potential_board, player_symbol)
    try:
        max_index = np.argmax(q_values[potential_key])
        row, col = np.unravel_index(max_index, (3, 3))
        max_value = q_values[potential_key][row][col]
        # no other moves
        if max_value == ILLEGAL_CELL:
            if check_win(potential_board, player_symbol):
                return WIN
            else:
                return DRAW

    except KeyError:
        q_values[potential_key] = np.array(
            [[ILLEGAL_CELL if potential_board[i][j] != " " else 0 for j in range(3)] for i in range(3)], dtype=float)
        max_value = 0
    return max_value


def convert_numpy_arrays_to_lists(obj):
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    elif isinstance(obj, dict):
        return {key: convert_numpy_arrays_to_lists(value) for key, value in obj.items()}
    elif isinstance(obj, list):
        return [convert_numpy_arrays_to_lists(item) for item in obj]
    else:
        return obj


def test_board(board: list, player_symbol: str, q_values: dict):
    copy_board = copy.deepcopy(board)
    print_board(board)
    row, col = decide_move(board=board, player_symbol=player_symbol, exploitation_rate=1, q_values=q_values)
    place_player_move(board=board, player_symbol=player_symbol, col=col, row=row)
    key = create_key(copy_board, player_symbol)
    print(f"q_values: {q_values[key]}")
    print_board(board)
    print("\n\n")


def memory_opponent_position(board: list, player_moves: int, row: int, col: int, moves_list: list, state_list: list):
    copy_board = copy.deepcopy(board)
    if player_moves >= 1:
        moves_list.append((row, col))
        state_list.append(copy_board)
    if player_moves >= 4:
        moves_list.pop(0)
        state_list.pop(0)

# with open('q_values.json', 'r') as json_file:
#     q_values = json.load(json_file)

q_values = {}

if __name__ == "__main__":

    GAMMA = 0.9
    ALPHA = 0.1
    EXPLOITATION_RATE = 0.5
    STEPS = 200000
    exploitation_growth = 0.3 / STEPS

    for step in range(STEPS):
        if step % 10000 == 0:
            print(f"step: {step}")
        game_board = [[" " for _ in range(3)] for _ in range(3)]
        player_moves = 0
        player_symbol = "X"
        EXPLOITATION_RATE += exploitation_growth

        moves_list = []
        state_list = []
        # test if it could be replaced with while true, should work !!!
        while True:
            beginning_board = copy.deepcopy(game_board)

            # game board gets automatically updated
            next_row, next_col = decide_move(board=game_board, player_symbol=player_symbol,
                                             exploitation_rate=EXPLOITATION_RATE, q_values=q_values)
            place_player_move(board=game_board, col=next_col, row=next_row, player_symbol=player_symbol)
            player_moves += 1
            reward = determine_reward(origin_board=beginning_board, next_row=next_row, next_col=next_col, next_board_position=game_board,
                                      player_symbol=player_symbol, moves=player_moves)

            key = create_key(beginning_board, player_symbol)
            opponent_symbol = change_player_turn(player_symbol)
            memory_opponent_position(board=game_board, player_moves=player_moves, moves_list=moves_list,
                                     state_list=state_list, row=next_row, col=next_col)
            next_opponent_key = create_key(game_board, opponent_symbol)
            has_won = check_win(game_board, player_symbol)
            if player_moves == 9 or has_won:
                opponent_row, opponent_col = moves_list[1]
                opponent_before_losing_move_key = create_key(state_list[0], opponent_symbol)
                if has_won:
                    q_values[opponent_before_losing_move_key][opponent_row][opponent_col] \
                        += ALPHA * (LOOSE - q_values[opponent_before_losing_move_key][opponent_row][opponent_col])
                q_values[key][next_row][next_col] += ALPHA * (reward - q_values[key][next_row][next_col])
                break

            potential_opponent_col = None
            potential_opponent_row = None
            try:
                # I only care about the move
                max_index = np.argmax(q_values[next_opponent_key])
                potential_opponent_row, potential_opponent_col = np.unravel_index(max_index, (3, 3))
            except KeyError:
                # sure -1000 might work but is not safe
                q_values[next_opponent_key] = np.array(
                    [[ILLEGAL_CELL if game_board[i][j] != " " else 0 for j in range(3)] for i in range(3)], dtype=float)
                potential_opponent_row, potential_opponent_col = get_random_move(game_board)
            finally:
                potential_game_board = copy.deepcopy(game_board)
                if potential_opponent_col is None or potential_opponent_row is None:
                    raise NameError("Failed to define correctly. Error not expected")
                # check here if the other player is winning
                place_player_move(board=potential_game_board, row=potential_opponent_row, col=potential_opponent_col,
                                  player_symbol=opponent_symbol)
                if check_win(potential_game_board, opponent_symbol):
                    max_next_q_value = LOOSE
                else:
                    max_next_q_value = calculate_max_q_value(potential_game_board, player_symbol, q_values)
                try:
                    old_q_value = q_values[key][next_row][next_col]
                except KeyError:
                    q_values[key] = np.array(
                        [[ILLEGAL_CELL if beginning_board[i][j] != " " else 0 for j in range(3)] for i in range(3)],
                        dtype=float)
                    old_q_value = 0
            temporal_difference = (reward + GAMMA * max_next_q_value) - old_q_value
            q_values[key][next_row][next_col] += ALPHA * temporal_difference

            player_symbol = change_player_turn(player_symbol=player_symbol)

    # tests:

    # check if correct

    test_example = [["X", " ", "O"],
                             [" ", "O", " "],
                             [" ", " ", "X"]]
    second_example = [["X", "O", " "],
                               ["X", "O", " "],
                               [" ", " ", " "]]
    third_example = [[" ", " ", "O"],
                              [" ", "X", " "],
                              ["X", " ", " "]]
    fourth_example = [[" ", " ", " "],
                               [" ", "X", " "],
                               [" ", " ", " "]]
    fifth_exmaple = [["X", " ", " "],
                              [" ", " ", " "],
                              ["O", " ", " "]]
    six_example = [["O", " ", "X"],
                            ["X", "X", " "],
                            ["O", " ", " "]]

    test_board(test_example, "X", q_values)
    test_board(second_example, "X", q_values)
    test_board(third_example, "O", q_values)
    test_board(fourth_example, "O", q_values)
    test_board(fifth_exmaple, "X", q_values)
    test_board(six_example, "O", q_values)

    input_save = input("Do you want to save these q_values?, (yes, Yes, y): ")

    # saving q_values as json
    if input_save == "yes" or input_save == "Yes" or input_save[0] == 'y':
        converted_q_values = convert_numpy_arrays_to_lists(q_values)
        with open("q_values.json", "w") as json_file:
            json.dump(converted_q_values, json_file)
