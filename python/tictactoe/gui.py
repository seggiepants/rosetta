from functools import partial
import tkinter as tk
from tkinter import BooleanVar, StringVar, ttk, messagebox, font as tkFont
from board import *
from enum import Enum
import tictactoe
import settings

class PlayerType(Enum):
    Human = 0
    Computer = 1

class DifficultyLevel(Enum):
    Easy = 1
    Medium = 2
    Hard = 3

class Gui:
    def __init__(self):
        self.load_settings()
        self.root = self.init_gui()
        self.board = Board()
        self.board.new_game()
        self.is_playing = False
        
        self.play_game()

    def __del__(self):
        self.save_settings()

    def load_settings(self):
        (x, o, difficulty) = settings.load_settings()
        if x == 'Computer':
            x_player = PlayerType.Computer
        else: 
            x_player = PlayerType.Human

        if o == 'Computer':
            o_player = PlayerType.Computer
        else:
            o_player = PlayerType.Human

        if difficulty == 'Medium':
            self.difficulty = DifficultyLevel.Medium
        elif difficulty == 'Hard':
            self.difficulty = DifficultyLevel.Hard
        else:
            self.difficulty = DifficultyLevel.Easy

        self.playerType = {'X': x_player, 'O': o_player}
        
    
    def save_settings(self):
        if self.playerType['X'] == PlayerType.Computer:
            x_player = 'Computer'
        else:
            x_player = 'Human'
        
        if self.playerType['O'] == PlayerType.Computer:
            o_player = 'Computer'
        else:
            o_player = 'Human'

        if self.difficulty == DifficultyLevel.Medium:
            difficulty = 'Medium'
        elif self.difficulty  == DifficultyLevel.Hard:
            difficulty = 'Hard'
        else:
            difficulty = 'Easy'
        
        settings.save_settings(x_player, o_player, difficulty)

    def cell_click(self, col, row, args):
        if self.is_playing and self.playerType[self.player] == PlayerType.Human:
            current = self.board.get(col, row)
            if current == ' ':
                self.board.set(col, row, self.player)

                self.labels[row][col].set(self.player)

                self.next_turn()
    
    def play_game(self):
        # clear the gui
        for (i, j) in [(i, j) for i in range(3) for j in range(3)]:
            self.labels[j][i].set(' ')
        self.board.new_game()
        self.is_playing = True

        self.player = 'O'
        self.next_turn()
    
    def check_winner(self):
        # See if either side won
        # True - We have a winner / game over
        # False - Still playing

        winner = self.board.get_winner()
        if winner == WinState.X:
            messagebox.showinfo(title="X WINS", message="GAME OVER\nX Wins!")
        elif winner == WinState.O:
            messagebox.showinfo(title="O WINS", message="GAME OVER\nO Wins!")
        elif winner == WinState.DRAW:
            messagebox.showinfo(title="CATS EYE", message="GAME OVER\nNo winner.")

        return winner != WinState.NONE
    
    def swap_players(self):
        # Swap player turns
        if self.player == 'X':
            self.player = 'O'
        else:
            self.player = 'X'
    
    def next_turn(self):
        
        if self.check_winner():
            return

        self.swap_players()
        
        # Should the computer go next?
        while self.playerType[self.player] == PlayerType.Computer:
            (x, y) = tictactoe.get_move(self.board, self.player, self.difficulty.value)
            self.board.set(x, y, self.player)
            self.labels[y][x].set(self.player)

            if self.check_winner():
                break
            
            self.swap_players()


    def init_gui(self):
        root = tk.Tk()
        root.title('Tic Tac Toe')        
        root.resizable(False, False)
        
        self.labels = [[StringVar() for i in range(3)] for j in range(3)]

        # Menu
        menu = tk.Menu(root)
        root.configure(menu=menu)
        menuFile = tk.Menu(menu, tearoff=False)
        menuFile.add_command(label = 'New', command=self.show_new_dialog)
        menuFile.add_separator()
        menuFile.add_command(label = 'Exit', command=root.destroy)
        menu.add_cascade(label='File', menu=menuFile)

        self.easy = BooleanVar(master=root, value=self.difficulty == DifficultyLevel.Easy)
        self.medium = BooleanVar(master=root, value=self.difficulty == DifficultyLevel.Medium)
        self.hard = BooleanVar(master=root, value=self.difficulty == DifficultyLevel.Hard)

        menuDifficulty = tk.Menu(menu, tearoff=False)
        menuDifficulty.add_checkbutton(label='Easy', variable=self.easy, command=lambda : self.set_difficulty(DifficultyLevel.Easy))
        menuDifficulty.add_checkbutton(label='Medium', variable=self.medium, command=lambda : self.set_difficulty(DifficultyLevel.Medium))
        menuDifficulty.add_checkbutton(label='Hard', variable=self.hard, command=lambda : self.set_difficulty(DifficultyLevel.Hard))
        menu.add_cascade(label='Difficulty', menu=menuDifficulty)

        menuHelp = tk.Menu(menu, tearoff=False)
        menuHelp.add_command(label='About', command=self.show_about)
        menu.add_cascade(label='Help', menu=menuHelp)

        frameGame = tk.Frame(master = root)
        frameGame.columnconfigure(1, weight=1)
        frameGame.rowconfigure(1, weight=1)
        frameGame.grid(column = 0, row = 0)

        labelFont = tkFont.Font(size=20)
        for (i, j) in [(i, j) for i in range(3) for j in range(3)]:
            cell = tk.Label(master = frameGame, name = f"cell_{i}_{j}", textvariable=self.labels[j][i], font=labelFont, borderwidth=1, relief='raised', width=10, height=5)
            cell.columnconfigure(1, weight=1)
            cell.rowconfigure(1, weight=1)
            cell.bind('<Button-1>', partial(self.cell_click, i, j))
            cell.grid(column = i, row=j)
        return root
    
    def show_new_dialog(self):
        SelectPlayers(self.root, self)

    def show_about(self):
        AboutBox(self.root)

    def set_difficulty(self, difficulty):

        self.difficulty = difficulty
        if difficulty == DifficultyLevel.Easy:
            self.medium.set(False)
            self.hard.set(False)
            self.easy.set(True)
        elif difficulty == DifficultyLevel.Medium:
            self.easy.set(False)
            self.hard.set(False)
            self.medium.set(True)
        else: # difficulty == DifficultyLevel.Hard:
            self.easy.set(False)
            self.medium.set(False)
            self.hard.set(True)
        
