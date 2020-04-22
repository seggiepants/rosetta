/*
 MUGWUMP 2D
 ----------
 A graphical version of MUGWUMP from BASIC COMPUTER GAMES
 by Bob Albrecht, Bud Valenti, Edited by David H. Ahl
 ported by SeggiePants
*/

// Game default settings.
settings = {
    GAME_TITLE: 'MUGWUMP 2D'
    , COUNT_MUGWUMPS: 4
    , MAX_GUESSES: 10
    , GRID_W: 10
    , GRID_H: 10
};

// Colors
BLACK = 'rgb(0, 0, 0)';
DARK_GRAY = 'rgb(64, 64, 64)';
LIGHT_BLUE = 'rgb(128, 128, 255)';
LIGHT_GRAY = 'rgb(192, 192, 192)';
ORANGE = 'rgb(255, 128, 0)';
PINK = 'rgb(255, 0, 128)';
RED = 'rgb(255, 0, 0)';
TEAL = 'rgb(12, 140, 127)';
VIOLET = 'rgb(192, 0, 255)';
WHITE = 'rgb(255, 255, 255)';

// Mugwump body colors
bodyColors = [PINK, VIOLET, LIGHT_BLUE, ORANGE];

var mugwumps = [];
var guesses = [];

// Add a mugwump to a cell on the grid.
function appendMugwump(parentId, bodyColor, eyeColor, pupilColor, mouthColor) {
    var parent = document.getElementById(parentId);
    var body = document.createElement('div');
    var eyeLeft = document.createElement('div');
    var eyeRight = document.createElement('div');
    var pupilLeft = document.createElement('div');
    var pupilRight = document.createElement('div');
    var mouth = document.createElement('div');

    body.className = 'mugwump_body';
    eyeLeft.className = 'mugwump_eye eye_left';
    eyeRight.className = 'mugwump_eye eye_right';
    pupilLeft.className = 'mugwump_pupil pupil';
    pupilRight.className = 'mugwump_pupil pupil';
    mouth.className = 'mugwump_mouth';

    body.style.backgroundColor = bodyColor;
    eyeLeft.style.backgroundColor = eyeColor;
    eyeRight.style.backgroundColor = eyeColor;
    pupilLeft.style.backgroundColor = pupilColor;
    pupilRight.style.backgroundColor = pupilColor;
    mouth.style.backgroundColor = mouthColor;

    body.appendChild(eyeLeft);
    eyeLeft.appendChild(pupilLeft);
    body.appendChild(eyeRight);
    eyeRight.appendChild(pupilRight);
    body.appendChild(mouth);
    parent.appendChild(body);

    return(body);
}

// build the console that shows how far you are from each mugwump
function buildConsole(parentId) {
    var parent;
    parent = document.getElementById(parentId);
    removeChildren(parent);
    if (guesses.length == 0) {
        // Draw the help text
        var infoText;

        var messages = [
            'Select a square to scan for a Mugwump'
          , 'Use the arrow keys to move.'
          , 'Space bar will select a square.'
          , 'You can also use the mouse'
          , 'Press the Escape key to restart the game.'
        ];

        for(var i = 0; i < messages.length; i++) {
            infoText = document.createElement('div');
            infoText.innerText = messages[i].toString();
            infoText.id = 'info_' + i.toString();
            infoText.className = 'info_line';
            parent.appendChild(infoText);
        }
    } else {
        // Draw the distance lines
        var remaining, row, row_num, row_dist;
        var mugwump_body;        
        var dist, dx, dy;
        for(var i = 0; i < mugwumps.length; i++) {
            row = document.createElement('div');            
            row.id = 'info_' + i.toString();
            parent.appendChild(row);
            row_num = document.createElement('span');
            row_num.innerText = '#' + (i + 1).toString() + ' ';
            row_num.style.paddingRight = '0.5rem';
            row_num.className = 'info_line';
            row.appendChild(row_num);
            mugwump_body = appendMugwump(row.id, mugwumps[i].bodyColor, mugwumps[i].eyeColor, mugwumps[i].pupilColor, mugwumps[i].mouthColor);
            mugwump_body.style.width = '1rem';
            mugwump_body.style.height = '1rem';
            mugwump_body.style.display = 'inline-flex';
            row_dist = document.createElement('span');
            if (mugwumps[i].found) {                
                row_dist.innerHTML = ' FOUND!';
            } else {
                dx = mugwumps[i].x - pos.x;
                dy = mugwumps[i].y - pos.y;
                dist = Math.sqrt(dx * dx + dy * dy);
                row_dist.innerHTML = ` is ${dist.toFixed(2)} units away`;
            }
            row_dist.style.paddingLeft = '1.5rem';
            row_dist.className = 'info_line';
            row.appendChild(row_dist);
        }
    }
    remaining = document.createElement('div');
    remaining.innerText = `You have ${settings.MAX_GUESSES - guesses.length} guesses remaining.`    
    remaining.className = 'info_line';
    remaining.style.marginTop = '3rem';
    remaining.style.textAlign = 'center';
    parent.appendChild(remaining);

}

// build the grid that you select mugwumps from.
function buildGrid(parentId) {
    var elem;
    var parent = document.getElementById(parentId);

    // Clear out any children
    removeChildren(parent);
    parent.style.gridTemplateColumns = 'auto repeat(' + settings.GRID_W.toString() + ', 1fr)';
    parent.style.gridTemplateRows = 'repeat(' + settings.GRID_H.toString() + ', 1fr) auto';

    for(var j = settings.GRID_H - 1; j >= 0; j--) {
        // Add the row counter.
        elem = document.createElement('span');
        elem.innerText = j.toString();
        elem.id = 'row_' + j.toString();
        elem.className = 'cell_index';
        parent.appendChild(elem);
        for(var i = 0; i < settings.GRID_W; i++) {
            elem = document.createElement('span');
            elem.id = 'cell_' + j.toString() + '_' + i.toString();
            elem.className = 'cell';
            elem.onclick = cellClick;
            parent.appendChild(elem);
        }
    }
    // axis divider
    elem = document.createElement('span');
    elem.innerHtml = '&nbsp;';
    parent.appendChild(elem);
    for(var i = 0; i < settings.GRID_W; i++) {
        elem = document.createElement('span');
        elem.innerText = i.toString();
        elem.id = 'col_' + i.toString();
        elem.className = 'cell_index';
        parent.appendChild(elem);
    }
}

