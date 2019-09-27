from random import randint
from math import sqrt

CONSOLE_W = 80
GRID_W = 10
GRID_H = GRID_W
MAX_TURNS = 10
NUM_MUGWUMPS = 4

def center_print(message):
    x = (CONSOLE_W - len(message)) // 2 # // does integer division
    print(' ' * x + message)

def init_mugwumps(mugwumps):
    for mugwump in mugwumps:
        mugwump['x'] = randint(0, GRID_W - 1)
        mugwump['y'] = randint(0, GRID_H - 1)
        mugwump['found'] = False

def pretty_print(left, message):
    for word in message.split(): # default is to split on whitespace
        if left > 0 and left < CONSOLE_W:
            print(' ', end='')
            left += 1
        
        if left + len(word) > CONSOLE_W:
            print()
            left = 0

        print(word, end='')
        left = left + len(word)

    return left

def print_introduction():
    center_print('MUGWUMP')
    center_print('CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY')
    print()
    print()
    print()
    # Courtesy People's Computer Company
    left = 0
    left = pretty_print(left, 'The object of this game is to find four mugwumps')
    left = pretty_print(left, 'hidden on a 10 by 10 grid. Home base is position 0, 0')
    left = pretty_print(left, 'any guess you make must be two numbers with each')
    left = pretty_print(left, 'number between 0 and 9, inclusive. First number')
    left = pretty_print(left, 'is distance to the right of home base, and second number')
    left = pretty_print(left, 'is distance above home base.')
    print()
    print()
    left = 0
    left = pretty_print(left, 'You get 10 tries. After each try, I will tell')
    left = pretty_print(left, 'you how far you are from each mugwump.')
    print()
    print()

if __name__ == '__main__':
    print_introduction()
    mugwumps = [{'x': 0, 'y': 0, 'found': False} for i in range(NUM_MUGWUMPS)]

    while True: # Loop once for each time you play the game
        turn = 0
        init_mugwumps(mugwumps)
        while True: # Loop once for each turn in a game
            turn = turn + 1
            print()
            print()
            x = -1
            y = -1
            while x < 0 or x >= GRID_W or y < 0 or y >= GRID_H:
                line = input(f'Turn No. {turn}, what is your guess? ')
                try:
                    position = [int(token) for token in line.split(',')]
                    if len(position) >= 2:
                        x = position[0]
                        y = position[1]
                except:
                    x = -1
                    y = -1
                
            for i, mugwump in enumerate(mugwumps):
                if not mugwump['found']:
                    if mugwump['x'] != x or mugwump['y'] != y:
                        distance = sqrt((mugwump['x'] - x) ** 2 + (mugwump['y'] - y) ** 2)
                        print(f'You are {round(distance, 2)} units from mugwump {i + 1}')
                    else:
                        mugwump['found'] = True
                        print(f'YOU HAVE FOUND MUGWUMP {i + 1}')
            
            remaining = sum([1 for mugwump in mugwumps if not mugwump['found']])
            if remaining == 0:
                print(f'YOU GOT THEM ALL IN {turn} TURNS!')
                break
            elif turn >= MAX_TURNS:
                print()
                print(f'Sorry, that\'s {turn} tries. Here is where they\'re hiding.')
                for i, mugwump in enumerate(mugwumps):
                    if not mugwump['found']:
                        print(f'Mugwump {i + 1} is at ({mugwump["x"]}, {mugwump["y"]})')
                
                break
            
        print ('THAT WAS FUN!')
        line = ''
        while len(line) == 0 or (line[0] != 'Y' and line[0] !='N'):
            line = input('Would you like to play again (Y/N)? ').strip().upper()

        if line[0] == 'N':
            break