class AboutBox(tk.Toplevel):
    def __init__(self, master, *args):
        tk.Toplevel.__init__(self, master, *args)
        self.title("About")
        self.resizable(False, False)
        padx = 10
        pady = 10
        lbl_application = ttk.Label(master=self, name='lbl_application', text='Tic Tac Toe')
        lbl_application.pack(padx=padx, pady=pady)

        lbl_copyright = ttk.Label(master=self, name='lbl_copyright', text="Copyright © 2025. All rights reserved")
        lbl_copyright.pack(padx=padx, pady=pady)

        lbl_description = ttk.Label(master=self, name='lbl_description', text='Play a game of Tic-Tac-Toe (or Noughts and Crosses if you prefer)\nagainst the Computer or another Player. The first one to get\nthree in a row horizontall, diagonally, or vertically wins.')
        lbl_description.pack(fill='x', padx=padx, pady=pady)

        cmd_ok = ttk.Button(master=self, name='cmd_ok', text='OK')
        cmd_ok.bind('<Button-1>', lambda event: self.destroy())
        cmd_ok.pack(padx=padx, pady=pady)

class SelectPlayers(tk.Toplevel):
    def __init__(self, master, parent, *args):
        self.parent = parent
        padx = 10
        pady = 10
        tk.Toplevel.__init__(self, master, *args)
        self.title("Select Players")
        self.resizable(False, False)
        lbl_instructions = ttk.Label(master = self, name = 'lbl_instructions',text='Choose Human or Computer for X and O.')
        lbl_instructions.grid(row = 1, column = 1, columnspan=2, ipadx=padx, ipady=pady)

        lbl_player_x = ttk.Label(master=self, name='lbl_player_x', text='X')
        frame_x = ttk.Frame(master=self, name='frame_x')
        if self.parent.playerType['X'] == PlayerType.Human:
            playerValue = 'Human'
        else:
            playerValue = 'Computer'

        self.player_x = StringVar(master=self, value=playerValue)
        rb_x_human = ttk.Radiobutton(master=frame_x, name='rb_x_human', text='Human', value='Human', variable=self.player_x)
        rb_x_computer = ttk.Radiobutton(master=frame_x, name='rb_x_computer', text='Computer', value='Computer', variable=self.player_x)
        lbl_player_x.grid(row=2, column=1, ipadx=padx, ipady=pady)
        frame_x.grid(row=3, column=1, rowspan=2)

        rb_x_human.pack(side=tk.TOP, ipadx=padx, ipady=pady, anchor=tk.W)
        rb_x_computer.pack(side=tk.TOP, ipadx=padx, ipady=pady, anchor=tk.W)

        lbl_player_o = ttk.Label(master=self, name='lbl_player_o', text='O')
        frame_o = ttk.Frame(master=self, name='frame_o')
        if self.parent.playerType['O'] == PlayerType.Human:
            playerValue = 'Human'
        else:
            playerValue = 'Computer'
        self.player_o = StringVar(master=self, value=playerValue)
        rb_o_human = ttk.Radiobutton(master=frame_o, text='Human', value='Human', variable=self.player_o)
        rb_o_computer = ttk.Radiobutton(master=frame_o, text='Computer', value='Computer', variable=self.player_o)

        lbl_player_o.grid(column=2, row=2, ipadx=padx, ipady=pady)
        rb_o_human.pack(side=tk.TOP, ipadx=padx, ipady=pady, anchor=tk.W)
        rb_o_computer.pack(side=tk.TOP, ipadx=padx, ipady=pady, anchor=tk.W)

        frame_o.grid(row=3, column=2, rowspan=2)

        if self.parent.playerType['X'] == PlayerType.Human:
            self.player_x.set('Human')
        else:
            self.player_x.set('Computer')

        if self.parent.playerType['O'] == PlayerType.Human:
            self.player_o.set('Human')
        else:
            self.player_o.set('Computer')
        
        frame_buttons = ttk.Frame(master=self, name='frame_buttons', padding='10p')
        cmd_ok = ttk.Button(master=frame_buttons, text='OK')
        cmd_ok.bind('<Button-1>', self.ok)

        cmd_cancel = ttk.Button(master=frame_buttons, text='Cancel')
        cmd_cancel.bind('<Button-1>', self.cancel)

        cmd_cancel.pack(side=tk.RIGHT, ipadx=padx, ipady=pady, padx=padx, pady=pady, anchor=tk.E)
        cmd_ok.pack(side=tk.RIGHT, ipadx=padx, ipady=pady, padx=padx, pady=pady, anchor=tk.E)

        frame_buttons.grid(row=5, column=1, columnspan=2)

        self.grab_set()
        self.mainloop()

    def ok(self, args):
        if self.player_x.get() == 'Human':
            x = PlayerType.Human
        else:
            x = PlayerType.Computer

        if self.player_o.get() == "Human":
            o = PlayerType.Human
        else:
            o = PlayerType.Computer
        self.parent.playerType['X'] = x
        self.parent.playerType['O'] = o
        self.parent.play_game()
        self.destroy()

    def cancel(self, args):
        self.destroy()