import random
from board import Board, WinState, MAX_VALUE
import gui

def alpha_beta(board, depth, alpha, beta, isMaximizer):
    if isMaximizer:
        player = 'X'
    else:
        player = 'O'
    winner = board.get_winner()
    if depth <= 0 or winner != WinState.NONE:
        return board.score(player)    

    if isMaximizer:
        value = -1 * MAX_VALUE
        for (i, j) in [(i, j) for i in range(3) for j in range(3)]:
            if board.get(i, j) == ' ':
                board.set(i, j, player)
                value = max(value, alpha_beta(board, depth - 1, alpha, beta, False))
                board.set(i, j, ' ')
                if value >= beta:
                    break
                alpha = max(alpha, value)
        return value
    else:
        value = MAX_VALUE
        for (i, j) in [(i, j) for i in range(3) for j in range(3)]:
            if board.get(i, j) == ' ':
                board.set(i, j, player)
                value = min(value, alpha_beta(board, depth - 1, alpha, beta, True))
                board.set(i, j, ' ')
                if value <= alpha:
                    break
                beta = min(beta, value)
        return value

# Based off wikipedia: https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning    
def get_move(board, player, depth):
    x = -1
    y = -1
    first = True
    alpha = -1 * MAX_VALUE
    beta = MAX_VALUE
    if player == 'X':
        best = alpha
    else:
        best = beta
    
    cells = [(i, j) for i in range(3) for j in range(3)]
    random.shuffle(cells)
    for (i, j) in cells:
        if board.get(i, j) == ' ':
            board.set(i, j, player)
            score = alpha_beta(board, depth, alpha, beta, player != 'X')
            #board.print()
            #print(f"score: {score}, player: {player}")
            board.set(i, j, ' ')
            if (player == 'X' and score > best) or (player == 'O' and score < best) or first:
                first = False
                best = score
                x = i
                y = j
    return (x, y)


def console_main():
    board = Board()
    winner = board.get_winner()
    player = 'O'
    #board.set(0, 0, 'O')
    #board.set(2, 0, 'X')
    #board.set(2, 2, 'X')
    #player = 'X'
    while winner == WinState.NONE:
        if player == 'X':
            player = 'O'
        else:
            player = 'X'
        (x, y) = get_move(board, player, 1)
        board.set(x, y, player)
        board.print()
        winner = board.get_winner()
        if winner == WinState.X:
            print("X WINS")
        elif winner == WinState.O:
            print("O WINS")
        elif winner == WinState.DRAW:
            print("CATS EYE")

def gui_main():
    ui = gui.Gui()
    root = ui.root
    root.mainloop()
    ui.save_settings()

if __name__ == '__main__':
    # console_main()
    gui_main()