// A cell on the grid has been clicked.
function cellClick(event) {
    var elem;
    elem = event.srcElement;
    while (elem != null && !elem.id.startsWith('cell_')) {
        elem = elem.parentElement;
    }
    if (elem != null) {
        parts = elem.id.split('_');
        pos.x = parseInt(parts[2]);
        pos.y = parseInt(parts[1]);
        // cell is parts[0]
        updateSelection();
        select();
    }
}

// Have we already guessed this cell?
function isGuessOK(x, y) {
    // Guess is not ok if we already have one at the same position.
    var i, guessOK = true;
    for(i = 0; i < guesses.length; i++) {
        if (guesses[i].x == x && guesses[i].y == y) {
            guessOK = false;
            break;
        }
    }
    return guessOK;
}

// Handle keyboard events.
function keyUpHandler(event) {
    switch(event.code) {
    case 'KeyW':
    case 'ArrowUp':
    case 'KeyA':
    case 'ArrowLeft':
    case 'KeyS':
    case 'ArrowDown':
    case 'KeyD':
    case 'ArrowRight':
        // direction was pressed
        switch(event.code) {
        case 'KeyW':
        case 'ArrowUp':
            pos.y = Math.min(settings.GRID_H - 1, pos.y + 1);
            break;
        case 'KeyA':
        case 'ArrowLeft':
            pos.x = Math.max(0, pos.x - 1);
            break;
        case 'KeyS':
        case 'ArrowDown':
            pos.y = Math.max(0, pos.y - 1);
            break;
        case 'KeyD':
        case 'ArrowRight':
            pos.x = Math.min(settings.GRID_W - 1, pos.x + 1);
            break;
        }
        updateSelection();
        break;
    case 'Space':
    case 'Enter':
        // select current cell.
        select();
        break;
    case 'Escape':
        // start a new game when the escape key has been clicked.
        newGame();
    // default:
    }
}

// Rebuild the interface and start a new game.
function newGame() {
    var i, j, positionOK, x, y;
    guesses = [];
    mugwumps = [];
    for (i = 0; i < settings.COUNT_MUGWUMPS; i++) {
        positionOK = false;
        x = 0;
        y = 0;
        while (!positionOK) {
            x = Math.floor(Math.random() * settings.GRID_W);
            y = Math.floor(Math.random() * settings.GRID_H);
            positionOK = true;
            for(j = 0; j < mugwumps.length; j++) {
                positionOK = positionOK && (mugwumps[j].x != x || mugwumps[j].y != y);
                if (!positionOK) 
                    break;
            }
        }
        color = bodyColors[i % bodyColors.length]
        mugwumps.push({found: false, x: x, y: y, bodyColor: color, eyeColor: WHITE, pupilColor: BLACK, mouthColor: BLACK});
    }
    document.getElementById('message_root').style.visibility = 'hidden';
    buildConsole('console');
    buildGrid('grid');
    updateSelection();
}

// Remove all children of a given node in the html tree.
function removeChildren(elem) {
    while (elem.firstChild){
	elem.removeChild(elem.lastChild);
    }
}

// select a cell in the grid. You may win or lose the game here.
function select() {
    var i, id, x, y
    x = pos.x;
    y = pos.y;
    if (isGuessOK(x, y)) {
        guesses.push({x: x, y: y});
        id = "cell_" + y.toString() + '_' + x.toString();
        document.getElementById(id).className += ' cell_open';
        for(i = 0; i < mugwumps.length; i++) {
            if (mugwumps[i].x == x && mugwumps[i].y == y) { 
                mugwumps[i].found = true;                
                appendMugwump(id, mugwumps[i].bodyColor, mugwumps[i].eyeColor, mugwumps[i].pupilColor, mugwumps[i].mouthColor);
            }
        }
        buildConsole('console');
    }
    updateSelection();
    let mugwumps_remaining = false;
    for(i = 0; i < mugwumps.length; i++) {
        if (!mugwumps[i].found) {
            mugwumps_remaining = true;
            break;
        }
    }
    if (mugwumps_remaining == false) {
        document.getElementById('message_line_1').innerText = 'Congratulations, you won!';
        document.getElementById('message_root').style.visibility = 'visible';
    } else if(guesses.length >= settings.MAX_GUESSES) {
        document.getElementById('message_line_1').innerText = 'Sorry.... you lost.';
        document.getElementById('message_root').style.visibility = 'visible';
    }
}

// move the selection indicator to the current position on the grid.
function updateSelection() {
    let selection = document.getElementById('selection');
    if (selection != null) {
	selection.parentNode.removeChild(selection);
    }
    let selected = document.getElementById('cell_' + pos.y.toString() + '_' + pos.x.toString());
    selection = document.createElement('div');
    selection.id = 'selection';
    selection.className = 'cell_selected';
    selected.appendChild(selection);
}

// Add the event handler.
document.addEventListener('keydown', keyUpHandler, false);

// Start the user out in the middle of the grid.
var pos = {
    x: Math.floor(settings.GRID_W / 2)
    , y: Math.floor(settings.GRID_H /2)
};
newGame();
