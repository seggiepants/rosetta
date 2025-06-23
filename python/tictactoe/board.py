import sys
import random
from enum import Enum

MAX_VALUE = 10000

class WinState(Enum):
    NONE = 0
    X = 1
    O = 2
    DRAW = 3

class Board:
    def __init__(self):
        # 2D 3x3 board populated with a space character
        self.board = [[' ' for i in range(3)] for j in range(3)]
        self.state = WinState.NONE

    def print(self):
        first = True
        for row in self.board:
            if first:
                first = False
            else:
                print("---+---+---")

            print(f" {row[0]} | {row[1]} | {row[2]} ")        
        print()

    def new_game(self):
        for (i, j) in [(i, j) for i in range(3) for j in range(3)]:
            self.board[j][i] = ' '
        self.state = WinState.NONE

    def get(self, x, y):
        return self.board[y][x]
    
    def set(self, x, y, value):
        self.board[y][x] = value

    def get_winner(self):
        winner = WinState.NONE
        for i in range(3):
            col = ''.join([self.get(0, i), self.get(1, i), self.get(2, i)])
            row = ''.join([self.get(i, 0), self.get(i, 1), self.get(i, 2)])

            if col == 'XXX' or row == 'XXX':
                winner = WinState.X
                break

            if col == 'OOO' or row == 'OOO':
                winner = WinState.O
                break

        if winner == WinState.NONE:
            diagonal1 = ''.join([self.get(0, 0), self.get(1, 1), self.get(2, 2)])
            diagonal2 = ''.join([self.get(2, 0), self.get(1, 1), self.get(0, 2)])

            if diagonal1 == 'XXX' or diagonal2 == 'XXX':
                winner = WinState.X

            if diagonal1 == 'OOO' or diagonal2 == 'OOO':
                winner = WinState.O
        
        if winner == WinState.NONE:
            winner = WinState.DRAW
            for j in range(3):
                for i in range(3):
                    if self.get(i, j) == ' ':
                        winner = WinState.NONE
                        break
        
        return winner
    
    def copy(self):
        ret = Board()
        for j in range(3):
            for i in range(3):
                ret.set(i, j, self.get(i, j))
        return ret
    
    def score(self, player):
        ret = 0
        enemy_wins = 0
        enemy_blocks = 0

        position_values = [[2, 1, 2], [1, 4, 1], [2, 1, 2]]

        triplets = [((0, 0), (1, 0), (2, 0)), ((0, 1), (1, 1), (2, 1)), ((0, 2), (1, 2), (2, 2)),
                    ((0, 0), (0, 1), (0, 2)), ((1, 0), (1, 1), (1, 2)), ((2, 0), (2, 1), (2, 2)),
                    ((0, 0), (1, 1), (2, 2)), ((2, 0), (1, 1), (0, 2))]
        
        status = self.get_winner()

        if status == WinState.X:
            return MAX_VALUE
        elif status == WinState.O:
            return -1 * MAX_VALUE
        elif status == WinState.DRAW:
            return 0
        
        ret = 0
        for j in range(3):
            for i in range(3):
                current = self.get(i, j)
                if current == 'X':
                    ret += position_values[j][i]
                elif current == 'O':
                    ret -= position_values[j][i]
                else:
                    self.set(i, j, 'X')
                    winX = self.get_winner()
                    self.set(i, j, 'O')
                    winO = self.get_winner()
                    self.set(i, j, ' ')
                    if player == 'X':
                        if winO == WinState.O:
                            enemy_wins += 1
                        elif winX == WinState.X:
                            enemy_blocks += 1
                    else:
                        if winX == WinState.X:
                            enemy_wins += 1
                        elif winO == WinState.O:
                            enemy_blocks += 1
        
        if player == 'X':
            multiplier = -1 # O plays next
        else:
            multiplier = 1

        if enemy_wins > 0 or enemy_blocks > 0:
            return multiplier * ((enemy_wins * (MAX_VALUE / 10)) + (enemy_blocks * (MAX_VALUE / 20))) + ret
        
        return ret

    
     
